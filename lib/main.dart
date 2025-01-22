import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/features/auth/view/login_page.dart';
import 'package:moveo/pages/tabs_page.dart';
import 'package:flutter/material.dart';
import 'package:moveo/theme/theme.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    const ProviderScope(
      child:  MyApp()
      ),
    );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Moveo',
        theme: AppTheme.theme, //Тест білої/чорної теми
        home: const LoginPage(),
        );
  }
}
