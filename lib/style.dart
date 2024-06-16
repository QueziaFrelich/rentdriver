import 'package:flutter/material.dart';

class AppStyles {
  static ButtonStyle blackButton = ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF1E1E1E),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    fixedSize: Size(145, 31),
  );

  static ButtonStyle garyButton = ElevatedButton.styleFrom(
    backgroundColor: Color(0xFF919191),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(6),
    ),
    fixedSize: Size(217, 31),
  );

  static TextStyle buttonTextStyle = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontFamily: 'Inter',
    fontWeight: FontWeight.w400,
  );
}
