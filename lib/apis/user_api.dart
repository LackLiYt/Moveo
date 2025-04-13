import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:moveo/constants/constants.dart';
import 'package:moveo/core/core.dart';
import 'package:moveo/core/providers.dart';
import 'package:moveo/models/user_model.dart';

final userAPIProvider = Provider((ref) {
  return UserAPI(
    db: ref.watch(appwriteDatabaseProvider),
  );
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel userModel);
  FutureEither<model.Document> getUserData(String uid);
}

class UserAPI implements IUserAPI {
  final Databases _db;
  UserAPI({required Databases db}) : _db = db;

  @override
  FutureEitherVoid saveUserData(UserModel userModel) async {
    try {
      print('Creating user document with ID: ${userModel.uid}');
      await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: userModel.uid,
        data: userModel.toMap(),
        permissions: [
          Permission.write(Role.any()),
        ],
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      print('Error creating user document: ${e.message}');
      return left(Failure(e.message ?? 'Unexpected error occurred', st));
    } catch (e, st) {
      print('Unexpected error creating user document: $e');
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<model.Document> getUserData(String uid) async {
    try {
      print('Fetching user document with ID: $uid');
      final document = await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: uid,
      );
      print('Successfully fetched document: ${document.data}');
      return right(document);
    } on AppwriteException catch (e, st) {
      print('AppwriteException in getUserData: ${e.message}');
      print('Attempted to fetch with ID: $uid');
      return left(Failure(e.message ?? 'Error fetching user data', st));
    } catch (e, st) {
      print('Unexpected error in getUserData: $e');
      return left(Failure(e.toString(), st));
    }
  }
}