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
}