import 'package:flutter/material.dart';

class ChatPageView extends StatelessWidget {
  const ChatPageView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chats'),
      ),
      body: Center(
        child: Text('Chat List View'),
      ),
    );
  }
} 