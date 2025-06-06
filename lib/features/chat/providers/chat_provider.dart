import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:moveo/models/chat_model.dart';
import 'package:moveo/features/chat/controllers/chat_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/apis/chat_api.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, AsyncValue<List<ChatModel>>>((ref) {
  return ChatNotifier(
    chatAPI: ref.watch(chatAPIProvider),
  );
});

final chatMessagesProvider = StreamProvider.family<List<ChatMessage>, String>((ref, chatId) async* {
  final chatAPI = ref.watch(chatAPIProvider);
  
  // Fetch initial messages
  final initialMessages = await chatAPI.getMessagesForChat(chatId);
  yield initialMessages;

  // Subscribe to real-time updates
  await for (final realtimeMessage in chatAPI.subscribeToMessages(chatId)) {
    // Assuming realtimeMessage.payload contains the new message data
    // You might need to adjust based on the actual structure of RealtimeMessage
    final newMessageData = realtimeMessage.payload;
    final newMessage = ChatMessage.fromMap(newMessageData);
    // To show new messages at the bottom, we add them to the end of the list
    yield [...initialMessages, newMessage];
    }
});

class ChatNotifier extends StateNotifier<AsyncValue<List<ChatModel>>> {
  final ChatAPI _chatAPI;

  ChatNotifier({
    required ChatAPI chatAPI,
  })  : _chatAPI = chatAPI,
        super(const AsyncValue.loading());

  Future<void> loadChats(String uid) async {
    state = const AsyncValue.loading();
    try {
      final chats = await _chatAPI.getUserChats(uid);
      state = AsyncValue.data(chats);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> sendMessage(String chatId, String message) async {
    try {
      await _chatAPI.sendMessage(chatId, message);
      // Reload chats to get the updated list
      final currentUser = state.value?.firstOrNull?.uid;
      if (currentUser != null) {
        await loadChats(currentUser);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createChat(String currentUid, String otherUid) async {
    try {
      await _chatAPI.createChat(currentUid, otherUid);
      // Reload chats to get the updated list
      await loadChats(currentUid);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<ChatModel?> findOrCreateChat(String currentUid, String otherUid) async {
    try {
      // Check if users can chat
      final canChat = await _chatAPI.canChatWithUser(currentUid, otherUid);
      if (!canChat) {
        throw Exception('Cannot chat with this user: You are not friends');
      }

      // Try to find an existing chat
      final existingChats = await _chatAPI.getUserChats(currentUid);
      for (var chat in existingChats) {
        if ((chat.uid == currentUid && chat.otherUid == otherUid) ||
            (chat.uid == otherUid && chat.otherUid == currentUid)) {
          return chat;
        }
      }

      // If no existing chat, create a new one
      await _chatAPI.createChat(currentUid, otherUid);

      // After creating, fetch the chats again to get the new chat's ID and details
      final updatedChats = await _chatAPI.getUserChats(currentUid);
      for (var chat in updatedChats) {
        if ((chat.uid == currentUid && chat.otherUid == otherUid) ||
            (chat.uid == otherUid && chat.otherUid == currentUid)) {
          return chat;
        }
      }
      return null; // Should not happen if creation was successful
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
      rethrow; // Re-throw the exception
    }
  }
}

class ChatProvider extends ChangeNotifier {
  final ChatController _chatController = ChatController();
  Map<String, List<ChatData>>? _chats;
  bool _isLoading = false;

  Map<String, List<ChatData>>? get chats => _chats;
  bool get isLoading => _isLoading;

  Future<void> loadChats(String userId) async {
    _isLoading = true;
    notifyListeners();

    _chats = await _chatController.getUserChats(userId);
    
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> sendMessage({
    required String message,
    required String senderId,
    required String receiverId,
    bool isImage = false,
    bool isGroupInvite = false,
  }) async {
    final success = await _chatController.createNewChat(
      message: message,
      senderId: senderId,
      receiverId: receiverId,
      isImage: isImage,
      isGroupInvite: isGroupInvite,
    );

    if (success) {
      await loadChats(senderId);
    }

    return success;
  }

  Future<void> markMessagesAsSeen(List<String> messageIds) async {
    await _chatController.updateMessageSeen(messageIds);
  }

  Future<void> deleteMessage(String messageId) async {
    await _chatController.deleteChatMessage(messageId);
  }

  Future<void> editMessage({
    required String messageId,
    required String newMessage,
  }) async {
    await _chatController.editChatMessage(
      chatId: messageId,
      newMessage: newMessage,
    );
  }

  Future<String?> uploadImage(InputFile file) async {
    return await _chatController.uploadImage(file);
  }

  String getImageUrl(String imageId) {
    return _chatController.getImageUrl(imageId);
  }
} 