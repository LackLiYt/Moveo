import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LeaderboardView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LeaderboardView(),
      );

  const LeaderboardView({super.key});

  @override
  ConsumerState<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends ConsumerState<LeaderboardView> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
} 