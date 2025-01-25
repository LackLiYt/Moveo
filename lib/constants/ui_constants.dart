import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:moveo/constants/assets_constants.dart';

class UiConstants {

  static AppBar appBar() {
    return AppBar(
      title: SvgPicture.asset(AssetsConstants.MoveoTitleBlue,
      ),
    );
  }

  static List<Widget> bottomTabBarPages = [
    const Text('Home Screen'),
    const Text('Public Screen'),
    const Text('Post Screen'),
    const Text('Account Screen'),
  ];

}