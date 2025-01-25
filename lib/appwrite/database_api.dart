import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:moveo/appwrite/auth_api.dart';
import 'package:moveo/constants/constants.dart';

class DatabaseAPI {
  Client client = Client();
  late final Account account;
  late final Databases databases;
  final AuthAPI auth = AuthAPI();

  DatabaseAPI() {
    init();
  }

  init() {
    client
        .setEndpoint(AppwriteConstants.endPoint)
        .setProject(AppwriteConstants.projectId)
        .setSelfSigned();
    account = Account(client);
    databases = Databases(client);
  }

  Future<DocumentList> getMessages() {
    return databases.listDocuments(
      databaseId: AppwriteConstants.databaseId,
      collectionId: AppwriteConstants.usersCollectionId,
    );
  }

  Future<Document> addMessage({required String message}) {
    return databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: ID.unique(),
        data: {
          'text': message,
          'date': DateTime.now().toString(),
          'user_id': auth.userid
        });
  }

  Future<dynamic> deleteMessage({required String id}) {
    return databases.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: id);
  }
}
