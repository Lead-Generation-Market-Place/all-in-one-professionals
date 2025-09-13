import 'package:flutter/material.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';

final darkTheme = ThemeData(
  brightness: Brightness.dark,
  // Changed to dark
  scaffoldBackgroundColor: Colors.black,
  // Dark background
  iconTheme: IconThemeData(color: Colors.grey[800]),
  useMaterial3: true,
  colorScheme: ColorScheme.dark(
    primary: AppColors.primary,

    secondary: AppColors.primary,
    // Secondary color (FAB, accents)
    surface: AppColors.textSecondary,
    // Scaffold background
    onPrimary: Colors.white,
    // Text on background
    onSurface: Colors.white, // Text on surfaces (cards)
  ),
  
  cardTheme: CardThemeData(
    color: AppColors.textPrimary,

    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.black.withOpacity(0.1),
  ),
  cardColor: Colors.grey[800],
  bottomSheetTheme: BottomSheetThemeData(
    backgroundColor: AppColors.textPrimary, // or your preferred dark color
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
    iconColor: AppColors.primary,
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
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.background,
      side: BorderSide(color: AppColors.primary),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: AppColors.primary,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      textStyle: const TextStyle(
        color: AppColors.background,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: 'Inter',
      ),
    ),
  ),

  appBarTheme: AppBarTheme(
    backgroundColor: Colors.black, // Dark app bar
    scrolledUnderElevation: 0,
    titleTextStyle: const TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
  ),
  dividerTheme: DividerThemeData(
    color: Colors.grey[700], // Subtle divider lines
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary, // FAB matches primary
  ),
);
