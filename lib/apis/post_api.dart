import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:moveo/constants/appwrite_constants.dart';
import 'package:moveo/core/core.dart';
import 'package:moveo/core/providers.dart';
import 'package:moveo/models/post_model.dart';

final postAPIProvider = Provider((ref) {
  return PostAPI(db: ref.watch(appwriteDatabaseProvider));
});

abstract class IPostAPI {
  FutureEither<Document> sharePost(Post post);
}

class PostAPI implements IPostAPI {
  final Databases _db;
  PostAPI({required Databases db}) : _db = db;
  @override
  FutureEither<Document> sharePost(Post post) async {
    try {
        final document = await _db.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.postCollectionId,
        documentId: ID.unique(),
        data: post.toMap(),
      );
      return right(document);
    } on AppwriteException catch (e,st) {
      return left(Failure(e.message??'Some unexpected bullshit occured', st)
      );
    } catch (e, st) {
      return left(Failure(e.toString(), st)
      );
    }  
  }

}