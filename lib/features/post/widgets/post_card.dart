import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/features/post/widgets/hashtag_text.dart';
import 'package:moveo/models/post_model.dart';
import 'package:moveo/common/common.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/models/user_model.dart';
import 'package:moveo/theme/theme.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:moveo/features/post/widgets/comment_post.dart';
import 'package:moveo/apis/interaction_api.dart';
import 'package:moveo/models/like_model.dart';

final isPostLikedProvider = FutureProvider.family<bool, String>((ref, postId) async {
  final currentUser = ref.watch(currentUserAccountProvider).value;
  if (currentUser == null) return false;
  final result = await ref.read(interactionAPIProvider).hasUserLikedPost(postId, currentUser.$id);
  return result.fold(
    (failure) => false,
    (isLiked) => isLiked,
  );
});

class LikeButton extends ConsumerStatefulWidget {
  final String postId;
  final int likeCount;
  final bool isLiked;

  const LikeButton({
    super.key, 
    required this.postId,
    required this.likeCount,
    required this.isLiked,
  });

  @override
  ConsumerState<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends ConsumerState<LikeButton> {
  late bool _isLiked;
  late int _likeCount;

  @override
  void initState() {
    super.initState();
    _isLiked = widget.isLiked;
    _likeCount = widget.likeCount;
  }

  @override
  void didUpdateWidget(LikeButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLiked != widget.isLiked) {
      setState(() {
        _isLiked = widget.isLiked;
      });
    }
    if (oldWidget.likeCount != widget.likeCount) {
      setState(() {
        _likeCount = widget.likeCount;
      });
    }
  }

  void _toggleLike() async {
    final currentUser = ref.read(currentUserAccountProvider).value;
    if (currentUser == null) return;

    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });

    try {
      final like = Like(
        id: '', // Will be set by Appwrite
        postId: widget.postId,
        uid: currentUser.$id,
        createdAt: DateTime.now(),
      );

      final result = await ref.read(interactionAPIProvider).toggleLike(like);
      
      result.fold(
        (failure) {
          // Revert the UI state if the API call fails
          setState(() {
            _isLiked = !_isLiked;
            _likeCount += _isLiked ? 1 : -1;
          });
          debugPrint('Error toggling like: ${failure.massage}');
        },
        (_) {
          // Successfully toggled like
          ref.invalidate(isPostLikedProvider(widget.postId));
        },
      );
    } catch (e) {
      // Revert the UI state if the API call fails
      setState(() {
        _isLiked = !_isLiked;
        _likeCount += _isLiked ? 1 : -1;
      });
      debugPrint('Error toggling like: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: _toggleLike,
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? Colors.red : Colors.grey,
            size: 25,
          ),
        ),
        Text(
          '$_likeCount',
          style: TextStyle(
            color: Theme.of(context).brightness == Brightness.dark
                ? Pallete.whiteColor
                : Pallete.backgroundColor,
          ),
        ),
      ],
    );
  }
}

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLiked = ref.watch(isPostLikedProvider(post.id)).valueOrNull ?? false;
    final userAsync = ref.watch(getUserDetailsByIdProvider(post.uid));

    return userAsync.when(
      data: (userResult) {
        return userResult.fold(
          (failure) => ErrorText(error: failure.massage),
          (document) {
            final user = UserModel.fromMap(document.data);
            return Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user.profilePic),
                    ),
                    title: Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 5),
                          child: Text(
                            user.name,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).brightness == Brightness.dark 
                                  ? Pallete.whiteColor 
                                  : Pallete.backgroundColor,
                            ),
                          ),
                        ),
                        Text(
                          '@${user.name} . ${timeago.format(
                            post.createdAt,
                            locale: 'en_short',
                          )}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Pallete.greyColor,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (post.text != null && post.text!.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: HashtagText(text: post.text!),
                    ),
                  AspectRatio(
                    aspectRatio: 1,
                    child: Stack(
                      children: [
                        Image.network(
                          post.rearCameraPhotoUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
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
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CommentsScreen(post: post),
                              ),
                            );
                          },
                          icon: const Icon(
                            Icons.comment_outlined,
                            size: 20,
                          ),
                        ),
                        Text(
                          '${post.commentsCount}',
                          style: TextStyle(
                            color: Theme.of(context).brightness == Brightness.dark
                                ? Pallete.whiteColor
                                : Pallete.backgroundColor,
                          ),
                        ),
                        const SizedBox(width: 16),
                        LikeButton(
                          postId: post.id,
                          likeCount: post.likesCount,
                          isLiked: isLiked,
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                ],
              ),
            );
          },
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
