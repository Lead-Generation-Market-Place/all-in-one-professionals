import 'package:flutter/material.dart';
import 'theme_mode_type.dart';
import 'themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeModeType _currentTheme = ThemeModeType.light;

  ThemeData get themeData => AppTheme.getThemeByType(_currentTheme);

  ThemeModeType get currentTheme => _currentTheme;

  void setTheme(ThemeModeType type) {
    _currentTheme = type;
    notifyListeners();
  }
}
