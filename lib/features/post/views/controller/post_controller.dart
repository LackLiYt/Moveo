import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/apis/post_api.dart';
import 'package:moveo/apis/storage_api.dart';
import 'package:moveo/core/utils.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/models/post_model.dart';

final PostControllerProvider = StateNotifierProvider<PostController, bool>((ref) {
  return PostController(
    ref: ref,
    postAPI: ref.watch(postAPIProvider),
    storageAPI: ref.watch(StorageAPIProvider),
  );
});

class PostController extends StateNotifier<bool> {
  final PostAPI _postAPI;
  final StorageAPI _storageAPI;
  final Ref _ref;

  PostController({
    required Ref ref,
    required PostAPI postAPI,
    required StorageAPI storageAPI,
  })  : _ref = ref,
        _postAPI = postAPI,
        _storageAPI = storageAPI,
        super(false);

  Future<void> sharePost({
    required File rearCameraPhoto,
    required File frontCameraPhoto,
    String? text,
    required BuildContext context,
  }) async {
    if (rearCameraPhoto.path.isEmpty || frontCameraPhoto.path.isEmpty) {
      showSnackBar(context, 'Please take both photos before posting');
      return;
    }
    
    if (!rearCameraPhoto.existsSync() || !frontCameraPhoto.existsSync()) {
      showSnackBar(context, 'One or both photos are missing or invalid');
      return;
    }

    state = true;

    try {
      final user = _ref.read(currentUserDetailsProvider).value;
      if (user == null) {
        showSnackBar(context, 'User information not available. Please log in again.');
        state = false;
        return;
      }

      final rearCameraPhotoUrl = await _storageAPI.uploadImage(rearCameraPhoto);
      if (rearCameraPhotoUrl == null || rearCameraPhotoUrl.isEmpty) {
        throw Exception('Failed to upload rear camera photo');
      }
      
      final frontCameraPhotoUrl = await _storageAPI.uploadImage(frontCameraPhoto);
      if (frontCameraPhotoUrl == null || frontCameraPhotoUrl.isEmpty) {
        throw Exception('Failed to upload front camera photo');
      }

      final List<String> hashtags = text != null ? _extractHashtags(text) : [];
      final String? link = text != null ? _extractLink(text) : null;

      
      Post post = Post(
        rearCameraPhotoUrl: rearCameraPhotoUrl,
        frontCameraPhotoUrl: frontCameraPhotoUrl,
        text: text ?? '', 
        hashtags: hashtags,
        link: link,
        uid: user.uid,
        createdAt: DateTime.now(),
        likes: const [],
        commentIds: const [],
        id: '', 
      );

      final res = await _postAPI.sharePost(post);
      res.fold(
        (l) => showSnackBar(context, l.massage), 
        (r) => showSnackBar(context, 'Post shared successfully!') 
      );
    } catch (e) {
      showSnackBar(context, 'Error sharing post: $e');
    } finally {
      state = false;
    }
  }

  String? _extractLink(String text) {
    for (String word in text.split(' ')) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        return word;
      }
    }
    return null;
  }

  List<String> _extractHashtags(String text) {
    return text.split(' ').where((word) => word.startsWith('#')).toList();
  }
}