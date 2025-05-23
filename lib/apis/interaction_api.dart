import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:moveo/constants/appwrite_constants.dart';
import 'package:moveo/core/core.dart';
import 'package:moveo/core/providers.dart';
import 'package:moveo/models/comment_model.dart';
import 'package:moveo/models/like_model.dart';

final interactionAPIProvider = Provider((ref) {
  return InteractionAPI(
    db: ref.watch(appwriteDatabaseProvider),
  );
});

abstract class IInteractionAPI {
  FutureEitherVoid addComment(Comment comment);
  FutureEither<List<Comment>> getCommentsForPost(String postId);
  FutureEitherVoid toggleLike(Like like);
  FutureEither<bool> hasUserLikedPost(String postId, String userId);
}

class InteractionAPI implements IInteractionAPI {
  final Databases _db;
  
  InteractionAPI({required Databases db}) : _db = db;

  @override
  FutureEitherVoid addComment(Comment comment) async {
    try {
      // Get current comments count and existing comment IDs
      final post = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postCollectionId,
        documentId: comment.postId,
      );
      
      final currentCommentIds = List<String>.from(post.data['commentIds'] ?? []);

      // Create the comment
      final newCommentDocument = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.commentsCollectionId,
        documentId: ID.unique(),
        data: comment.toMap(),
      );
      
      // Update post's comment count and add the new comment ID
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postCollectionId,
        documentId: comment.postId,
        data: {
          'commentsCount': (post.data['commentsCount'] ?? 0) + 1,
          'commentIds': [...currentCommentIds, newCommentDocument.$id],
        },
      );
      
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Error adding comment', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<List<Comment>> getCommentsForPost(String postId) async {
    try {
      final response = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.commentsCollectionId,
        queries: [
          Query.equal('postId', postId),
          Query.orderDesc('createdAt'),
        ],
      );

      final comments = response.documents
          .map((doc) => Comment.fromMap(doc.data))
          .toList();
          
      return right(comments);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Error fetching comments', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEitherVoid toggleLike(Like like) async {
    try {
      // Check if like exists
      final existingLikes = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.likesCollectionId,
        queries: [
          Query.equal('postId', like.postId),
          Query.equal('uid', like.uid),
        ],
      );

      if (existingLikes.documents.isEmpty) {
        // Add like
        await _db.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.likesCollectionId,
          documentId: ID.unique(),
          data: like.toMap(),
        );
        
        // Get current likes count
        final post = await _db.getDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.postCollectionId,
          documentId: like.postId,
        );
        
        // Increment likes count
        await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.postCollectionId,
          documentId: like.postId,
          data: {
            'likesCount': (post.data['likesCount'] ?? 0) + 1,
          },
        );
      } else {
        // Remove like
        await _db.deleteDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.likesCollectionId,
          documentId: existingLikes.documents.first.$id,
        );
        
        // Get current likes count
        final post = await _db.getDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.postCollectionId,
          documentId: like.postId,
        );
        
        // Decrement likes count
        await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.postCollectionId,
          documentId: like.postId,
          data: {
            'likesCount': (post.data['likesCount'] ?? 0) - 1,
          },
        );
      }
      
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Error toggling like', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<bool> hasUserLikedPost(String postId, String userId) async {
    try {
      final response = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.likesCollectionId,
        queries: [
          Query.equal('postId', postId),
          Query.equal('uid', userId),
        ],
      );
      return right(response.documents.isNotEmpty);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Error checking like status', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
} 