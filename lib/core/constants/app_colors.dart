import 'package:flutter/material.dart';

class AppColors {
  // Core brand colors
  static const Color primary = Color(0xFF0077B6); // primary
  static const Color primaryDark = Color(0xFF005F91); // primaryDark
  static const Color secondary = Color(0xFF48CAE4); // secondary
  static const Color accent = Color(0xFF00B4D8); // accent

  // Status colors
  static const Color success = Color(0xFF4CAF50); // success
  static const Color warning = Color(0xFFFF9800); // warning
  static const Color error = Color(0xFFF44336); // error

  // Background & surfaces
  static const Color background = Color(0xFFF8FAFC); // background
  static const Color card = Color(0xFFFFFFFF); // card / white

  // Text colors
  static const Color textPrimary = Color(0xFF1E293B); // textPrimary
  static const Color textSecondary = Color(0xFF424242); // textSecondary

  // Border / divider
  static const Color border = Color(0xFFE2E8F0);

  // Utilities
  static Color lighten(Color color, [double amount = .1]) {
    final hsl = HSLColor.fromColor(color);
    final hslLight = hsl.withLightness(
      (hsl.lightness + amount).clamp(0.0, 1.0),
    );
    return hslLight.toColor();
  }
}
