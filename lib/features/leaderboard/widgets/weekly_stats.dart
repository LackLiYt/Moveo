import 'package:flutter/material.dart';
import 'package:moveo/features/leaderboard/view/leaderboard_view.dart';
import 'package:moveo/features/leaderboard/leaderboard_page_view.dart';

class WeeklyUpgradePanel extends StatefulWidget {
  
  final int experience;
  final int steps;
  final String time;
  final int levels;
  final int level;

  const WeeklyUpgradePanel({
    super.key,
    
    required this.experience,
    required this.steps,
    required this.time,
    required this.levels,
    required this.level,
  });

  @override
  State<WeeklyUpgradePanel> createState() => _WeeklyUpgradePanelState();
}

class _WeeklyUpgradePanelState extends State<WeeklyUpgradePanel> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(12),
      child: ExpansionPanelList(
        expansionCallback: (int index, bool isExpanded) {
          setState(() {
            _isExpanded = !_isExpanded;
          });
        },
        elevation: 1,
        expandedHeaderPadding: EdgeInsets.zero,
        children: [
          ExpansionPanel(
            isExpanded: _isExpanded,
            canTapOnHeader: true,
            headerBuilder: (context, isExpanded) {
              return ListTile(
                title: Text(
                  'Your weekly upgrades:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'lvl ${widget.level}',
                  style: TextStyle(color: Colors.blue),
                ),
                
              );
            },
            body: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LeaderboardView(),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildStatItem("Experience", widget.experience.toString()),
                        _buildStatItem("Steps", widget.steps.toString()),
                        _buildStatItem("Time", widget.time),
                        _buildStatItem("Levels", widget.levels.toString()),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const LeaderboardPageView(),
        ),
      );
    },
    child: Column(
      children: [
        Text(label, style: TextStyle(color: Colors.grey[700])),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ],
    ),
  );
}
} 