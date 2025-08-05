import 'package:flutter/material.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  // Changed to dark
  scaffoldBackgroundColor: Colors.grey[900],
  // Dark background
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primaryBlue,
    // Primary color (buttons, app bar)
    secondary: AppColors.primaryBlue,
    // Secondary color (FAB, accents)
    surface: Colors.grey[800]!,
    // Card, sheet backgrounds
    background: Colors.grey[900]!,
    // Scaffold background
    onPrimary: Colors.white,
    // Text on primary color
    onBackground: Colors.white,
    // Text on background
    onSurface: Colors.white, // Text on surfaces (cards)
  ),
  cardColor: Colors.grey[800],
  // Darker cards
  textTheme: const TextTheme(
    titleSmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: Colors.white, // White text for dark mode
    ),
    titleMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodyMedium: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
    bodyLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: Colors.white,
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    labelStyle: const TextStyle(color: Colors.white70),
    // Slightly faded
    hintStyle: const TextStyle(color: Colors.white54),
    // Even lighter
    fillColor: Colors.grey[800],
    // Dark fill for inputs
    iconColor:AppColors.primaryBlue,
    // Accent color for icons
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.cyan, width: 1.8),
    ),
    filled: true,
    errorStyle: const TextStyle(
      color: Colors.red,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      height: 1.2,
    ),
  ),
  appBarTheme: const AppBarTheme(
    backgroundColor: Colors.black, // Dark app bar
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey[700], // Subtle divider lines
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primaryBlue, // FAB matches primary
  ),
);
