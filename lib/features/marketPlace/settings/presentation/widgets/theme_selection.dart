import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../config/themes/theme_mode_type.dart';
import '../../../../../config/themes/theme_provider.dart';
import '../../../../../core/constants/app_colors.dart';

class ThemeSelection extends StatelessWidget {
  const ThemeSelection({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final currentTheme = themeProvider.currentTheme;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Select Theme')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: ThemeModeType.values.map((theme) {
            final isSelected = currentTheme == theme;

            return GestureDetector(
              onTap: () => themeProvider.setTheme(theme),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 20,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                      : isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).colorScheme.primary
                        : isDarkMode
                        ? Colors.grey.shade700
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      _getIconForTheme(theme),
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : isDarkMode
                          ? Colors.grey.shade400
                          : Colors.grey.shade700,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      _getLabelForTheme(theme),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : isDarkMode
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                    const Spacer(),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  String _getLabelForTheme(ThemeModeType theme) {
    switch (theme) {
      case ThemeModeType.light:
        return 'Light Theme';
      case ThemeModeType.dark:
        return 'Dark Theme';
      case ThemeModeType.system:
      default:
        return 'System Default';
    }
  }

  IconData _getIconForTheme(ThemeModeType theme) {
    switch (theme) {
      case ThemeModeType.light:
        return Icons.light_mode;
      case ThemeModeType.dark:
        return Icons.dark_mode;
      case ThemeModeType.system:
      default:
        return Icons.phone_android;
    }
  }
}