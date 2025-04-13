import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/features/post/widgets/hashtag_text.dart';
import 'package:moveo/models/post_model.dart';
import 'package:moveo/common/common.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/models/user_model.dart';
import 'package:moveo/theme/theme.dart';
import 'package:timeago/timeago.dart' as timeago;

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
                        backgroundImage: NetworkImage(user.profilePic),
                        radius: 20,
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
                                   style: const TextStyle(
                                    fontSize: 18,
                                     fontWeight: FontWeight.bold),
                                  ),
                              ),
                              Text(
                                '@${user.name} . ${timeago.format(
                                  post.createdAt,
                                  locale: 'en_short',
                                  )}',
                                style: const TextStyle(
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
                HashtagText(text: post.text),
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