import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/apis/progress_api.dart';
import 'package:moveo/features/leaderboard/widgets/leaderboard_card.dart';
import 'package:moveo/theme/pallete.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';


class LeaderboardPageView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const LeaderboardPageView(),
      );

  const LeaderboardPageView({super.key});

  @override
  ConsumerState<LeaderboardPageView> createState() => _LeaderboardPageViewState();
}

class _LeaderboardPageViewState extends ConsumerState<LeaderboardPageView> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int currentTab = 0;
  Key _refreshKey = UniqueKey();

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
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              setState(() {
                _refreshKey = UniqueKey();
              });
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          color: theme.brightness == Brightness.dark ? Pallete.backgroundColor : Pallete.whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          children: [
            const SizedBox(height: 12),
            const SizedBox(height: 8),
            TabBar(
              controller: _tabController,
              labelColor: Pallete.blueColor,
              unselectedLabelColor: theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
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
    final currentUserAsync = ref.watch(currentUserDetailsProvider);

    return currentUserAsync.when(
      data: (currentUser) {
        final String currentUserId = currentUser?.uid ?? '';
        return FutureBuilder(
          key: _refreshKey,
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
            // Map to leaderboard entries with robust key fallback (using doc['data'])
            final leaderboard = docs.asMap().entries.map((entry) {
              final i = entry.key;
              final doc = entry.value;
              final data = doc['data'] ?? {};
              final uid = data['uid'] ?? data['userId'] ?? '';
              final name = (data['name'] == null || (data['name'] is String && data['name'].toString().isEmpty))
                ? (currentUser != null && uid == currentUser.uid ? currentUser.name : 'User')
                : data['name'];
              final points = data['points'] ?? 0;
              return {
                'rank': i + 1,
                'uid': uid,
                'name': name,
                'level': data['level'] ?? 1,
                'steps': data['steps'] ?? 0,
                'km': ((data['km'] as num?)?.toDouble() ?? 0.0).toInt(), // Read km from data and convert to int
                'points': points,
              };
            }).toList();
            // Find current user
            final currentUserIndex = leaderboard.indexWhere((e) => e['uid'] == currentUserId);
            // Show all users for debugging
            final displayList = leaderboard;
            return ListView(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              children: [
                _buildHeaderRow(),
                ...displayList.map((e) => LeaderboardCard(
                  rank: e['rank'],
                  name: e['name'],
                  level: e['level'],
                  steps: e['steps'],
                  km: e['km'],
                  points: e['points'],
                  highlight: e['uid'] == currentUserId || e['rank'] <= 3,
                  highlightColor: e['rank'] == 1
                      ? Colors.yellow.withOpacity(0.4) // Gold background
                      : e['rank'] == 2
                          ? Colors.grey[400]?.withOpacity(0.4) // Silver shade
                          : e['rank'] == 3
                              ? Colors.brown[700]?.withOpacity(0.4) // Darker bronze shade
                              : e['uid'] == currentUserId // Apply blue highlight only if current user and not in top 3
                                  ? Colors.lightBlueAccent.withOpacity(0.3)
                                  : null,
                )),
                if (currentUserIndex >= 5)
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: LeaderboardCard(
                      rank: leaderboard[currentUserIndex]['rank'],
                      name: leaderboard[currentUserIndex]['name'],
                      level: leaderboard[currentUserIndex]['level'],
                      steps: leaderboard[currentUserIndex]['steps'],
                      km: leaderboard[currentUserIndex]['km'],
                      points: leaderboard[currentUserIndex]['points'],
                      highlight: true,
                      highlightColor: Colors.lightBlueAccent.withOpacity(0.3),
                    ),
                  ),
              ],
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (_, __) => const Center(child: Text('Failed to load user')),
    );
  }

  Widget _buildHeaderRow() {
    // Define column widths for consistent alignment
    const double rankWidth = 32;
    const int nameFlex = 1; // Use flex for the name to take available space, changed to int
    const double statWidth = 60; // Fixed width for stats (level, steps, hours, points)
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Row(
        children: [
          SizedBox(
            width: rankWidth,
            child: Text(
              '#',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 8), // Space between rank and name
          Expanded(
            flex: nameFlex,
            child: Text(
              'name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: statWidth,
            child: Text(
              'level',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: statWidth,
            child: Text(
              'steps',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: statWidth,
            child: Text(
              'km',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: statWidth,
            child: Text(
              'points',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
              ),
              textAlign: TextAlign.center,
            ),
          ),
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