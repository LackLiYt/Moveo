import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moveo/constants/assets_constants.dart';
import 'package:moveo/constants/ui_constants.dart';
import 'package:moveo/features/leaderboard/leaderboard_page_view.dart';
import 'package:moveo/features/post/views/create_post_view.dart';
import 'package:moveo/features/account/accout_page.dart';
import 'package:moveo/features/health/health_data.dart';
import 'package:health/health.dart';
import 'dart:async';

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => HomeView(),
      );
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> with WidgetsBindingObserver {

  @override
  initState(){
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadInitialStepData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }
  Timer? _stepUpdateTimer;
  final health = Health();

  int _counter = 0;
  int _getSteps = 0;

  void _startPeriodicStepUpdates() {
    _stopPeriodicStepUpdates();
    print("Запускаємо таймер для оновлення кроків кожні 30 секунд");
    _stepUpdateTimer = Timer.periodic(const Duration(seconds: 70), (timer) {
      print("Дані про кроки оновлено");
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
      _loadInitialStepData();
      _startPeriodicStepUpdates();
    } else if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive || state == AppLifecycleState.hidden) {
      print("Додаток згорнуто (paused)");
      _stopPeriodicStepUpdates();
    }
  }

  int _page = 0;


  Future<void> _loadInitialStepData() async {
    // Викликаємо функцію з іншого файлу, передаючи наш екземпляр health
    int? steps = await fetchStepData(health);

    // Перевіряємо, чи віджет ще існує перед викликом setState
    if (mounted) {
      setState(() {
        _getSteps = steps ?? 0; // Оновлюємо стан. Якщо steps = null, ставимо 0.
      });
    }
  }

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
    return Scaffold(
      appBar: appBar,
      body: IndexedStack(
        index: _page,
        children: UiConstants.bottomTabBarPages,
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
            onLeaderboard();
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