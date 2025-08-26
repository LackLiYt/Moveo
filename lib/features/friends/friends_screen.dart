import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/friend.dart';
import '../../apis/friend_service.dart';
import 'friends_providers.dart';
import '../../features/auth/controller/auth_controller.dart';

class FriendsScreen extends ConsumerStatefulWidget {
  const FriendsScreen({super.key});

  @override
  ConsumerState<FriendsScreen> createState() => _FriendsScreenState();
}

class _FriendsScreenState extends ConsumerState<FriendsScreen> {
  late FriendService _friendService;
  final bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _friendService = ref.read(friendServiceProvider);
  }

  @override
  Widget build(BuildContext context) {
    final friendsAsync = ref.watch(friendsProvider);
    final pendingRequestsAsync = ref.watch(pendingRequestsProvider);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Friends'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Friends'),
              Tab(text: 'Requests'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildFriendsList(friendsAsync),
            _buildPendingRequestsList(pendingRequestsAsync),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => _showAddFriendDialog(),
          child: const Icon(Icons.person_add),
        ),
      ),
    );
  }

  Widget _buildFriendsList(AsyncValue<List<Friend>> friendsAsync) {
    return friendsAsync.when(
      data: (friends) {
        if (friends.isEmpty) {
          return const Center(
            child: Text('No friends yet. Add some friends!'),
          );
        }

        return ListView.builder(
          itemCount: friends.length,
          itemBuilder: (context, index) {
            final friend = friends[index];
            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(friend.friendId), // You might want to show the friend's name instead
              trailing: IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () => _removeFriend(friend),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading friends: $error'),
      ),
    );
  }

  Widget _buildPendingRequestsList(AsyncValue<List<Friend>> requestsAsync) {
    return requestsAsync.when(
      data: (requests) {
        if (requests.isEmpty) {
          return const Center(
            child: Text('No pending friend requests'),
          );
        }

        return ListView.builder(
          itemCount: requests.length,
          itemBuilder: (context, index) {
            final request = requests[index];
            return ListTile(
              leading: const CircleAvatar(
                child: Icon(Icons.person),
              ),
              title: Text(request.uid), // You might want to show the user's name instead
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () => _acceptRequest(request),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.red),
                    onPressed: () => _rejectRequest(request),
                  ),
                ],
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading requests: $error'),
      ),
    );
  }

  Future<void> _showAddFriendDialog() async {
    final controller = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Friend'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Friend ID',
            hintText: 'Enter your friend\'s ID',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              if (controller.text.isNotEmpty) {
                await _sendFriendRequest(controller.text);
                if (mounted) Navigator.pop(context);
              }
            },
            child: const Text('Send Request'),
          ),
        ],
      ),
    );
  }

  Future<void> _sendFriendRequest(String friendId) async {
    try {
      final currentUser = await ref.read(currentUserAccountProvider.future);
      if (currentUser != null) {
        await _friendService.sendFriendRequest(currentUser.$id, friendId);
        ref.invalidate(friendsProvider);
        ref.invalidate(pendingRequestsProvider);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Friend request sent!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error sending friend request: $e')),
        );
      }
    }
  }

  Future<void> _acceptRequest(Friend request) async {
    try {
      await _friendService.acceptFriendRequest(request.id);
      ref.invalidate(friendsProvider);
      ref.invalidate(pendingRequestsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Friend request accepted!')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error accepting friend request: $e')),
        );
      }
    }
  }

  Future<void> _rejectRequest(Friend request) async {
    try {
      await _friendService.rejectFriendRequest(request.id);
      ref.invalidate(friendsProvider);
      ref.invalidate(pendingRequestsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Friend request rejected')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error rejecting friend request: $e')),
        );
      }
    }
  }

  Future<void> _removeFriend(Friend friend) async {
    try {
      await _friendService.removeFriend(friend.id);
      ref.invalidate(friendsProvider);
      ref.invalidate(pendingRequestsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Friend removed')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error removing friend: $e')),
        );
      }
    }
  }
} 