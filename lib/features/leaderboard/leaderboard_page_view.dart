import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/apis/progress_api.dart';
import 'package:moveo/features/leaderboard/widgets/leaderboard_card.dart';
import 'package:moveo/models/user_model.dart';
import 'package:moveo/theme/pallete.dart';

class LeaderboardPageView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LeaderboardPageView(),
      );

  const LeaderboardPageView({Key? key}) : super(key: key);

  @override
  ConsumerState<LeaderboardPageView> createState() => _LeaderboardPageViewState();
}

class _LeaderboardPageViewState extends ConsumerState<LeaderboardPageView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentTab = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        currentTab = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        title: Text('LeaderBoard', style: theme.textTheme.titleMedium),
        centerTitle: false,
      ),
      body: Container(
        decoration: BoxDecoration(
          color: theme.cardTheme.color,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('Leaderboard:', style: theme.textTheme.titleLarge),
              ),
            ),
            const SizedBox(height: 8),
            TabBar(
              controller: _tabController,
              labelColor: Pallete.blueColor,
              unselectedLabelColor: theme.textTheme.bodySmall?.color,
              indicatorColor: Pallete.blueColor,
              tabs: const [
                Tab(text: 'World'),
                Tab(text: 'Country'),
                Tab(text: 'Friends'),
                Tab(text: 'Achiv'),
              ],
            ),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildWorldTab(),
                  _buildCountryTab(),
                  _buildFriendsTab(),
                  _buildAchivTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWorldTab() {
    final progressAPI = ref.watch(progressAPIProvider);
    // Replace with actual current user info
    final String currentUserId = 'arsenantoshko'; // TODO: get from auth
    return FutureBuilder(
      future: progressAPI.getLeaderboard(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (!snapshot.hasData || snapshot.data!.isLeft()) {
          return const Center(child: Text('Failed to load leaderboard'));
        }
        final data = snapshot.data!.getOrElse((_) => {});
        final docs = (data['documents'] as List<dynamic>? ?? []);
        // Map to leaderboard entries
        final leaderboard = docs.asMap().entries.map((entry) {
          final i = entry.key;
          final doc = entry.value;
          return {
            'rank': i + 1,
            'uid': doc['uid'] ?? '',
            'name': doc['name'] ?? '',
            'level': doc['level'] ?? 1,
            'steps': doc['steps'] ?? 0,
            'hours': 29, // Placeholder
            'points': doc['points'] ?? 0,
          };
        }).toList();
        // Find current user
        final currentUserIndex = leaderboard.indexWhere((e) => e['uid'] == currentUserId);
        List<Map<String, dynamic>> displayList = [];
        if (leaderboard.length <= 5) {
          displayList = leaderboard;
        } else {
          displayList = leaderboard.take(5).toList();
          if (currentUserIndex >= 5 || currentUserIndex == -1) {
            // Replace 5th with current user
            if (currentUserIndex != -1) {
              displayList[4] = leaderboard[currentUserIndex];
            } else {
              // If not found, just show top 5
            }
          }
        }
        return ListView(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          children: [
            _buildHeaderRow(),
            ...displayList.map((e) => LeaderboardCard(
              rank: e['rank'],
              name: e['name'],
              level: e['level'],
              steps: e['steps'],
              hours: e['hours'],
              points: e['points'],
              highlight: e['uid'] == currentUserId || e['rank'] <= 3,
              highlightColor: e['uid'] == currentUserId
                  ? Colors.lightBlueAccent.withOpacity(0.3)
                  : (e['rank'] == 1
                      ? Colors.yellow.withOpacity(0.4)
                      : (e['rank'] == 2
                          ? Colors.orange.withOpacity(0.2)
                          : (e['rank'] == 3
                              ? Colors.amber.withOpacity(0.2)
                              : null))),
            )),
            if (currentUserIndex >= 5)
              Padding(
                padding: const EdgeInsets.only(top: 12.0),
                child: LeaderboardCard(
                  rank: leaderboard[currentUserIndex]['rank'],
                  name: leaderboard[currentUserIndex]['name'],
                  level: leaderboard[currentUserIndex]['level'],
                  steps: leaderboard[currentUserIndex]['steps'],
                  hours: leaderboard[currentUserIndex]['hours'],
                  points: leaderboard[currentUserIndex]['points'],
                  highlight: true,
                  highlightColor: Colors.lightBlueAccent.withOpacity(0.3),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildHeaderRow() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: const [
          SizedBox(width: 32, child: Text('#', style: TextStyle(fontWeight: FontWeight.bold))),
          SizedBox(width: 8),
          Expanded(child: Text('name', style: TextStyle(fontWeight: FontWeight.bold))),
          _HeaderStat(label: 'level'),
          _HeaderStat(label: 'steps'),
          _HeaderStat(label: 'hours'),
          _HeaderStat(label: 'points'),
        ],
      ),
    );
  }

  Widget _buildCountryTab() {
    // Placeholder for country leaderboard
    return const Center(child: Text('Country leaderboard coming soon!'));
  }

  Widget _buildFriendsTab() {
    // Placeholder for friends leaderboard
    return const Center(child: Text('Friends leaderboard coming soon!'));
  }

  Widget _buildAchivTab() {
    // Placeholder for Achiv tab
    return const Center(child: Text('Achievements tab coming soon!'));
  }
}

class _HeaderStat extends StatelessWidget {
  final String label;
  const _HeaderStat({required this.label});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
    );
  }
} 