import 'package:flutter/foundation.dart';
import 'package:moveo/models/user_model.dart';

@immutable
class DailyChallenge {
  final String id;
  final String title;
  final String description;
  final int pointsReward;
  final int experienceReward;
  final int targetSteps;
  final bool isCompleted;
  final DateTime createdAt;

  const DailyChallenge({
    required this.id,
    required this.title,
    required this.description,
    required this.pointsReward,
    required this.experienceReward,
    required this.targetSteps,
    this.isCompleted = false,
    required this.createdAt,
  });

  DailyChallenge copyWith({
    String? id,
    String? title,
    String? description,
    int? pointsReward,
    int? experienceReward,
    int? targetSteps,
    bool? isCompleted,
    DateTime? createdAt,
  }) {
    return DailyChallenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      pointsReward: pointsReward ?? this.pointsReward,
      experienceReward: experienceReward ?? this.experienceReward,
      targetSteps: targetSteps ?? this.targetSteps,
      isCompleted: isCompleted ?? this.isCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'pointsReward': pointsReward,
      'experienceReward': experienceReward,
      'targetSteps': targetSteps,
      'isCompleted': isCompleted,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }

  factory DailyChallenge.fromMap(Map<String, dynamic> map) {
    return DailyChallenge(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      pointsReward: map['pointsReward'] ?? 0,
      experienceReward: map['experienceReward'] ?? 0,
      targetSteps: map['targetSteps'] ?? 0,
      isCompleted: map['isCompleted'] ?? false,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] ?? 0),
    );
  }

  bool checkCompletion(int userSteps) {
    return userSteps >= targetSteps;
  }

  UserModel applyRewards(UserModel user) {
    return user
      .addPoints(pointsReward)
      .addExperience(experienceReward);
  }
}

class DailyChallengeGenerator {
  static List<DailyChallenge> generateDailyChallenges() {
    final now = DateTime.now();
    return [
      DailyChallenge(
        id: '1',
        title: 'Step Master',
        description: 'Complete 10,000 steps today',
        pointsReward: 50,
        experienceReward: 100,
        targetSteps: 10000,
        createdAt: now,
      ),
      DailyChallenge(
        id: '2',
        title: 'Early Bird',
        description: 'Complete 5,000 steps before noon',
        pointsReward: 30,
        experienceReward: 75,
        targetSteps: 5000,
        createdAt: now,
      ),
      DailyChallenge(
        id: '3',
        title: 'Night Owl',
        description: 'Complete 3,000 steps after 6 PM',
        pointsReward: 25,
        experienceReward: 50,
        targetSteps: 3000,
        createdAt: now,
      ),
    ];
  }
} 