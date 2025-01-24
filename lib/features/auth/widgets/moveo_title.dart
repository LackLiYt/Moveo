import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class MoveoTitle extends StatelessWidget {
  const MoveoTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('moveo', style: GoogleFonts.montserrat(color: const Color(0xFF0437F2), fontWeight: FontWeight.bold, fontSize: 50 ));
  }
}