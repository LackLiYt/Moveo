import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/constants/assets_constants.dart';
import 'package:moveo/features/post/widgets/hashtag_text.dart';
import 'package:moveo/models/post_model.dart';
import 'package:moveo/common/common.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/models/user_model.dart';
import 'package:moveo/theme/theme.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:moveo/features/post/widgets/comment_post.dart';

class LikeButton extends StatefulWidget {
  final int likeCount;

  const LikeButton({super.key, required this.likeCount});

  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              isLiked = !isLiked;
            });
          },
          icon: Icon(
            isLiked ? Icons.favorite : Icons.favorite_border,
            color: isLiked ? Colors.red : Colors.grey,
            size: 25,
          ),
        ),
        Text(
          '${widget.likeCount + (isLiked ? 1 : 0)}',
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
    return ref.watch(getUserDetailsByIdProvider(post.uid)).when(
      data: (result) {
        return result.fold(
          (failure) => ErrorText(error: failure.massage),
          (document) {
            final user = UserModel.fromMap(document.data);
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      margin: const EdgeInsets.all(10),
                      child: CircleAvatar(
                        backgroundImage: user.profilePic.isNotEmpty 
                          ? NetworkImage(user.profilePic)
                          : null,
                        radius: 20,
                        child: user.profilePic.isEmpty 
                          ? const Icon(Icons.person)
                          : null,
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                margin: const EdgeInsets.only(right: 5),
                                child: 
                                Text(
                                  user.name,
                                   style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
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
                      
                        ],
                      ),
                    ),
                  ],
                ),
                if (post.text != null && post.text!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: HashtagText(text: post.text!),
                  ),
                
                // Display the BeReal-style photos
                AspectRatio(
                  aspectRatio: 1,
                  child: Stack(
                    children: [
                      // Main background photo (rear camera)
                      Image.network(
                        post.rearCameraPhotoUrl,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                        errorBuilder: (context, error, stackTrace) => 
                          Container(
                            color: Colors.grey.shade300,
                            child: const Center(
                              child: Icon(Icons.image_not_supported, size: 50),
                            ),
                          ),
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Container(
                            color: Colors.grey.shade200,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          );
                        },
                      ),
                      
                      // Front camera photo overlay
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
                              errorBuilder: (context, error, stackTrace) => 
                                Container(
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: Icon(Icons.image_not_supported, size: 30),
                                  ),
                                ),
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return Container(
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Action buttons
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
                        '${post.commentIds.length}',
                        style: TextStyle(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Pallete.whiteColor
                              : Pallete.backgroundColor,
                        ),
                      ),
                      const SizedBox(width: 16),
                      LikeButton(likeCount: post.likes.length),
                    ],
                  ),
                ),


                const Divider(),
              ],
            );
          },
        );
      },
      error: (error, stackTrace) => ErrorText(error: error.toString()),
      loading: () => const Loader(),
    );
  }
}
