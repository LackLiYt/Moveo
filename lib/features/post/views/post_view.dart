import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/features/post/controller/post_controller.dart';
import 'package:moveo/models/post_model.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:moveo/features/auth/controller/auth_controller.dart';


class PostView extends ConsumerWidget {
  const PostView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final postsAsync = ref.watch(getPostsProvider);

    return postsAsync.when(
      data: (posts) {
        if (posts.isEmpty) {
          return const Center(
            child: Text('No posts yet. Be the first to post!'),
          );
        }

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index];
            return PostCard(post: post);
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }
}

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserAccountProvider).value;
    
    return Card(
      margin: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Post header with user info
          ListTile(
            leading: const CircleAvatar(
              // TODO: Add user profile picture
              child: Icon(Icons.person),
            ),
            title: Text(
              'User ${post.uid.substring(0, 8)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              timeago.format(post.createdAt),
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          
          // Photo display
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                // Rear camera photo (background)
                Image.network(
                  post.rearCameraPhotoUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                // Front camera photo (overlay)
                Positioned(
                  right: 16,
                  bottom: 16,
                  width: 120,
                  height: 160,
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white, width: 2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: Image.network(
                        post.frontCameraPhotoUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Post text (if any)
          if (post.text?.isNotEmpty ?? false)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(post.text!),
            ),
          
          // Post actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(
                    post.likesCount > 0 ? Icons.favorite : Icons.favorite_border,
                    color: post.likesCount > 0 ? Colors.red : null,
                  ),
                  onPressed: () {
                    if (currentUser != null) {
                      ref.read(postControllerProvider.notifier).toggleLike(
                        post.id,
                        currentUser.$id,
                      );
                    }
                  },
                ),
                Text('${post.likesCount}'),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.comment),
                  onPressed: () {
                    // TODO: Implement comment functionality
                  },
                ),
                Text('${post.commentsCount}'),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 