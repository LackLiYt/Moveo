import 'package:moveo/pages/login/login_page.dart';
import 'package:moveo/pages/tabs_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'appwrite/auth_api.dart';

void main() {
  runApp(
    const ProviderScope(child: MyApp()),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Moveo',
      theme: AppTheme.theme, //Тест білої/чорної теми
      home: ref.watch(currentUserAccountProvider).when(
            data: (user) {
              
              if (user!=null) {
                return const HomeView();
              }
              return const SignUpPage();
            },
            error: (error, st) => ErrorPage(error: error.toString()
            ),
            loading: () => const LoadingPage(),
          ),
    );
  }
}
