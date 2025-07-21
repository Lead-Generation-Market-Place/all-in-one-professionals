import 'package:flutter/material.dart';

import 'schemes/food_theme.dart';
import 'theme_mode_type.dart';
import 'schemes/light_theme.dart';
import 'schemes/dark_theme.dart';
import 'schemes/amoled_theme.dart';

class AppTheme {
  static ThemeData getThemeByType(ThemeModeType type) {
    switch (type) {
      case ThemeModeType.dark:
        return darkTheme;
      case ThemeModeType.amoled:
        return amoledTheme;
      case ThemeModeType.food:
        return foodTheme;
      case ThemeModeType.light:
        return lightTheme;
      
    }
  }
}
