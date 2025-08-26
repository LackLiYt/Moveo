import 'package:flutter/material.dart';
import 'package:moveo/models/chat_model.dart';

class ChatMessageTile extends StatelessWidget {
  final ChatMessage message;
  final bool isCurrentUser;

  const ChatMessageTile({
    super.key,
    required this.message,
    required this.isCurrentUser,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: isCurrentUser ? Colors.blue[100] : Colors.grey[300],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(message.message),
      ),
    );
  }
} 