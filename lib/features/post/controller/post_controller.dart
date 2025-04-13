import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/apis/post_api.dart';
import 'package:moveo/core/utils.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/models/post_model.dart';

class PostController extends StateNotifier<bool> {
  final PostAPI _postAPI;
  final Ref _ref;
  PostController({
    required Ref ref,
     required PostAPI postAPI
     }):
      _ref = ref,
      _postAPI = postAPI,
      super(false);

  void sharePost ({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) {

    if(images.isNotEmpty) {
      _shareImagePost(
        images : images,
        text: text,
        context: context,
      );
    }
    
    if(images.isEmpty) {
      showSnackBar(context, 'Please Attach Photos');
      return;
    }
  }

  void _shareImagePost({
    required List<File> images,
    required String text,
    required BuildContext context,
  }) async {
    state = true;
    final hashtags = _getHastagsFromText(text);
    String link = _getLinkFromText(text);
    final user = _ref.read(currentUserDetailsProvider).value!;
    Post post = Post(
      text: text,
       hashtags: hashtags,
        link: link,
         imageLinks: const [],
          uid: user.uid,
           createdAt: DateTime.now(),
            likes: const [],
             commentIds: const [],
              id: '',
              );
    final res = await _postAPI.sharePost(post);
    res.fold(
      (l) => showSnackBar(context, l.massage),
      (r) => null);
  }


  String _getLinkFromText(String text) {
    String link = '';
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> _getHastagsFromText(String text) {
    List<String> hastags = [];
    List<String> wordsInSentence = text.split(' ');
    for (String word in wordsInSentence) {
    if (word.startsWith('#')) {
      hastags.add(word);
      }
    }
    return hastags;
  }
}