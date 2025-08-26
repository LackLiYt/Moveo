import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/features/leaderboard/widgets/weekly_stats.dart'; // Assuming this is the correct path
import 'package:moveo/features/post/widgets/home_post_list.dart'; // Assuming this is the correct path

class HomeContentView extends ConsumerWidget {
  // You will need to pass the stats data to WeeklyUpgradePanel
  final int weeklyExperience;
  final int weeklySteps;
  final String weeklyTime;
  final int weeklyLevelsGained;
  final int overallLevel;

  const HomeContentView({
    super.key,
    required this.weeklyExperience,
    required this.weeklySteps,
    required this.weeklyTime,
    required this.weeklyLevelsGained,
    required this.overallLevel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        WeeklyUpgradePanel(
          experience: weeklyExperience,
          steps: weeklySteps,
          time: weeklyTime,
          levels: weeklyLevelsGained, // Pass weekly levels gained
          level: overallLevel, // Pass overall level
        ),
        Expanded(
          child: PostList(),
        ),
      ],
    );
  }
} 