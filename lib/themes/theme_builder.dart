// lib/themes/theme_builder.dart
import 'package:flutter/material.dart';

class ThemeBuilder {
  static final Map<String, ThemeData> _themes = {
    'Default': ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      //accentColor: Colors.orange,
      scaffoldBackgroundColor: Colors.white,
    ),
    'Dark': ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.grey[900],
      //accentColor: Colors.blueAccent,
      scaffoldBackgroundColor: Colors.black,
    ),
    'Ocean': ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.teal,
      //accentColor: Colors.lightBlueAccent,
      scaffoldBackgroundColor: Colors.teal[50],
    ),
  };

  // Get theme by name
  static ThemeData getTheme(String themeName) {
    return _themes[themeName] ?? _themes['Default']!;
  }

  // Add a new custom theme (modifiable for future use)
  static void addCustomTheme(String name, ThemeData themeData) {
    _themes[name] = themeData;
  }

  // List of available themes
  static List<String> get availableThemes => _themes.keys.toList();
}
