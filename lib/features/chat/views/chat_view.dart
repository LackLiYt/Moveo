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
  bool _isLoading = false;

  @override
  void dispose() {
    messageController.dispose();
    super.dispose();
  }

  Future<void> sendMessage() async {
    if (messageController.text.trim().isEmpty) return;
    
    setState(() => _isLoading = true);
    try {
      await ref.read(chatProvider.notifier).sendMessage(
        widget.chat.id,
        messageController.text.trim(),
      );
      messageController.clear();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending message: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
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
              backgroundImage: widget.chat.otherUserProfilePic.isNotEmpty
                  ? NetworkImage(widget.chat.otherUserProfilePic)
                  : null,
              child: widget.chat.otherUserProfilePic.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.chat.otherUserName),
                const Text(
                  'Friend',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: messagesAsyncValue.when(
              data: (messages) {
                if (messages.isEmpty) {
                  return const Center(
                    child: Text('No messages yet. Start the conversation!'),
                  );
                }

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final message = messages[messages.length - 1 - index];
                    final isCurrentUser = message.senderId == currentUser?.$id;
                    return ChatMessageTile(
                      message: message,
                      isCurrentUser: isCurrentUser,
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error loading messages: $error'),
              ),
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
                    enabled: !_isLoading,
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: _isLoading ? null : sendMessage,
                  icon: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(),
                        )
                      : const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}