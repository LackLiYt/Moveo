import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/features/chat/providers/chat_provider.dart';
import 'package:moveo/models/chat_model.dart';
import 'package:moveo/features/chat/widgets/chat_message_tile.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';

class ChatView extends ConsumerStatefulWidget {
  final ChatModel chat;

  const ChatView({
    super.key,
    required this.chat,
  });

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final messageController = TextEditingController();

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  void sendMessage() {
    if (messageController.text.trim().isEmpty) return;
    
    ref.read(chatProvider.notifier).sendMessage(
      widget.chat.id,
      messageController.text.trim(),
    );
    
    messageController.clear();
  }

  @override
  Widget build(BuildContext context) {
    final messagesAsyncValue = ref.watch(chatMessagesProvider(widget.chat.id));
    final currentUser = ref.watch(currentUserAccountProvider).value;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.chat.otherUserProfilePic),
            ),
            const SizedBox(width: 8),
            Text(widget.chat.otherUserName),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsyncValue.when(
              data: (messages) {
                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[index];
                    final isCurrentUser = currentUser != null && message.senderId == currentUser.$id;
                    return ChatMessageTile(
                      message: message,
                      isCurrentUser: isCurrentUser,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stackTrace) => Center(child: Text('Error: ${error.toString()}')),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: messageController,
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}