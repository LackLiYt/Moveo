import 'package:flutter/material.dart';
import 'package:moveo/theme/pallete.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Pallete.whiteColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.whiteColor,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.blueColor,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Pallete.greyColor),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.backgroundColor,
      elevation: 0,
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.blueColor,
    ),
    textTheme: const TextTheme(
      bodyMedium: TextStyle(color: Pallete.whiteColor),
    ),
  );
}
