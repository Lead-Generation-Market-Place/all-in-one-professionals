import 'package:flutter/material.dart';

import 'theme_mode_type.dart';
import 'schemes/light_theme.dart';
import 'schemes/dark_theme.dart';

class AppTheme {
  static ThemeData getThemeByType(ThemeModeType type) {
    switch (type) {
      case ThemeModeType.dark:
        return darkTheme;
      case ThemeModeType.light:
        return lightTheme;
      case ThemeModeType.system:
        return lightTheme;
    }
  }
}
