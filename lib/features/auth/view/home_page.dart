import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  static route() => MaterialPageRoute(builder: (context) => const HomePage());
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(


      appBar: AppBar(
        title: Text('moveo', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, color: const Color(0xFF0437F2))),
        centerTitle: true,
        leading: const Icon(Icons.people),
        actions: const [
          //comment icon
          Icon(Icons.comment),
          //notifications icon
          Icon(Icons.notifications)
        ],
      ),
      body: const Center(
        child:  Column(
          children:  [
            //Weekly upgrades


          ]
        ,)
      )
    );
  }
}