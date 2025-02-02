import 'dart:io';
import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/constants/appwrite_constants.dart';
import 'package:moveo/core/providers.dart';

final StorageAPIProvider = Provider((ref) {
  return StorageAPI(storage: ref.watch(appwriteStorageProvider));
});

class StorageAPI {
  final Storage _storage;
  StorageAPI({required Storage storage}) : _storage = storage;

  Future<String> uploadImage(File file) async {
    try {
      final uploadedImage = await _storage.createFile(
        bucketId: AppwriteConstants.imagesBucketId,
        fileId: ID.unique(),
        file: InputFile.fromPath(path: file.path),
      );
      return AppwriteConstants.imageUrl(uploadedImage.$id);
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}
