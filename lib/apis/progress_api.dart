import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:moveo/constants/appwrite_constants.dart';
import 'package:moveo/core/core.dart';
import 'package:moveo/core/providers.dart';
import 'package:moveo/models/user_model.dart';

final progressAPIProvider = Provider((ref) {
  return ProgressAPI(
    db: ref.watch(appwriteDatabaseProvider),
  );
});

abstract class IProgressAPI {
  FutureEitherVoid updateUserProgress(UserModel user);
  FutureEitherVoid updateLeaderboard(UserModel user);
  FutureEither<Map<String, dynamic>> getLeaderboard();
  FutureEitherVoid updateLeaderboardSteps(String uid, int newSteps);
}

class ProgressAPI implements IProgressAPI {
  final Databases _db;
  ProgressAPI({required Databases db}) : _db = db;

  @override
  FutureEitherVoid updateUserProgress(UserModel user) async {
    try {
      await _db.updateDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollectionId,
        documentId: user.uid,
        data: {
          'points': user.points,
          'level': user.level,
          'experience': user.experience,
          'experienceToNextLevel': user.experienceToNextLevel,
        },
      );
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Error updating user progress', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEitherVoid updateLeaderboard(UserModel user) async {
    try {
      print('[DEBUG] updateLeaderboard called with user: uid=${user.uid}, name=${user.name}, points=${user.points}, level=${user.level}');
      // Check if user exists in leaderboard
      try {
        final existingDoc = await _db.getDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.leaderboardCollectionId,
          documentId: user.uid,
        );
        
        // Get current steps from leaderboard
        final currentSteps = existingDoc.data['steps'] ?? 0;
        
        // Update existing leaderboard entry
        await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.leaderboardCollectionId,
          documentId: user.uid,
          data: {
            'name': user.name,
            'points': user.points,
            'level': user.level,
            'steps': currentSteps, // Keep the existing steps count
          },
        );
        print('[DEBUG] Updated leaderboard entry for uid=${user.uid}');
      } catch (e) {
        // Create new leaderboard entry if user doesn't exist
        await _db.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.leaderboardCollectionId,
          documentId: user.uid,
          data: {
            'uid': user.uid,
            'name': user.name,
            'points': user.points,
            'level': user.level,
            'steps': 0, // Initialize steps to 0
          },
        );
        print('[DEBUG] Created new leaderboard entry for uid=${user.uid}');
      }
      return right(null);
    } on AppwriteException catch (e, st) {
      print('[DEBUG] AppwriteException in updateLeaderboard: ${e.message}');
      return left(Failure(e.message ?? 'Error updating leaderboard', st));
    } catch (e, st) {
      print('[DEBUG] Exception in updateLeaderboard: $e');
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEither<Map<String, dynamic>> getLeaderboard() async {
    try {
      final response = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.leaderboardCollectionId,
        queries: [
          Query.orderDesc('points'),
          Query.limit(100),
        ],
      );
      return right(response.toMap());
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Error fetching leaderboard', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }

  @override
  FutureEitherVoid updateLeaderboardSteps(String uid, int newSteps) async {
    try {
      try {
        final existingDoc = await _db.getDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.leaderboardCollectionId,
          documentId: uid,
        );
        
        // Get current steps and km from leaderboard
        final currentSteps = existingDoc.data['steps'] ?? 0;
        final currentKm = (existingDoc.data['km'] as num?)?.toDouble() ?? 0.0; // Assuming km is stored as a number
        
        // Only update if new steps are greater
        if (newSteps > currentSteps) {
          // Calculate new kilometers (assuming 1 km = 1000 steps)
          final newKm = (newSteps / 1000).toDouble();

          await _db.updateDocument(
            databaseId: AppwriteConstants.databaseId,
            collectionId: AppwriteConstants.leaderboardCollectionId,
            documentId: uid,
            data: {
              'steps': newSteps,
              'km': newKm, // Add kilometers to the update data
            },
          );
          print('[DEBUG] Updated steps and km in leaderboard for uid=$uid: Steps=$newSteps, Km=$newKm');
        }
      } catch (e) {
        print('[DEBUG] Error updating steps and km in leaderboard: $e');
      }
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(e.message ?? 'Error updating leaderboard steps', st));
    } catch (e, st) {
      return left(Failure(e.toString(), st));
    }
  }
} 