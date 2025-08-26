import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/constants/appwrite_constants.dart';
import 'package:moveo/core/core.dart';
import 'package:moveo/core/providers.dart';
import 'package:moveo/models/chat_model.dart';
import 'package:moveo/features/friends/friends_providers.dart';
import 'package:moveo/apis/friend_service.dart';

final chatAPIProvider = Provider((ref) {
  return ChatAPI(
    db: ref.watch(appwriteDatabaseProvider),
    realtime: ref.watch(appwriteRealtimeProvider),
    friendService: ref.watch(friendServiceProvider),
  );
});

abstract class IChatAPI {
  Future<List<ChatModel>> getUserChats(String uid);
  Future<void> sendMessage(String chatId, String message);
  Future<void> createChat(String currentUid, String otherUid);
  Future<List<ChatMessage>> getMessagesForChat(String chatId);
  Future<bool> canChatWithUser(String currentUid, String otherUid);
}

class ChatAPI implements IChatAPI {
  final Databases _db;
  final Realtime _realtime;
  final FriendService _friendService;

  ChatAPI({
    required Databases db,
    required Realtime realtime,
    required FriendService friendService,
  })  : _db = db,
        _realtime = realtime,
        _friendService = friendService;

  @override
  Future<List<ChatModel>> getUserChats(String uid) async {
    try {
      final response = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.chatsCollectionId,
        queries: [
          Query.equal('uid', uid),
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
  Future<void> createChat(String currentUid, String otherUid) async {
    try {
      // Check if users are friends
      final canChat = await canChatWithUser(currentUid, otherUid);
      if (!canChat) {
        throw Exception('Cannot create chat: Users are not friends');
      }

      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.chatsCollectionId,
        documentId: ID.unique(),
        data: {
          'uid': currentUid,
          'otherUid': otherUid,
          'createdAt': DateTime.now().toIso8601String(),
          'lastMessage': '',
          'lastMessageTime': DateTime.now().toIso8601String(),
        },
        permissions: [
          Permission.read(Role.user(currentUid)),
          Permission.read(Role.user(otherUid)),
          Permission.write(Role.user(currentUid)),
          Permission.write(Role.user(otherUid)),
        ],
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

  @override
  Future<bool> canChatWithUser(String currentUid, String otherUid) async {
    try {
      final friends = await _friendService.getFriends(currentUid);
      return friends.any((friend) => friend.friendId == otherUid);
    } catch (e) {
      return false;
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