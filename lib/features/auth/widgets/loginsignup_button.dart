import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';



class LoginButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color backgroundColor;
  final Color textColor;
  const LoginButton({
  super.key,
  required this.label,
  required this.onTap,
  required this.backgroundColor,
  required this.textColor,
  });


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap:onTap,
      child: Chip(
        label: Text(label, style: GoogleFonts.montserrat(color: textColor, fontWeight: FontWeight.w600), overflow: TextOverflow.visible,),
        backgroundColor: backgroundColor,
        labelPadding: const EdgeInsets.symmetric(horizontal: 152, vertical: 7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
        
        
      
      
        
      ),
    );

  }
}