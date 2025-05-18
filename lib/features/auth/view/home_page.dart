import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moveo/theme/pallete.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'moveo',
          style: GoogleFonts.montserrat(
            fontWeight: FontWeight.bold,
            color: theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.blueColor,
          ),
        ),
        centerTitle: true,
        leading: Icon(
          Icons.people,
          color: theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
        ),
        actions: [
          Icon(
            Icons.comment,
            color: theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
          ),
          Icon(
            Icons.notifications,
            color: theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
          ),
        ],
      ),
      body: const Center(
        child: Column(
          children: [
            //Weekly upgrades
          ],
        ),
      ),
    );
  }
}