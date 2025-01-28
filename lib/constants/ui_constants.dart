import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:moveo/constants/assets_constants.dart';

class UiConstants {
  static AppBar appBar(BuildContext context) {
    return AppBar(
      centerTitle: true, // Center the title
      title: SvgPicture.asset(
        // Dynamically choose the title asset based on the theme
        Theme.of(context).brightness == Brightness.light
            ? AssetsConstants.MoveoTitleBlue
            : AssetsConstants.MoveoTitleBlack,
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
