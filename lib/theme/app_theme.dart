import 'package:flutter/material.dart';
import 'package:moveo/theme/pallete.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: Pallete.whiteColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Pallete.backgroundColor),
      titleTextStyle: TextStyle(
        color: Pallete.backgroundColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.blueColor,
      foregroundColor: Pallete.whiteColor,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Pallete.backgroundColor),
      bodyMedium: TextStyle(color: Pallete.backgroundColor),
      bodySmall: TextStyle(color: Pallete.greyColor),
      titleLarge: TextStyle(color: Pallete.backgroundColor),
      titleMedium: TextStyle(color: Pallete.backgroundColor),
      titleSmall: TextStyle(color: Pallete.backgroundColor),
    ),
    cardTheme: CardThemeData(
      color: Pallete.whiteColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Pallete.whiteColor,
      labelStyle: const TextStyle(color: Pallete.backgroundColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Pallete.greyColor),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Pallete.whiteColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Pallete.greyColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Pallete.greyColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Pallete.blueColor),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: Pallete.backgroundColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: Pallete.backgroundColor,
      elevation: 0,
      iconTheme: IconThemeData(color: Pallete.whiteColor),
      titleTextStyle: TextStyle(
        color: Pallete.whiteColor,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
    ),
    floatingActionButtonTheme: const FloatingActionButtonThemeData(
      backgroundColor: Pallete.blueColor,
      foregroundColor: Pallete.whiteColor,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Pallete.whiteColor),
      bodyMedium: TextStyle(color: Pallete.whiteColor),
      bodySmall: TextStyle(color: Pallete.greyColor),
      titleLarge: TextStyle(color: Pallete.whiteColor),
      titleMedium: TextStyle(color: Pallete.whiteColor),
      titleSmall: TextStyle(color: Pallete.whiteColor),
    ),
    cardTheme: CardThemeData(
      color: Pallete.searchBarColor,
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    chipTheme: ChipThemeData(
      backgroundColor: Pallete.searchBarColor,
      labelStyle: const TextStyle(color: Pallete.whiteColor),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: const BorderSide(color: Pallete.greyColor),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Pallete.searchBarColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Pallete.greyColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Pallete.greyColor),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: const BorderSide(color: Pallete.blueColor),
      ),
    ),
  );
}
