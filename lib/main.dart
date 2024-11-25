import 'package:moveo/pages/login/login_page.dart';
import 'package:moveo/pages/tabs_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pages/main_page/profile_screen.dart';
import 'appwrite/auth_api.dart';

void main() {
  // runApp(const MyApp());
  runApp( MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    //final value = context.watch<AuthAPI>().status;
    //print('TOP CHANGE Value changed to: $value!');

    return MaterialApp(
      title: 'Profile App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const ProfileScreen(),
    );
  }
}
