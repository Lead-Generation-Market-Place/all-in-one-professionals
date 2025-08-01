import 'package:flutter/material.dart';
import 'package:yelpax_pro/core/constants/app_colors.dart';

final lightTheme = ThemeData(
  fontFamily: 'Inter',
  brightness: Brightness.light,
  scaffoldBackgroundColor: AppColors.background,
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
);
