import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moveo/constants/assets_constants.dart';
import 'package:moveo/constants/ui_constants.dart';
import 'package:moveo/features/post/views/create_post_view.dart';

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;
  final appBar = UiConstants.appBar();

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
  }

  void onCreatePost() {
    Navigator.push(context, CreatePostScreen.route());
  }

  @override
  Widget build(BuildContext context) {
    // Use Theme to dynamically retrieve colors
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor =
        isDarkMode ? Theme.of(context).scaffoldBackgroundColor : Colors.white;
    final iconColor =
        isDarkMode ? Colors.white : Colors.black; // Adjust icon colors

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
