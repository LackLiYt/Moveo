import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/features/post/controller/post_controller.dart';
// Import Appwrite models with alias

// Change to StatefulWidget to manage the list of posts received from the stream
class AccountPostList extends ConsumerWidget {
  const AccountPostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the real-time stream for updates and refresh the user posts provider
    ref.listen(getLatestPostsByUserIdProvider(ref.watch(currentUserAccountProvider).whenData((user) => user?.$id).valueOrNull ?? ''), (previous, next) {
       next.whenData((_) {
        debugPrint('Real-time user post update received, refreshing user posts!');
        // Invalidate the provider for the current user's posts
        ref.invalidate(getPostsByUserIdProvider(ref.watch(currentUserAccountProvider).whenData((user) => user?.$id).valueOrNull ?? ''));
      });
    });

    final currentUserAsync = ref.watch(currentUserAccountProvider);

    return currentUserAsync.when(
      data: (user) {
        if (user == null) {
          return const Center(child: Text('Please log in to view your posts'));
        }

        // Watch the FutureProvider for the current user's posts
        final userPostsAsync = ref.watch(getPostsByUserIdProvider(user.$id));

        return userPostsAsync.when(
          data: (posts) {
            if (posts.isEmpty) {
              return const Center(child: Text('No posts yet.'));
            }

            debugPrint('Displaying ${posts.length} user posts');
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // 3 posts per row like Instagram
                crossAxisSpacing: 1.0,
                mainAxisSpacing: 1.0,
                childAspectRatio: 1.0, // Square aspect ratio for posts
              ),
              itemCount: posts.length,
              shrinkWrap: true,
              primary: false,
              itemBuilder: (context, index) {
                final post = posts[index];
                // We need a compact version of PostCard for grid view
                // For now, let's just show the rear camera image
                return Image.network(
                  post.rearCameraPhotoUrl,
                  fit: BoxFit.cover,
                );
              },
            );
          },
          error: (error, stackTrace) => Center(child: Text('Error loading posts: $error')),
          loading: () => const Center(child: CircularProgressIndicator()),
        );
      },
      error: (error, stackTrace) => Center(child: Text('Error loading user: $error')),
      loading: () => const Center(child: CircularProgressIndicator()),
    );
  }
} 