import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF03045E); // color1
  static const Color black = Color.fromARGB(255, 12, 29, 41); // color2
  static const Color primaryBlue = Color.fromRGBO(33, 150, 243, 1); // color3
  static const Color highlight = Color(0xFF0096C7); // color4
  static const Color secondaryBlue = Color.fromARGB(
    255,
    111,
    183,
    243,
  ); // color5
  static const Color lightSky = Color(0xFF48CAE4); // color6
  static const Color paleBlue = Color(0xFF90E0EF); // color7
  static const Color softBlue = Color(0xFFADE8F4); // color8
  static const Color background = Color(
    0xFFF5F5F5,
  ); // color9, equivalent to Colors.grey[100]

  static const Color neutral200 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFF9E9E9E);
  static const Color neutral500 = Color(0xFF757575);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color error = Color.fromARGB(255, 248, 21, 21);
  static const Color textPrimary = Colors.black;
  static const Color textSecondary = Colors.grey;
  static const Color textTertiary = Colors.grey;
  static const Color neutral700 = Colors.grey;
  // ✅ Added status colors
  static const Color successGreen = Color(0xFF2E7D32); // A strong success green
  static const Color failureRed = Color(0xFFD32F2F); // A vivid failure red

  static Color lighten(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }
}
