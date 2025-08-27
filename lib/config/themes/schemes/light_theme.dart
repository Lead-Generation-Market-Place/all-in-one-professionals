import 'package:flutter/material.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';

final lightTheme = ThemeData(
  fontFamily: 'Inter',
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.background,
  iconTheme: IconThemeData(color: AppColors.background),
  useMaterial3: true,
  colorScheme: ColorScheme.light(
    primary: AppColors.primary,
    primaryContainer: AppColors.primary,
    secondary: AppColors.secondary,
    secondaryContainer: AppColors.secondary,
    surface: Colors.white,
    error: AppColors.error,
    onPrimary: Colors.white,
    onSecondary: Colors.white,
    onSurface: AppColors.textPrimary,
    onError: Colors.white,
  ),

  // Card Theme
  cardTheme: CardThemeData(
    color: Colors.white,
    elevation: 1,
    margin: const EdgeInsets.all(8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    surfaceTintColor: Colors.transparent,
    shadowColor: Colors.black,
  ),

  // App Bar
  appBarTheme: AppBarTheme(
    backgroundColor: AppColors.primary,
    elevation: 0,
    titleTextStyle: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.w600,
      color: AppColors.textPrimary,
      fontFamily: 'Inter',
    ),
    iconTheme: IconThemeData(color: AppColors.textPrimary),
  ),

  // Text Theme
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontSize: 28,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    displayMedium: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    displaySmall: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.bold,
      color: AppColors.textPrimary,
    ),
    bodyLarge: TextStyle(
      fontSize: 20,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
    ),
    bodyMedium: TextStyle(
      fontSize: 17,
      fontWeight: FontWeight.normal,
      color: AppColors.textPrimary,
    ),
    bodySmall: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.normal,
      color: AppColors.textSecondary,
    ),
  ),
  bottomSheetTheme: BottomSheetThemeData(
    // backgroundColor: Colors.white, // or your preferred light color
    modalBackgroundColor: Colors.white, // for modal bottom sheets
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
  ),
  // Input Decoration
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    // fillColor: Colors.white,
    // contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
    border: OutlineInputBorder(
      // borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.accent),
    ),
    enabledBorder: OutlineInputBorder(
      // borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.accent),
    ),
    focusedBorder: OutlineInputBorder(
      // borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.primary),
    ),
    errorBorder: OutlineInputBorder(
      // borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.error),
    ),
    labelStyle: TextStyle(color: AppColors.background),
    hintStyle: TextStyle(color: AppColors.warning),
    errorStyle: TextStyle(
      color: AppColors.error,
      fontSize: 13,
      fontWeight: FontWeight.w500,
      height: 1.2,
    ),
  ),

  // Buttons
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppColors.primary,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
    ),
  ),

  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      foregroundColor: AppColors.primary,
      side: BorderSide(color: AppColors.primary),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      textStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        fontFamily: 'Inter',
      ),
    ),
  ),

  // Other Components
  dividerTheme: DividerThemeData(
    color: AppColors.accent,
    thickness: 1,
    space: 1,
  ),

  floatingActionButtonTheme: FloatingActionButtonThemeData(
    backgroundColor: AppColors.primary,
    foregroundColor: Colors.white,
  ),
);
