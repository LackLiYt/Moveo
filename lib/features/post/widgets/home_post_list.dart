import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/features/post/controller/post_controller.dart';
import 'package:moveo/common/common.dart';
import 'package:moveo/features/post/widgets/post_card.dart';
import 'package:moveo/theme/pallete.dart';

// Change to StatefulWidget to manage the list of posts received from the stream
class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Listen to the real-time stream for updates and refresh the posts provider
    ref.listen(getLatestPostsProvider, (previous, next) {
      next.whenData((_) {
        debugPrint('Real-time update received, refreshing posts!');
        ref.invalidate(getPostsProvider); // Invalidate to refetch latest data
      });
    });

    // Watch the FutureProvider for the list of posts
    final postsAsyncValue = ref.watch(getPostsProvider);

    return postsAsyncValue.when(
      data: (posts) {
        if (posts.isEmpty) {
          return Center(
            child: Text(
              'No posts yet. Be the first to share!',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
              ),
            ),
          );
        }
        
        debugPrint('Displaying ${posts.length} posts');
        // RefreshIndicator can still be useful for manual pull-to-refresh
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(getPostsProvider); // Allow manual refresh as well
          },
          child: ListView.builder(
            itemCount: posts.length,
            itemBuilder: (BuildContext context, int index) {
              final post = posts[index];
              debugPrint('Building post at index $index: ${post.id}');
              return PostCard(post: post);
            },
          ),
        );
      },
      error: (error, stackTrace) {
        debugPrint('Error fetching posts: $error');
        return ErrorText(error: error.toString());
      },
      loading: () => const Center(child: Loader()),
    );
  }
}