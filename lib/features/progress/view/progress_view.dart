import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/models/user_model.dart';
import 'package:moveo/features/progress/controller/progress_controller.dart';
import 'package:moveo/features/progress/models/level_benefits.dart';

class ProgressView extends ConsumerWidget {
  const ProgressView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressState = ref.watch(progressControllerProvider);

    return progressState.when(
      data: (user) {
        if (user == null) return const Center(child: Text('No user data'));

        return Scaffold(
          appBar: AppBar(
            title: const Text('Progress'),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildLevelProgress(user),
                  const SizedBox(height: 24),
                  _buildDailyChallenges(ref),
                  const SizedBox(height: 24),
                  _buildLevelBenefits(user.level),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
    );
  }

  Widget _buildLevelProgress(UserModel user) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Level ${user.level}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: user.experience / user.experienceToNextLevel,
              backgroundColor: Colors.grey[200],
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
            ),
            const SizedBox(height: 8),
            Text(
              '${user.experience}/${user.experienceToNextLevel} XP',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Points: ${user.points}',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyChallenges(WidgetRef ref) {
    final challenges = ref.read(progressControllerProvider.notifier).getDailyChallenges();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Challenges',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...challenges.map((challenge) => Card(
          child: ListTile(
            title: Text(challenge.title),
            subtitle: Text(challenge.description),
            trailing: Text(
              '${challenge.pointsReward} pts',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildLevelBenefits(int currentLevel) {
    final benefits = LevelBenefits.getUnlocksForLevel(currentLevel);
    final nextBenefits = LevelBenefits.getNextUnlocks(currentLevel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Level Benefits',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...benefits.map((benefit) => Card(
          child: ListTile(
            leading: Image.asset(
              benefit.iconPath,
              width: 40,
              height: 40,
            ),
            title: Text(benefit.title),
            subtitle: Text(benefit.description),
            trailing: Icon(
              benefit.isUnlocked ? Icons.check_circle : Icons.lock,
              color: benefit.isUnlocked ? Colors.green : Colors.grey,
            ),
          ),
        )),
        if (nextBenefits.isNotEmpty) ...[
          const SizedBox(height: 24),
          const Text(
            'Next Unlocks',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...nextBenefits.map((benefit) => Card(
            child: ListTile(
              leading: Image.asset(
                benefit.iconPath,
                width: 40,
                height: 40,
                color: Colors.grey,
              ),
              title: Text(benefit.title),
              subtitle: Text(benefit.description),
              trailing: const Icon(
                Icons.lock,
                color: Colors.grey,
              ),
            ),
          )),
        ],
      ],
    );
  }
} 