import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moveo/theme/pallete.dart';

class MoveoTitle extends StatelessWidget {
  const MoveoTitle({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      'moveo',
      style: GoogleFonts.montserrat(
        color: theme.brightness == Brightness.dark ? Pallete.whiteColor : Pallete.blueColor,
        fontWeight: FontWeight.bold,
        fontSize: 40,
      ),
    );
  }
}