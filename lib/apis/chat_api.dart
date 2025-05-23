import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/constants/appwrite_constants.dart';
import 'package:moveo/core/core.dart';
import 'package:moveo/core/providers.dart';
import 'package:moveo/models/chat_model.dart';

final chatAPIProvider = Provider((ref) {
  return ChatAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
  );
});

abstract class IChatAPI {
  Future<List<ChatModel>> getUserChats(String userId);
  Future<void> sendMessage(String chatId, String message);
  Future<void> createChat(String otherUserId);
  Future<List<ChatMessage>> getMessagesForChat(String chatId);
}

class ChatAPI implements IChatAPI {
  final Databases _db;
  final Realtime _realtime;
  ChatAPI({required Databases db, required Realtime realtime})
      : _db = db,
        _realtime = realtime;

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

  @override
  Future<List<ChatMessage>> getMessagesForChat(String chatId) async {
    try {
      final response = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.messagesCollectionId,
        queries: [
          Query.equal('chatId', chatId),
          Query.orderAsc('timestamp'),
        ],
      );
      return response.documents.map((doc) => ChatMessage.fromMap(doc.data)).toList();
    } on AppwriteException catch (e, st) {
      throw Failure(e.message ?? 'Error fetching messages', st);
    } catch (e, st) {
      throw Failure(e.toString(), st);
    }
  }

  // Subscribe to real-time message updates for a specific chat
  Stream<RealtimeMessage> subscribeToMessages(String chatId) {
    return _realtime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.messagesCollectionId}.documents',
    ]).stream.where((event) =>
        event.events.contains('databases.*.collections.*.documents.*.create') &&
        (event.payload as Map<String, dynamic>?)?['chatId'] == chatId);
  }
} 