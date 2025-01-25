<<<<<<< Updated upstream
import 'package:moveo/pages/login/login_page.dart';
import 'package:moveo/pages/tabs_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'appwrite/auth_api.dart';
=======
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moveo/common/error_page.dart';
import 'package:moveo/common/loading_page.dart';
import 'package:moveo/features/auth/controller/auth_controller.dart';
import 'package:moveo/features/auth/view/sign_up_page.dart';
import 'package:flutter/material.dart';
import 'package:moveo/features/home/view/home_view.dart';
import 'package:moveo/theme/theme.dart';
>>>>>>> Stashed changes

void main() {
  // runApp(const MyApp());
  runApp(ChangeNotifierProvider(
      create: ((context) => AuthAPI()), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final value = context.watch<AuthAPI>().status;
    print('TOP CHANGE Value changed to: $value!');

    return MaterialApp(
        title: 'Moveo',
        debugShowCheckedModeBanner: false,
        home: value == AuthStatus.uninitialized
            ? const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              )
            : value == AuthStatus.authenticated
                ? const TabsPage()
                : const LoginPage(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFF0437F2),
          ),
        ));
  }
}
