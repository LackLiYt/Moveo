import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moveo/constants/assets_constants.dart';
import 'package:moveo/constants/ui_constants.dart';
import 'package:moveo/theme/pallete.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      bottomNavigationBar: CupertinoTabBar(
          backgroundColor: Pallete.backgroundColor,
          currentIndex: _page,
          onTap: onPageChange,
          items: [
            BottomNavigationBarItem(
              icon: SvgPicture.asset(
                _page == 0
                    ? AssetsConstants.HomeFilledIcon
                    : AssetsConstants.HomeOutlinedIcon,
                color: Pallete.whiteColor,
              ),
            ),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
              AssetsConstants.GlobalIcon,
              color: Pallete.whiteColor,
            )),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
              _page == 2
                  ? AssetsConstants.PostFilledIcon
                  : AssetsConstants.PostOutlinedIcon,
              color: Pallete.whiteColor,
            )),
            BottomNavigationBarItem(
                icon: SvgPicture.asset(
              _page == 3
                  ? AssetsConstants.AccountFilledIcon
                  : AssetsConstants.AccountOutlinedIcon,
              color: Pallete.whiteColor,
            )),
          ]),
    );
  }
}
