import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/theme/app_theme.dart';

final themeProvider = StateNotifierProvider<ThemeNotifier, ThemeMode>((ref) {
  return ThemeNotifier();
});

class ThemeNotifier extends StateNotifier<ThemeMode> {
  ThemeNotifier() : super(ThemeMode.system);

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  bool get isDarkMode {
    return state == ThemeMode.dark;
  }

  ThemeData get currentTheme {
    return state == ThemeMode.dark ? AppTheme.darkTheme : AppTheme.lightTheme;
  }
} 