import 'package:flutter/material.dart';

class PostoAppTheme {
  PostoAppTheme._();

  static final ThemeData theme = ThemeData(
    scaffoldBackgroundColor: Color(0xFFd5d9dd),
    primaryColor: const Color(0xFF2051E5),
    hintColor: Colors.white,
    fontFamily: 'poppins',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2051E5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
  );
}
