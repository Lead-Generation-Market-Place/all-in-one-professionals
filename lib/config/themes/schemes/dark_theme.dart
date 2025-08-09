import 'package:flutter/material.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  // Changed to dark
  scaffoldBackgroundColor: Colors.grey[900],
  // Dark background
  iconTheme: IconThemeData(
    color: AppColors.white

  ),
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
  cardTheme: CardThemeData(
    color: AppColors.black,
    elevation: 1,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.black.withOpacity(0.1),
  ),
  cardColor: Colors.grey[800],
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: Colors.grey[800]!, // or your preferred dark color
    modalBackgroundColor: Colors.grey[800]!, // for modal bottom sheets
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  ),
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
    filled: true,
    fillColor: Colors.grey[800], // Dark fill color
    labelStyle: const TextStyle(color: Colors.white70),
    hintStyle: const TextStyle(color: Colors.white54),
    iconColor: AppColors.primaryBlue,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.grey),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.cyan, width: 1.8),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: const BorderSide(color: Colors.red, width: 1.5),
    ),
    errorStyle: const TextStyle(
      color: Colors.red,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      height: 1.2,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
  style: ElevatedButton.styleFrom(
    backgroundColor: AppColors.primaryBlue,
    foregroundColor: Colors.white,
    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
    textStyle: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      fontFamily: 'Inter',
    ),
  ),
),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primaryBlue,
      side: BorderSide(color: AppColors.primaryBlue),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primaryBlue,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: const TextStyle(
        color: AppColors.white,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Inter',
      ),
    ),
  ),




  appBarTheme: const AppBarTheme(
    backgroundColor: AppColors.primaryBlue, // Dark app bar
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
