import 'package:flutter/material.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';

ThemeData getSystemTheme(BuildContext context) {
  final brightness = MediaQuery.of(context).platformBrightness;

  return brightness == Brightness.dark
      ? ThemeData(
          fontFamily: 'Inter',
          brightness: Brightness.dark,
          scaffoldBackgroundColor: Colors.black,
          useMaterial3: true,
          colorScheme: const ColorScheme.dark(
            primary: AppColors.primaryBlue,
            surface: Colors.black,
          ),
          // Add other dark theme properties as needed
        )
      : ThemeData(
          fontFamily: 'Inter',
          brightness: Brightness.light,
          scaffoldBackgroundColor: AppColors.background,
          useMaterial3: true,
          colorScheme: ColorScheme.light(
            primary: AppColors.primaryBlue,
            surface: Colors.white,
          ),
          // Add other light theme properties as needed
        );
}
