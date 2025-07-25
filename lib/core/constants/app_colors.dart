import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF03045E); // color1
  static const Color accent = Color(0xFF023E8A); // color2
  static const Color primaryBlue = Color(0xFF0077B6); // color3
  static const Color highlight = Color(0xFF0096C7); // color4
  static const Color secondaryBlue = Color(0xFF00B4D8); // color5
  static const Color lightSky = Color(0xFF48CAE4); // color6
  static const Color paleBlue = Color(0xFF90E0EF); // color7
  static const Color softBlue = Color(0xFFADE8F4); // color8
  static const Color background = Color(0xFFCAF0F8); // color9

  static const Color neutral200 = Color(0xFFE0E0E0);
  static const Color neutral400 = Color(0xFF9E9E9E);
  static const Color neutral500 = Color(0xFF757575);
  static const Color white = Color.fromARGB(255, 255, 255, 255);
  static const Color error = Color.fromARGB(255, 248, 21, 21);

  // ✅ Added status colors
  static const Color successGreen = Color(0xFF2E7D32); // A strong success green
  static const Color failureRed = Color(0xFFD32F2F); // A vivid failure red

  static Color lighten(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0));
    return hslLight.toColor();
  }
}
