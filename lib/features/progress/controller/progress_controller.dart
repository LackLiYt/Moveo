import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/models/user_model.dart';
import 'package:moveo/features/progress/models/daily_challenge.dart';
import 'package:moveo/features/progress/models/level_benefits.dart';
import 'package:moveo/features/progress/services/progress_service.dart';
import 'package:moveo/apis/progress_api.dart';
import 'package:moveo/core/utils.dart';

final progressControllerProvider = StateNotifierProvider<ProgressController, AsyncValue<UserModel?>>((ref) {
  return ProgressController(
    progressAPI: ref.watch(progressAPIProvider),
  );
});

class ProgressController extends StateNotifier<AsyncValue<UserModel?>> {
  final ProgressService _progressService = ProgressService();
  final IProgressAPI _progressAPI;

  ProgressController({required IProgressAPI progressAPI}) 
      : _progressAPI = progressAPI,
        super(const AsyncValue.data(null));

  // Update progress for different activities
  Future<void> updateProgressForPost(UserModel user) async {
    final updatedUser = _progressService.updateProgressForPost(user);
    await _syncProgressWithAppwrite(updatedUser);
  }

  Future<void> updateProgressForLike(UserModel user) async {
    final updatedUser = _progressService.updateProgressForLike(user);
    await _syncProgressWithAppwrite(updatedUser);
  }

  Future<void> updateProgressForDailyLogin(UserModel user) async {
    final updatedUser = _progressService.updateProgressForDailyLogin(user);
    await _syncProgressWithAppwrite(updatedUser);
  }

  Future<void> updateProgressForSteps(UserModel user, int steps) async {
    final updatedUser = _progressService.updateProgressForSteps(user, steps);
    await _syncProgressWithAppwrite(updatedUser);
  }

  Future<void> updateProgressForNewFollower(UserModel user) async {
    final updatedUser = _progressService.updateProgressForNewFollower(user);
    await _syncProgressWithAppwrite(updatedUser);
  }

  Future<void> updateProgressForComment(UserModel user) async {
    final updatedUser = _progressService.updateProgressForComment(user);
    await _syncProgressWithAppwrite(updatedUser);
  }

  // Get level benefits
  List<LevelBenefit> getLevelBenefits(int level) {
    return LevelBenefits.getUnlocksForLevel(level);
  }

  List<LevelBenefit> getNextUnlocks(int currentLevel) {
    return LevelBenefits.getNextUnlocks(currentLevel);
  }

  // Handle daily challenges
  List<DailyChallenge> getDailyChallenges() {
    return DailyChallengeGenerator.generateDailyChallenges();
  }

  Future<void> checkAndUpdateDailyChallenges(UserModel user, int steps) async {
    final challenges = getDailyChallenges();
    UserModel updatedUser = user;

    for (var challenge in challenges) {
      if (!challenge.isCompleted && challenge.checkCompletion(steps)) {
        updatedUser = challenge.applyRewards(updatedUser);
      }
    }

    await _syncProgressWithAppwrite(updatedUser);
  }

  // Helper method to sync progress with Appwrite
  Future<void> _syncProgressWithAppwrite(UserModel user) async {
    try {
      // Update user progress in users collection
      final userResult = await _progressAPI.updateUserProgress(user);
      userResult.fold(
        (l) => throw Exception(l.massage),
        (r) => null,
      );

      // Update leaderboard
      final leaderboardResult = await _progressAPI.updateLeaderboard(user);
      leaderboardResult.fold(
        (l) => throw Exception(l.massage),
        (r) => null,
      );

      state = AsyncValue.data(user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
} 