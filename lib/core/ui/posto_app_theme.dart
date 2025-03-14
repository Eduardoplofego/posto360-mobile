import 'package:flutter/material.dart';

class PostoAppTheme {
  PostoAppTheme._();

  static final ThemeData theme = ThemeData(
    scaffoldBackgroundColor: Color(0xFFFFFFFF),
    primaryColor: const Color(0xFF2051E5),
    // fontFamily: 'mplus1',
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2051E5),
        textStyle: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
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

  static const TextStyle textBold = TextStyle(fontWeight: FontWeight.bold);
}
