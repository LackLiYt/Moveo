import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/apis/post_api.dart';
import 'package:moveo/apis/storage_api.dart';
import 'package:moveo/core/utils.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/models/post_model.dart';
import 'package:moveo/features/progress/controller/progress_controller.dart';
import 'package:moveo/models/user_model.dart';

final postControllerProvider = StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
    ref: ref,
    postAPI: ref.watch(postAPIProvider),
    storageAPI: ref.watch(storageAPIProvider),
  );
});

final getPostsProvider = FutureProvider((ref) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController.getPosts();
});

final getPostsByUserIdProvider = FutureProvider.family((ref, String userId) {
  final postController = ref.watch(postControllerProvider.notifier);
  return postController._postAPI.getPostsByUserId(userId).then(
    (posts) => posts.map((post) => Post.fromMap(post.data)).toList(),
  );
});

final getLatestPostsProvider = StreamProvider((ref) {
  final postAPI = ref.watch(postAPIProvider);
  return postAPI.getLatestPosts().where((event) => event.events.any((e) => e.startsWith('databases.*.collections.*.documents.*.'))
  ).map((event) => true);
});

final getLatestPostsByUserIdProvider = StreamProvider.family((ref, String userId) {
   final postAPI = ref.watch(postAPIProvider);
  return postAPI.getLatestPostsByUserId(userId).where((event) => event.events.any((e) => e.startsWith('databases.*.collections.*.documents.*.'))
  ).map((event) => true);
});

class PostController extends StateNotifier<bool> {
  final PostAPI _postAPI;
  final Ref _ref;
  final StorageAPI _storage;
  PostController({
    required Ref ref,
    required PostAPI postAPI,
    required StorageAPI storageAPI,
  }):
    _ref = ref,
    _postAPI = postAPI,
    _storage = storageAPI,
    super(false);

  Future<List<Post>> getPosts() async {
    final postList = await _postAPI.getPosts();
    return postList.map((post) => Post.fromMap(post.data)).toList();
  }

  void sharePost({
    required File rearCameraPhoto,
    required File frontCameraPhoto,
    String? text,
    required BuildContext context,
  }) async {
    // Check for null files (should never happen due to UI guards, but just to be safe)
    if (rearCameraPhoto.path.isEmpty || frontCameraPhoto.path.isEmpty) {
      showSnackBar(context, 'Invalid photo files');
      return;
    }

    // Verify files exist
    if (!rearCameraPhoto.existsSync() || !frontCameraPhoto.existsSync()) {
      showSnackBar(context, 'Photo files not found');
      return;
    }

    // Debug log for text
    debugPrint('Saving post with text: "$text"');

    state = true;
    try {
      // Process text if provided
      final caption = text?.trim();
      final hashtags = caption != null && caption.isNotEmpty 
          ? _getHastagsFromText(caption) 
          : <String>[];
      final link = caption != null && caption.isNotEmpty 
          ? _getLinkFromText(caption) 
          : null;
      
      // Get current user account - this is most reliable
      final userAccount = await _ref.read(currentUserAccountProvider.future);
      if (userAccount == null) {
        showSnackBar(context, 'Authentication error: Please log in again');
        state = false;
        return;
      }
      
      // Use the account ID directly
      final userId = userAccount.$id;
      
      // Upload both photos
      final List<File> rearPhotoList = [rearCameraPhoto];
      final List<File> frontPhotoList = [frontCameraPhoto];
      
      final rearPhotoUrls = await _storage.uploadImage(rearPhotoList);
      final frontPhotoUrls = await _storage.uploadImage(frontPhotoList);
      
      if (rearPhotoUrls.isEmpty || frontPhotoUrls.isEmpty) {
        showSnackBar(context, 'Failed to upload photos');
        state = false;
        return;
      }

      // Create post with explicit text handling
      final post = Post(
        rearCameraPhotoUrl: rearPhotoUrls[0],
        frontCameraPhotoUrl: frontPhotoUrls[0],
        text: caption != null && caption.isNotEmpty ? caption : null,
        hashtags: List<String>.from(hashtags),
        link: link,
        uid: userId,
        createdAt: DateTime.now(),
        likes: const [],
        commentIds: const [],
        id: '',
      );

      // Debug data before submitting
      debugPrint('Post data: ${post.toMap()}');

      final res = await _postAPI.sharePost(post);
      
      if (mounted) {
        res.fold(
          (l) => showSnackBar(context, l.massage),
          (r) async {
            // Get current user model
            final userModel = await _ref.read(getUserDetailsByIdProvider(userId).future);
            userModel.fold(
              (l) => showSnackBar(context, 'Error updating progress: ${l.massage}'),
              (document) async {
                // Convert document to UserModel
                final user = UserModel.fromMap(document.data);
                // Update user progress for creating a post
                await _ref.read(progressControllerProvider.notifier).updateProgressForPost();
                showSnackBar(context, 'Post shared successfully!');
                Navigator.pop(context); // Close the post creation screen
              },
            );
          },
        );
      }
    } catch (e) {
      if (mounted) {
        showSnackBar(context, 'Error sharing post: $e');
      }
    } finally {
      state = false;
    }
  }

  String? _getLinkFromText(String text) {
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        return word;
      }
    }
    return null;
  }

  List<String> _getHastagsFromText(String text) {
    List<String> hastags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('#')) {
        hastags.add(word);
      }
    }
    return hastags;
  }
}