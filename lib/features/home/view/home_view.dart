import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moveo/constants/assets_constants.dart';
import 'package:moveo/constants/ui_constant_main_page.dart';
import 'package:moveo/features/leaderboard/leaderboard_page_view.dart';
import 'package:moveo/features/post/views/create_post_view.dart';
import 'package:moveo/features/account/accout_page.dart';
import 'package:moveo/features/global/views/global_page_view.dart';
import 'package:health/health.dart';
import 'dart:async';
import 'package:moveo/features/home/views/home_content_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/features/health/health_providers.dart';

class HomeView extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
  const HomeView({super.key});

  @override
  ConsumerState<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends ConsumerState<HomeView> with WidgetsBindingObserver {

  @override
  initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  Timer? _stepUpdateTimer;
  final health = Health();

  int _counter = 0;
  final int _getSteps = 0;
  final int _weeklyExperience = 0; // Placeholder state variable
  final String _weeklyTime = 'N/A'; // Placeholder state variable
  final int _weeklyLevelsGained = 0; // Placeholder state variable
  final int _overallLevel = 0; // Placeholder state variable

  void _startPeriodicStepUpdates() {
    _stopPeriodicStepUpdates();
    print("Starting step update timer for every 30 seconds");
    _stepUpdateTimer = Timer.periodic(const Duration(seconds: 30), (timer) {
      print("Updating step data...");
      // Invalidate the stepDataProvider to trigger a refetch
      ref.invalidate(stepDataProvider);
      // The stepDataProvider updates user progress and leaderboard upon fetching new steps
    });
  }

  void _stopPeriodicStepUpdates() {
    if (_stepUpdateTimer != null && _stepUpdateTimer!.isActive) {
      print("Зупиняємо таймер оновлення кроків");
      _stepUpdateTimer!.cancel();
      _stepUpdateTimer = null;
    }
  }
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      print("Додаток активовано (resumed)");
      _startPeriodicStepUpdates();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.hidden) {
      print("Додаток згорнуто (paused)");
      _stopPeriodicStepUpdates();
    }
  }

  int _page = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  void onCreatePost() {
    Navigator.push(context, CreatePostView.route());
  }

  void onAccount() {
    Navigator.push(context, AccountPage.route());
  }

  void onLeaderboard() {
    Navigator.push(context, LeaderboardPageView.route());
  }

  void onGlobal() {
    Navigator.push(context, GlobalPageView.route());
  }

  @override
  Widget build(BuildContext context) {
    // Use Theme to dynamically retrieve colors
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white;
    final iconColor =
        isDarkMode ? Colors.white : Colors.black; // Adjust icon colors

    // Initialize the appBar with context
    final appBar = UiConstants.appBar(context);

    // Watch the currentUserDetailsProvider to get the overall level
    final userDetailsAsyncValue = ref.watch(currentUserDetailsProvider);

    // Watch the stepDataProvider to get the weekly steps
    final stepDataAsyncValue = ref.watch(stepDataProvider);

    // Define the pages for the bottom navigation bar
    final List<Widget> bottomTabBarPages = [
      // Use when to handle loading and error states of userDetailsAsyncValue and stepDataAsyncValue
      userDetailsAsyncValue.when(
        data: (user) => stepDataAsyncValue.when(
          data: (steps) => HomeContentView(
            weeklyExperience: _weeklyExperience, // Use state variable (placeholder for now)
            weeklySteps: steps ?? 0, // Use steps from the provider
            weeklyTime: _weeklyTime, // Use state variable (placeholder for now)
            weeklyLevelsGained: _weeklyLevelsGained, // Use state variable (placeholder for now)
            overallLevel: user?.level ?? 0, // Use overall level from user details
          ),
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stackTrace) => Center(child: Text('Error loading step data: $error')),
        ),
        loading: () => const Center(child: CircularProgressIndicator()), // Show loading while user details load
        error: (error, stackTrace) => Center(child: Text('Error loading user data: $error')),
      ),
      GlobalPageView(),
      CreatePostView(), // Post creation view
      AccountPage(), // Account page
    ];

    return Scaffold(
      appBar: appBar,
      body: IndexedStack(
        index: _page,
        children: bottomTabBarPages,
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: backgroundColor,
        currentIndex: _page,
        onTap: (index) {
          if (index == 2) {
            // Post icon index
            onCreatePost();
          } else if (index == 3) {
            // Account icon index
            onAccount();
          } else if (index == 1) {
            // Leaderboard icon index
            //onLeaderboard();
            onGlobal();
          } else {
            onPageChange(index);
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 0
                  ? AssetsConstants.HomeFilledIcon
                  : AssetsConstants.HomeOutlinedIcon,
              color: iconColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              AssetsConstants.GlobalIcon,
              color: iconColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 2
                  ? AssetsConstants.PostFilledIcon
                  : AssetsConstants.PostOutlinedIcon,
              color: iconColor,
            ),
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              _page == 3
                  ? AssetsConstants.AccountFilledIcon
                  : AssetsConstants.AccountOutlinedIcon,
              color: iconColor,
            ),
          ),
        ],
      ),
    );
  }
  
}