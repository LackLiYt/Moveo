import 'package:flutter/material.dart';
import 'package:flutter_chat_ui/flutter_chat_ui.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;

class ChatView extends StatefulWidget {
  const ChatView({Key? key}) : super(key: key);

  @override
  _ChatViewState createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final List<types.Message> _messages = [];
  final _user = const types.User(id: 'current_user_id');
  final _otherUser = const types.User(id: 'other_user_id');

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final chatTheme = isDarkMode
        ? const DefaultChatTheme(
            primaryColor: Colors.white, // Current user bubble color (White)
            secondaryColor: Colors.black, // Other user bubble color (Black)
            userNameTextStyle: TextStyle(color: Colors.black), // User name color (Black)
            sentMessageBodyTextStyle: TextStyle(color: Colors.black), // Sent text color (Black)
            receivedMessageBodyTextStyle: TextStyle(color: Colors.white), // Received text color (White)
            inputBackgroundColor: Colors.white, // Input field background color (White)
            inputTextColor: Colors.black, // Input text color (Black)
            inputTextDecoration: InputDecoration(hintStyle: TextStyle(color: Colors.black54)), // Input hint text color
          )
        : const DefaultChatTheme(
            primaryColor: Colors.black, // Current user bubble color (Black)
            secondaryColor: Colors.white, // Other user bubble color (White)
            userNameTextStyle: TextStyle(color: Colors.white), // User name color (White)
            sentMessageBodyTextStyle: TextStyle(color: Colors.white), // Sent text color (White)
            receivedMessageBodyTextStyle: TextStyle(color: Colors.black), // Received text color (Black)
            inputBackgroundColor: Colors.black, // Input field background color (Black)
            inputTextColor: Colors.white, // Input text color (White)
            inputTextDecoration: InputDecoration(hintStyle: TextStyle(color: Colors.white54)), // Input hint text color
          );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat View'),
      ),
      body: Chat(
        messages: _messages,
        onSendPressed: _handleSendPressed,
        user: _user,
        theme: chatTheme,
      ),
    );
  }

  void _handleSendPressed(types.PartialText message) {
    final textMessage = types.TextMessage(
      author: _user,
      createdAt: DateTime.now().millisecondsSinceEpoch,
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      text: message.text,
    );

    setState(() {
      _messages.insert(0, textMessage);
    });
  }

  // Add a dummy received message for testing
  void _addReceivedMessage() {
    final receivedMessage = types.TextMessage(
      author: _otherUser,
      createdAt: DateTime.now().millisecondsSinceEpoch + 1,
      id: (DateTime.now().millisecondsSinceEpoch + 1).toString(),
      text: "This is a received message.",
    );
    setState(() {
      _messages.insert(0, receivedMessage);
    });
  }

  @override
  void initState() {
    super.initState();
    // Add some initial messages for demonstration
    _addReceivedMessage();
    _handleSendPressed(types.PartialText(text: "Hi there!"));
  }
}