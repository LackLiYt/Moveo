import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/models/post_model.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final Post post;
  const CommentsScreen({super.key, required this.post});

  @override
  ConsumerState<CommentsScreen> createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  final TextEditingController _commentController = TextEditingController();

  void postComment() {
    final text = _commentController.text.trim();
    if (text.isNotEmpty) {
      // TODO: Додати логіку збереження коментаря до Firebase або ін.
      print('Коментар: $text для поста ${widget.post.id}');
      _commentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Коментарі')),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              // TODO: замінити на динамічне отримання з бази
              children: const [
                ListTile(title: Text("Приклад коментаря")),
                ListTile(title: Text("Ще один коментар")),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Написати коментар...',
                    ),
                  ),
                ),
                IconButton(
                  onPressed: postComment,
                  icon: const Icon(Icons.comment_outlined),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
