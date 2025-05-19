import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:moveo/models/chat_model.dart';
import 'package:moveo/features/chat/controllers/chat_controller.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/apis/chat_api.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, AsyncValue<List<ChatModel>>>((ref) {
  return ChatNotifier(
    chatAPI: ref.watch(chatAPIProvider),
  );
});

class ChatNotifier extends StateNotifier<AsyncValue<List<ChatModel>>> {
  final ChatAPI _chatAPI;

  ChatNotifier({
    required ChatAPI chatAPI,
  })  : _chatAPI = chatAPI,
        super(const AsyncValue.loading());

  Future<void> loadChats(String userId) async {
    state = const AsyncValue.loading();
    try {
      final chats = await _chatAPI.getUserChats(userId);
      state = AsyncValue.data(chats);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> sendMessage(String chatId, String message) async {
    try {
      await _chatAPI.sendMessage(chatId, message);
      // Reload chats to get the updated list
      final currentUser = state.value?.firstOrNull?.userId;
      if (currentUser != null) {
        await loadChats(currentUser);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> createChat(String otherUserId) async {
    try {
      await _chatAPI.createChat(otherUserId);
      // Reload chats to get the updated list
      final currentUser = state.value?.firstOrNull?.userId;
      if (currentUser != null) {
        await loadChats(currentUser);
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<ChatModel?> findOrCreateChat(String currentUserId, String otherUserId) async {
    try {
      // Try to find an existing chat
      final existingChats = await _chatAPI.getUserChats(currentUserId);
      for (var chat in existingChats) {
        if ((chat.userId == currentUserId && chat.otherUserId == otherUserId) ||
            (chat.userId == otherUserId && chat.otherUserId == currentUserId)) {
          return chat;
        }
      }

      // If no existing chat, create a new one
      await _chatAPI.createChat(otherUserId);

      // After creating, fetch the chats again to get the new chat's ID and details
      final updatedChats = await _chatAPI.getUserChats(currentUserId);
      for (var chat in updatedChats) {
         if ((chat.userId == currentUserId && chat.otherUserId == otherUserId) ||
            (chat.userId == otherUserId && chat.otherUserId == currentUserId)) {
          return chat;
        }
      }
      return null; // Should not happen if creation was successful

    } catch (e, st) {
      // Handle errors (e.g., show a snackbar)
      print('Error finding or creating chat: $e');
      return null;
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