import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/common/error_page.dart';
import 'package:moveo/common/loading_page.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/features/auth/home/view/home_view.dart';
import 'package:moveo/features/auth/view/login_page.dart';
import 'package:moveo/features/auth/view/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:moveo/theme/theme.dart';
import 'package:provider/provider.dart';

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
