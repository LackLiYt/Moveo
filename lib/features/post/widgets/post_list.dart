import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/features/post/controller/post_controller.dart';
import 'package:moveo/common/common.dart';
import 'package:moveo/features/post/widgets/post_card.dart';
import 'package:moveo/theme/pallete.dart';

class PostList extends ConsumerWidget {
  const PostList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getPostsProvider).when(
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
        
        debugPrint('Fetched ${posts.length} posts');
        return RefreshIndicator(
          onRefresh: () async {
            ref.refresh(getPostsProvider);
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