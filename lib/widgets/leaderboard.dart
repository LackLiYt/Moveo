import 'package:flutter/material.dart';
import 'profile_footer.dart';

class LeaderboardScreen extends StatefulWidget {
  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  // Example leaderboard data
  final List<String> leaderboard = List.generate(100, (index) => 'Player ${index + 1} - ${100 - index} points');
  
  // The place of the user (e.g., 100th place)
  final int userPlace = 100;

  // ScrollController to control the scroll position of the leaderboard
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Leaderboard'),
      ),
      body: Column(
        children: [
          Stack(
            children: [
              // Wrapping ListView.builder with Scrollbar for visual feedback
              Expanded(
                child:
                  Scrollbar(
                    controller: _scrollController, // Attach the ScrollController here
                    child: ListView.builder(
                      controller: _scrollController,  // Attach the ScrollController here as well
                      itemCount: leaderboard.length,
                      itemBuilder: (context, index) {
                        return Container(
                          height: 50, // Each list item is 50 pixels tall
                          color: index == userPlace - 1 ? Colors.green.shade200 : Colors.white,
                          alignment: Alignment.centerLeft,
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          child: Text(leaderboard[index], style: TextStyle(fontSize: 16)),
                        );
                      },
                    ),
                  ),
              ),
              // User's position is fixed at the bottom of the screen
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Column(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      color: Colors.green.shade200,
                      child: Center(
                        child: Text(
                          'Your Place: ${userPlace} - ${leaderboard[userPlace - 1]}',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
              ProfileFooter(ishome: false, isboard: true, ispost: false, isprofile: false)

                  ],
                ),

              ),
            ],
          ),
        ],
      ),
    );
  }
}
