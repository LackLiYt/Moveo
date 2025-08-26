import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/features/friends/friends_providers.dart';

class FriendListView extends ConsumerWidget {
  const FriendListView({super.key});

  static route() => MaterialPageRoute(
        builder: (context) => const FriendListView(),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final friendsAsync = ref.watch(friendsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends'),
      ),
      body: friendsAsync.when(
        data: (friends) {
          if (friends.isEmpty) {
            return const Center(
              child: Text('You have no friends yet.'),
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
                title: Text(friend.friendId),
                // You can add more details here like status if available in the Friend model
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading friends: $error'),
        ),
      ),
    );
  }
} 