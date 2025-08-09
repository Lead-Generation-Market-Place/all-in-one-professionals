import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'theme_mode_type.dart';
import 'themes.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeModeType _currentTheme = ThemeModeType.light;
  final String _themeKey = "app_theme";

  ThemeData get themeData => AppTheme.getThemeByType(_currentTheme);

  ThemeModeType get currentTheme => _currentTheme;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  Future<void> _loadThemeFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final themeIndex = prefs.getInt(_themeKey);
    if (themeIndex != null) {
      _currentTheme = ThemeModeType.values[themeIndex];
      notifyListeners();
    }
  }

  Future<void> setTheme(ThemeModeType type) async {
    _currentTheme = type;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_themeKey, type.index);
  }
}
