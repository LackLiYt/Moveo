import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:moveo/constants/appwrite_constants.dart';
import 'package:moveo/core/core.dart';
import 'package:moveo/core/providers.dart';
import 'package:moveo/models/chat_model.dart';

final chatAPIProvider = Provider((ref) {
  return ChatAPI(
    db: ref.watch(appwriteDatabaseProvider),
  );
});

abstract class IChatAPI {
  Future<List<ChatModel>> getUserChats(String userId);
  Future<void> sendMessage(String chatId, String message);
  Future<void> createChat(String otherUserId);
}

class ChatAPI implements IChatAPI {
  final Databases _db;
  ChatAPI({required Databases db}) : _db = db;

  @override
  Future<List<ChatModel>> getUserChats(String userId) async {
    try {
      final response = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.chatsCollectionId,
        queries: [
          Query.equal('participants', userId),
        ],
      );

      return response.documents.map((doc) => ChatModel.fromMap(doc.data)).toList();
    } on AppwriteException catch (e, st) {
      throw Failure(e.message ?? 'Error fetching chats', st);
    } catch (e, st) {
      throw Failure(e.toString(), st);
    }
  }

  @override
  Future<void> sendMessage(String chatId, String message) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.messagesCollectionId,
        documentId: ID.unique(),
        data: {
          'chatId': chatId,
          'message': message,
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    } on AppwriteException catch (e, st) {
      throw Failure(e.message ?? 'Error sending message', st);
    } catch (e, st) {
      throw Failure(e.toString(), st);
    }
  }

  @override
  Future<void> createChat(String otherUserId) async {
    try {
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.chatsCollectionId,
        documentId: ID.unique(),
        data: {
          'participants': [otherUserId],
          'createdAt': DateTime.now().toIso8601String(),
        },
      );
    } on AppwriteException catch (e, st) {
      throw Failure(e.message ?? 'Error creating chat', st);
    } catch (e, st) {
      throw Failure(e.toString(), st);
    }
  }
} 