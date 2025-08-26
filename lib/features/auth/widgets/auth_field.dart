import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:moveo/theme/pallete.dart';

class AuthField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final bool isPassword;
  const AuthField({
    super.key, 
    required this.controller, 
    required this.hintText,
    this.isPassword = false,
  });

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? _obscureText : false,
      style: theme.textTheme.bodyLarge,
      decoration: InputDecoration(
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(color: Pallete.blueColor, width: 1)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: theme.textTheme.bodySmall?.color ?? Pallete.greyColor, width: 1)),
        filled: true,
        fillColor: theme.inputDecorationTheme.fillColor,
        contentPadding: const EdgeInsets.all(20),
        hintText: widget.hintText,
        hintStyle: GoogleFonts.montserrat(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: theme.textTheme.bodySmall?.color,
        ),
        suffixIcon: widget.isPassword ? IconButton(
          icon: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: theme.textTheme.bodySmall?.color,
          ),
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
        ) : null,
      ),
    );
  }
}