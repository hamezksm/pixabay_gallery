import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_constants.dart';

// Theme Provider for managing light/dark mode
class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;

  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeProvider() {
    _loadThemeFromPrefs();
  }

  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    _saveThemeToPrefs();
    notifyListeners();
  }

  void setThemeMode(ThemeMode mode) {
    if (_themeMode != mode) {
      _themeMode = mode;
      _saveThemeToPrefs();
      notifyListeners();
    }
  }

  void setLightTheme() {
    setThemeMode(ThemeMode.light);
  }

  void setDarkTheme() {
    setThemeMode(ThemeMode.dark);
  }

  void setSystemTheme() {
    setThemeMode(ThemeMode.system);
  }

  Future<void> _loadThemeFromPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeString = prefs.getString(AppConstants.themeKey);

      if (themeString != null) {
        _themeMode = ThemeMode.values.firstWhere(
          (mode) => mode.toString() == themeString,
          orElse: () => ThemeMode.light,
        );
        notifyListeners();
      }
    } catch (e) {
      // If there's an error loading preferences, use default light theme
      _themeMode = ThemeMode.light;
    }
  }

  Future<void> _saveThemeToPrefs() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppConstants.themeKey, _themeMode.toString());
    } catch (e) {
      // Handle error silently - theme will still work for current session
      debugPrint('Error saving theme preference: $e');
    }
  }
}
