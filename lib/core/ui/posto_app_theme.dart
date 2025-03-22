import 'package:flutter/material.dart';

class PostoAppTheme {
  PostoAppTheme._();

  static final ThemeData theme = ThemeData(
    scaffoldBackgroundColor: Color(0xFFFFFFFF),
    primaryColor: const Color(0xFF2051E5),
    fontFamily: 'poppins',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2051E5),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
    ),
    // bottomNavigationBarTheme: BottomNavigationBarThemeData(
    //   selectedItemColor: Colors.black,
    //   selectedIconTheme: const IconThemeData(color: Colors.black),
    //   selectedLabelStyle: textBold,
    //   unselectedItemColor: Colors.grey[400],
    //   unselectedIconTheme: IconThemeData(color: Colors.grey[400]),
    // ),
  );
}
