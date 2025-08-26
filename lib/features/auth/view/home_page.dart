import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moveo/theme/pallete.dart';
import 'package:moveo/features/chat/views/chat_page_view.dart';

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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: IconButton(
              icon: SizedBox(
                width: 24.0,
                height: 24.0,
                child: Icon(
                  Icons.chat_bubble_outline,
                  color: theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
                ),
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => const ChatPageView(),
                ));
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Icon(
              Icons.notifications,
              color: theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.backgroundColor,
            ),
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