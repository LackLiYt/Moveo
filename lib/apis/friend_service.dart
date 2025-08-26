import 'package:appwrite/appwrite.dart';
import '../models/friend.dart';
import '../constants/appwrite_constants.dart';

class FriendService {
  final Databases _databases;
  final String _databaseId = AppwriteConstants.databaseId;
  final String _collectionId = AppwriteConstants.friendsCollectionId;

  FriendService(Client client) : _databases = Databases(client);

  // Send friend request
  Future<Friend> sendFriendRequest(String uid, String friendId) async {
    try {
      // Check if friend request already exists
      final existingRequests = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _collectionId,
        queries: [
          Query.equal('uid', uid),
          Query.equal('friendId', friendId),
        ],
      );

      if (existingRequests.documents.isNotEmpty) {
        throw Exception('Friend request already exists');
      }

      final response = await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: ID.unique(),
        data: {
          'uid': uid,
          'friendId': friendId,
          'status': 'pending',
          'createdAt': DateTime.now().toIso8601String(),
        },
        permissions: [
          Permission.read(Role.user(uid)),
          Permission.read(Role.user(friendId)),
          Permission.write(Role.user(uid)),
          Permission.write(Role.user(friendId)),
        ],
      );

      return Friend.fromMap(response.data);
    } catch (e) {
      throw Exception('Failed to send friend request: $e');
    }
  }

  // Accept friend request
  Future<Friend> acceptFriendRequest(String requestId) async {
    try {
      final response = await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: requestId,
        data: {
          'status': 'accepted',
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );

      return Friend.fromMap(response.data);
    } catch (e) {
      throw Exception('Failed to accept friend request: $e');
    }
  }

  // Reject friend request
  Future<Friend> rejectFriendRequest(String requestId) async {
    try {
      final response = await _databases.updateDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: requestId,
        data: {
          'status': 'rejected',
          'updatedAt': DateTime.now().toIso8601String(),
        },
      );

      return Friend.fromMap(response.data);
    } catch (e) {
      throw Exception('Failed to reject friend request: $e');
    }
  }

  // Get all friends for a user
  Future<List<Friend>> getFriends(String uid) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _collectionId,
        queries: [
          Query.equal('uid', uid),
          Query.equal('status', 'accepted'),
        ],
      );

      return response.documents.map((doc) => Friend.fromMap(doc.data)).toList();
    } catch (e) {
      throw Exception('Failed to get friends: $e');
    }
  }

  // Get pending friend requests
  Future<List<Friend>> getPendingRequests(String uid) async {
    try {
      final response = await _databases.listDocuments(
        databaseId: _databaseId,
        collectionId: _collectionId,
        queries: [
          Query.equal('friendId', uid),
          Query.equal('status', 'pending'),
        ],
      );

      return response.documents.map((doc) => Friend.fromMap(doc.data)).toList();
    } catch (e) {
      throw Exception('Failed to get pending requests: $e');
    }
  }

  // Remove friend
  Future<void> removeFriend(String requestId) async {
    try {
      await _databases.deleteDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: requestId,
      );
    } catch (e) {
      throw Exception('Failed to remove friend: $e');
    }
  }
} 