import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/features/chat/providers/chat_provider.dart';
import 'package:moveo/models/user_model.dart';

class AddChatPage extends ConsumerStatefulWidget {
  const AddChatPage({super.key});

  @override
  ConsumerState<AddChatPage> createState() => _AddChatPageState();
}

class _AddChatPageState extends ConsumerState<AddChatPage> {
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    // Removed invalidation from initState
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Invalidate the provider to ensure fresh data after dependencies change
    ref.invalidate(allUsersProvider);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _startChat(UserModel user) async {
    setState(() => _isLoading = true);
    try {
      final currentUser = await ref.read(currentUserAccountProvider.future);
      if (currentUser == null) {
        throw Exception('User not logged in');
      }

      final chat = await ref.read(chatProvider.notifier).findOrCreateChat(
        currentUser.$id,
        user.uid,
      );

      if (chat != null && mounted) {
        Navigator.pop(context, chat);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error starting chat: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showStartChatDialog(UserModel user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Start Chat'),
        content: Text('Do you want to start a chat with ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startChat(user);
            },
            child: const Text('Start Chat'),
          ),
        ],
      ),
    );
  }

  List<UserModel> _filterFriends(List<UserModel> users) {
    if (_searchQuery.isEmpty) return users;
    return users.where((user) {
      final name = user.name.toLowerCase();
      final query = _searchQuery.toLowerCase();
      return name.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final allUsersAsync = ref.watch(allUsersProvider);

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
                hintText: 'Search friends...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : allUsersAsync.when(
                    data: (users) {
                      final filteredUsers = _filterFriends(users);
                      
                      if (filteredUsers.isEmpty) {
                        return Center(
                          child: Text(
                            _searchQuery.isEmpty
                                ? 'No users found.'
                                : 'No users found matching "$_searchQuery"',
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: filteredUsers.length,
                        itemBuilder: (context, index) {
                          final user = filteredUsers[index];
                          return ListTile(
                            leading: const CircleAvatar(
                              child: Icon(Icons.person),
                            ),
                            title: Text(user.name),
                            subtitle: Text(user.email),
                            onTap: () => _showStartChatDialog(user),
                          );
                        },
                      );
                    },
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (error, stack) => Center(
                      child: Text('Error loading users: $error'),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
