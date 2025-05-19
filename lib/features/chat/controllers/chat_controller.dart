import 'package:appwrite/appwrite.dart';
import 'package:moveo/constants/appwrite_constants.dart';
import 'package:moveo/models/chat_model.dart';

class ChatController {
  final Client client = Client()
    .setEndpoint(AppwriteConstants.endPoint)
    .setProject(AppwriteConstants.projectId)
    .setSelfSigned(status: true);

  late final Account account;
  late final Databases databases;
  late final Storage storage;
  late final Realtime realtime;
  RealtimeSubscription? subscription;

  ChatController() {
    account = Account(client);
    databases = Databases(client);
    storage = Storage(client);
    realtime = Realtime(client);
  }

  // Subscribe to realtime changes
  void subscribeToRealtime({required String userId}) {
    subscription = realtime.subscribe([
      "databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.usersCollectionId}.documents",
    ]);

    subscription!.stream.listen((data) {
      final firstItem = data.events[0].split(".");
      final eventType = firstItem[firstItem.length - 1];
      
      // Handle realtime updates here
      // You'll need to implement your own state management solution
    });
  }

  // Create a new chat message
  Future<bool> createNewChat({
    required String message,
    required String senderId,
    required String receiverId,
    required bool isImage,
    required bool isGroupInvite,
  }) async {
    try {
      await databases.createDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.commentsCollectionId,
        documentId: ID.unique(),
        data: {
          "uid": senderId,
          "text": message,
          "createdAt": DateTime.now().toIso8601String(),
        },
      );
      return true;
    } catch (e) {
      print("Failed to send message: $e");
      return false;
    }
  }

  // Get user chats
  Future<Map<String, List<ChatData>>?> getUserChats(String userId) async {
    try {
      var results = await databases.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        queries: [
          Query.or([
            Query.equal("senderId", userId),
            Query.equal("receiverId", userId),
          ]),
          Query.orderDesc("timestamp"),
          Query.limit(2000),
        ],
      );

      Map<String, List<ChatData>> chats = {};

      if (results.documents.isNotEmpty) {
        for (var doc in results.documents) {
          String sender = doc.data["senderId"];
          String receiver = doc.data["receiverId"];

          ChatMessage message = ChatMessage.fromMap(doc.data);
          List<String> users = List<String>.from(doc.data["userData"] ?? []);

          String key = (sender == userId) ? receiver : sender;

          if (chats[key] == null) {
            chats[key] = [];
          }
          chats[key]!.add(ChatData(message: message, users: users));
        }
      }

      return chats;
    } catch (e) {
      print("Error in reading user chats: $e");
      return null;
    }
  }

  // Update message seen status
  Future<void> updateMessageSeen(List<String> chatIds) async {
    try {
      for (var chatId in chatIds) {
        await databases.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollectionId,
          documentId: chatId,
          data: {"isSeenbyReceiver": true},
        );
      }
    } catch (e) {
      print("Error updating message seen status: $e");
    }
  }

  // Delete chat message
  Future<void> deleteChatMessage(String chatId) async {
    try {
      await databases.deleteDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: chatId,
      );
    } catch (e) {
      print("Error deleting chat message: $e");
    }
  }

  // Edit chat message
  Future<void> editChatMessage({
    required String chatId,
    required String newMessage,
  }) async {
    try {
      await databases.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: chatId,
        data: {"message": newMessage},
      );
    } catch (e) {
      print("Error editing chat message: $e");
    }
  }

  // Upload image to storage
  Future<String?> uploadImage(InputFile file) async {
    try {
      final response = await storage.createFile(
        bucketId: AppwriteConstants.imagesBucketId,
        fileId: ID.unique(),
        file: file,
      );
      return response.$id;
    } catch (e) {
      print("Error uploading image: $e");
      return null;
    }
  }

  // Get image URL
  String getImageUrl(String imageId) {
    return AppwriteConstants.imageUrl(imageId);
  }
}