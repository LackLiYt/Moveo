import 'package:flutter/material.dart';

class Pallete {
  // Base colors
  static const Color backgroundColor = Color.fromRGBO(26, 26, 26, 1); //Або чистий чорний 
  static const Color searchBarColor = Color.fromRGBO(32, 35, 39, 1); //Ще під питанням
  static const Color blueColor = Color.fromRGBO(4, 5, 242, 1); //Сігнатурочка
  static const Color whiteColor = Colors.white;
  static const Color greyColor = Colors.grey;
  
  // Additional colors
  static const Color lightGreyColor = Color.fromRGBO(240, 240, 240, 1);
  static const Color darkGreyColor = Color.fromRGBO(64, 64, 64, 1);
  static const Color errorColor = Color.fromRGBO(255, 0, 0, 1);
  static const Color successColor = Color.fromRGBO(0, 255, 0, 1);
  static const Color warningColor = Color.fromRGBO(255, 165, 0, 1);
  
  // Transparent colors
  static const Color transparent = Colors.transparent;
  static const Color semiTransparent = Color.fromRGBO(0, 0, 0, 0.5);
  
  // Gradient colors
  static const Color gradientStart = Color.fromRGBO(4, 5, 242, 0.8);
  static const Color gradientEnd = Color.fromRGBO(4, 5, 242, 0.4);
}