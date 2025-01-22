import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
class AuthField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  const AuthField({super.key, required this.controller, required this.hintText,});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      
      
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.blue, width: 1)),
          
        
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Colors.grey, width: 1)),
          filled: true,
          fillColor: Color(0xFF0437F2),
          
        contentPadding: EdgeInsets.all(20),
        
        hintText: hintText,
        hintStyle: GoogleFonts.montserrat(
          fontSize:16,
          fontWeight: FontWeight.w600,
          


        )
      ),
    );
  }
}