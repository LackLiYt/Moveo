import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DonttHaveAcc extends StatelessWidget {
  const DonttHaveAcc({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(text: TextSpan(
      text: "Don't have an account?",
      style: GoogleFonts.montserrat(color:const Color(0xFF0437F2), fontWeight: FontWeight.w600,),
      
      children: [
        TextSpan(text: " Sign up", style: GoogleFonts.montserrat(color: const Color(0xFF0437F2),fontWeight: FontWeight.w600,), recognizer: TapGestureRecognizer()..onTap=(){})
      ]
    ));
  }
}