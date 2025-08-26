import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/models/user_model.dart';
import 'package:moveo/features/progress/models/daily_challenge.dart';
import 'package:moveo/features/progress/models/level_benefits.dart';
import 'package:moveo/features/progress/services/progress_service.dart';
import 'package:moveo/apis/progress_api.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';

final progressControllerProvider = StateNotifierProvider<ProgressController, AsyncValue<UserModel?>>((ref) {
  return ProgressController(
    progressAPI: ref.watch(progressAPIProvider),
    ref: ref,
  );
});

class ProgressController extends StateNotifier<AsyncValue<UserModel?>> {
  final ProgressService _progressService = ProgressService();
  final IProgressAPI _progressAPI;
  final Ref _ref;

  ProgressController({
    required IProgressAPI progressAPI,
    required Ref ref,
  })  : _progressAPI = progressAPI,
        _ref = ref,
        super(const AsyncValue.loading());

  Future<void> _syncProgressWithAppwrite(UserModel user) async {
    try {
      await _progressAPI.updateUserProgress(user);
      state = AsyncValue.data(user);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  // Update progress for different activities
  Future<void> updateProgressForPost() async {
    final currentUser = await _ref.read(currentUserDetailsProvider.future);
    if (currentUser == null) return;

    final updatedUser = _progressService.updateProgressForPost(currentUser);
    await _syncProgressWithAppwrite(updatedUser);
  }

  Future<void> updateProgressForLike() async {
    final currentUser = await _ref.read(currentUserDetailsProvider.future);
    if (currentUser == null) return;

    final updatedUser = _progressService.updateProgressForLike(currentUser);
    await _syncProgressWithAppwrite(updatedUser);
  }

  Future<void> updateProgressForDailyLogin() async {
    final currentUser = await _ref.read(currentUserDetailsProvider.future);
    if (currentUser == null) return;

    final updatedUser = _progressService.updateProgressForDailyLogin(currentUser);
    await _syncProgressWithAppwrite(updatedUser);
  }

  Future<void> updateProgressForSteps(int steps, {int? previousSteps}) async {
    final currentUser = await _ref.read(currentUserDetailsProvider.future);
    if (currentUser == null) return;

    final updatedUser = _progressService.updateProgressForSteps(currentUser, steps, previousSteps: previousSteps);
    await _syncProgressWithAppwrite(updatedUser);
  }

  Future<void> updateProgressForComment() async {
    final currentUser = await _ref.read(currentUserDetailsProvider.future);
    if (currentUser == null) return;

    final updatedUser = _progressService.updateProgressForComment(currentUser);
    await _syncProgressWithAppwrite(updatedUser);
  }

  Future<void> updateProgressForFollower() async {
    final currentUser = await _ref.read(currentUserDetailsProvider.future);
    if (currentUser == null) return;

    final updatedUser = _progressService.updateProgressForFollower(currentUser);
    await _syncProgressWithAppwrite(updatedUser);
  }

  Future<void> loadUserProgress() async {
    try {
      final currentUser = await _ref.read(currentUserDetailsProvider.future);
      if (currentUser == null) {
        state = const AsyncValue.data(null);
        return;
      }
      state = AsyncValue.data(currentUser);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
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
} 