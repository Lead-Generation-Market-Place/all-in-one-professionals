import 'package:flutter/material.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';

final amoledTheme = ThemeData(
  fontFamily: 'Inter',
  brightness: Brightness.dark,
  scaffoldBackgroundColor: Colors.black,
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
    primary: AppColors.primaryBlue,
    surface: Colors.black,
  ),
);
