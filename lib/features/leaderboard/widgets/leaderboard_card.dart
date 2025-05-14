import 'package:flutter/material.dart';
import 'package:moveo/theme/pallete.dart';

class LeaderboardCard extends StatelessWidget {
  final int rank;
  final String name;
  final int level;
  final int steps;
  final int hours;
  final int points;
  final bool highlight;
  final Color? highlightColor;

  const LeaderboardCard({
    Key? key,
    required this.rank,
    required this.name,
    required this.level,
    required this.steps,
    required this.hours,
    required this.points,
    this.highlight = false,
    this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: highlight
          ? (highlightColor ?? Pallete.blueColor.withOpacity(0.2))
          : theme.cardTheme.color,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: highlight
            ? BorderSide(color: highlightColor ?? Pallete.blueColor, width: 2)
            : BorderSide.none,
      ),
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        child: Row(
          children: [
            SizedBox(
              width: 32,
              child: Text(
                rank.toString(),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: highlight ? (highlightColor ?? Pallete.blueColor) : theme.textTheme.bodyLarge?.color,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: highlight ? (highlightColor ?? Pallete.blueColor) : theme.textTheme.bodyLarge?.color,
                ),
              ),
            ),
            _LeaderboardStat(label: 'Lvl', value: level.toString(), theme: theme),
            _LeaderboardStat(label: 'Steps', value: steps.toString(), theme: theme),
            _LeaderboardStat(label: 'Hours', value: hours.toString(), theme: theme),
            _LeaderboardStat(label: 'Pts', value: points.toString(), theme: theme),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardStat extends StatelessWidget {
  final String label;
  final String value;
  final ThemeData theme;

  const _LeaderboardStat({
    required this.label,
    required this.value,
    required this.theme,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
        ],
      ),
    );
  }
}
