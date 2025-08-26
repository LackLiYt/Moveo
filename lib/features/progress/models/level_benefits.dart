import 'package:flutter/foundation.dart';

@immutable
class LevelBenefit {
  final String title;
  final String description;
  final String iconPath;
  final bool isUnlocked;

  const LevelBenefit({
    required this.title,
    required this.description,
    required this.iconPath,
    required this.isUnlocked,
  });

  LevelBenefit copyWith({
    String? title,
    String? description,
    String? iconPath,
    bool? isUnlocked,
  }) {
    return LevelBenefit(
      title: title ?? this.title,
      description: description ?? this.description,
      iconPath: iconPath ?? this.iconPath,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'iconPath': iconPath,
      'isUnlocked': isUnlocked,
    };
  }

  factory LevelBenefit.fromMap(Map<String, dynamic> map) {
    return LevelBenefit(
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      iconPath: map['iconPath'] ?? '',
      isUnlocked: map['isUnlocked'] ?? false,
    );
  }
}

class LevelBenefits {
  static final Map<int, List<LevelBenefit>> levelUnlocks = {
    2: [
      LevelBenefit(
        title: 'Custom Profile Theme',
        description: 'Unlock custom colors for your profile',
        iconPath: 'assets/icons/theme.png',
        isUnlocked: false,
      ),
    ],
    5: [
      LevelBenefit(
        title: 'Premium Badge',
        description: 'Show your dedication with a premium badge',
        iconPath: 'assets/icons/badge.png',
        isUnlocked: false,
      ),
    ],
    10: [
      LevelBenefit(
        title: 'Custom Animations',
        description: 'Add custom animations to your profile',
        iconPath: 'assets/icons/animations.png',
        isUnlocked: false,
      ),
    ],
    15: [
      LevelBenefit(
        title: 'Special Filters',
        description: 'Access exclusive photo filters',
        iconPath: 'assets/icons/filters.png',
        isUnlocked: false,
      ),
    ],
    20: [
      LevelBenefit(
        title: 'Exclusive Content',
        description: 'Access to exclusive content and features',
        iconPath: 'assets/icons/exclusive.png',
        isUnlocked: false,
      ),
    ],
  };

  static List<LevelBenefit> getUnlocksForLevel(int level) {
    List<LevelBenefit> unlocks = [];
    levelUnlocks.forEach((requiredLevel, benefits) {
      if (level >= requiredLevel) {
        unlocks.addAll(benefits.map((benefit) => 
          benefit.copyWith(isUnlocked: true)
        ));
      } else {
        unlocks.addAll(benefits);
      }
    });
    return unlocks;
  }

  static List<LevelBenefit> getNextUnlocks(int currentLevel) {
    List<LevelBenefit> nextUnlocks = [];
    levelUnlocks.forEach((requiredLevel, benefits) {
      if (requiredLevel > currentLevel && requiredLevel <= currentLevel + 5) {
        nextUnlocks.addAll(benefits);
      }
    });
    return nextUnlocks;
  }
} 