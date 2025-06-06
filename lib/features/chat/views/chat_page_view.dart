import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/features/chat/views/add_chat_page.dart';
import 'package:moveo/features/chat/providers/chat_provider.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/features/chat/views/chat_view.dart';
import 'package:moveo/models/chat_model.dart';

class ChatPageView extends ConsumerStatefulWidget {
  const ChatPageView({super.key});

  @override
  ConsumerState<ChatPageView> createState() => _ChatPageViewState();
}

class _ChatPageViewState extends ConsumerState<ChatPageView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final currentUser = ref.read(currentUserAccountProvider).value;
      if (currentUser != null) {
        ref.read(chatProvider.notifier).loadChats(currentUser.$id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserAccountProvider);
    
    return currentUser.when(
      data: (user) {
        if (user == null) {
          return const Center(child: Text('Please log in to view chats'));
        }
        
        final chats = ref.watch(chatProvider);
        
        return Scaffold(
          appBar: AppBar(
            title: const Text('Chats'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  final chat = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AddChatPage()),
                  );
                  if (chat != null && chat is ChatModel) {
                    if (!context.mounted) return;
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatView(chat: chat),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
          body: chats.when(
            data: (chatList) {
              if (chatList.isEmpty) {
                return const Center(child: Text('No chats yet'));
              }
              return ListView.builder(
                itemCount: chatList.length,
                itemBuilder: (context, index) {
                  final chat = chatList[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(chat.otherUserProfilePic),
                    ),
                    title: Text(chat.otherUserName),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatView(chat: chat),
                        ),
                      );
                    },
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('Error: $error')),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
} 