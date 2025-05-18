import 'package:flutter/material.dart';
import 'package:moveo/theme/pallete.dart';

class LeaderboardCard extends StatelessWidget {
  final int rank;
  final String name;
  final int level;
  final int steps;
  final int km;
  final int points;
  final bool highlight;
  final Color? highlightColor;

  const LeaderboardCard({
    super.key,
    required this.rank,
    required this.name,
    required this.level,
    required this.steps,
    required this.km,
    required this.points,
    this.highlight = false,
    this.highlightColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color? getRankColor(int rank) {
      if (rank == 1) return Colors.amber[700];
      if (rank == 2) return Colors.grey[500];
      if (rank == 3) return Colors.brown[400];
      return theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor;
    }
    bool isTop3 = rank <= 3;
    return Card(
      color: highlight
          ? (highlightColor ?? Pallete.blueColor.withOpacity(0.2))
          : theme.brightness == Brightness.dark ? Pallete.backgroundColor : Pallete.whiteColor,
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
                  color: isTop3 ? getRankColor(rank) : (theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor),
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              flex: 1,
              child: Text(
                name,
                style: TextStyle(
                  fontWeight: FontWeight.normal,
                  fontSize: 16,
                  color: theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 60, child: _LeaderboardStat(value: level.toString(), theme: theme)),
            SizedBox(width: 60, child: _LeaderboardStat(value: steps.toString(), theme: theme)),
            SizedBox(width: 60, child: _LeaderboardStat(value: km.toString(), theme: theme)),
            SizedBox(width: 60, child: _LeaderboardStat(value: points.toString(), theme: theme)),
          ],
        ),
      ),
    );
  }
}

class _LeaderboardStat extends StatelessWidget {
  final String value;
  final ThemeData theme;

  const _LeaderboardStat({
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
              color: theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
