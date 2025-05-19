import 'package:flutter/material.dart';
import 'package:appwrite/appwrite.dart';
import 'package:moveo/constants/appwrite_constants.dart';
import 'package:moveo/features/chat/views/chat_view.dart';
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/features/chat/providers/chat_provider.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';

class AddChatPage extends ConsumerStatefulWidget {
  const AddChatPage({super.key});

  @override
  ConsumerState<AddChatPage> createState() => _AddChatPageState();
}

class _AddChatPageState extends ConsumerState<AddChatPage> {
  final TextEditingController _searchController = TextEditingController();
  final Client client = Client()
    .setEndpoint(AppwriteConstants.endPoint)
    .setProject(AppwriteConstants.projectId)
    .setSelfSigned(status: true);
  late final Databases databases;
  List<Map<String, dynamic>> _searchResults = [];
  bool _isLoading = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    databases = Databases(client);
  }

  Future<void> _searchUsers(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    // Cancel previous timer if it exists
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    // Set new timer
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      setState(() {
        _isLoading = true;
      });

      try {
        final result = await databases.listDocuments(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollectionId,
          queries: [
            Query.search('name', query),
            Query.limit(10),
            Query.orderDesc('name'),
          ],
        );

        if (mounted) {
          setState(() {
            _searchResults = result.documents.map((doc) => doc.data).toList();
            _isLoading = false;
          });
        }
      } catch (e) {
        print('Error searching users: $e');
        if (mounted) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error searching users. Please try again.'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Chat'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search users by name...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          _searchUsers('');
                        },
                      )
                    : null,
              ),
              onChanged: _searchUsers,
              textInputAction: TextInputAction.search,
            ),
          ),
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: LinearProgressIndicator(),
            ),
          Expanded(
            child: _searchResults.isEmpty && !_isLoading
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.search,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchController.text.isEmpty
                              ? 'Search for users to start a chat'
                              : 'No users found',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: _searchResults.length,
                    itemBuilder: (context, index) {
                      final user = _searchResults[index];
                      final String otherUserId = user['\$id'];
                      
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: user['profile_pic'] != null
                              ? NetworkImage(user['profile_pic'])
                              : null,
                          child: user['profile_pic'] == null
                              ? const Icon(Icons.person)
                              : null,
                        ),
                        title: Text(
                          user['name'] ?? 'Unknown User',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          user['email'] ?? '',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        onTap: () async {
                          final currentUser = await ref.read(currentUserAccountProvider.future);
                          if (currentUser != null) {
                            final chat = await ref.read(chatProvider.notifier).findOrCreateChat(currentUser.$id, otherUserId);
                            if (chat != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatView(chat: chat),
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Could not open or create chat.'),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please log in to start a chat.'),
                                duration: Duration(seconds: 2),
                              ),
                            );
                          }
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
