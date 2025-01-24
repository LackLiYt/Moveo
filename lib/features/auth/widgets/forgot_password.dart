import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Text('Forgot password?',
    style: GoogleFonts.montserrat(color: const Color(0xFF0437F2),
    fontWeight: FontWeight.bold,
    fontSize: 12,
    decoration: TextDecoration.underline,
    decorationColor: const Color(0xFF0437F2)
    ));
    
  }
}