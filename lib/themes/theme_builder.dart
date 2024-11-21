// lib/themes/theme_builder.dart
import 'package:flutter/material.dart';

class ThemeBuilder {
  static final Map<String, ThemeData> _themes = {
    'Default': ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.blue,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.blue,
        secondary: Colors.orange,  // Use for accents
      ),
      // Custom colors for dashboard
      cardColor: Colors.blue[200]!,
      indicatorColor: Colors.blue,  // Gauge color
    ),
    'Dark': ThemeData(
      brightness: Brightness.dark,
      primaryColor: Colors.grey[900]!,
      scaffoldBackgroundColor: Colors.black,
      colorScheme: ColorScheme.fromSwatch(brightness: Brightness.dark).copyWith(
        primary: Colors.grey[900]!,
        secondary: Colors.blueAccent,
      ),
      cardColor: Colors.grey[800]!,
      indicatorColor: Colors.grey[600]!,
    ),
    'Ocean': ThemeData(
      brightness: Brightness.light,
      primaryColor: Colors.teal,
      scaffoldBackgroundColor: Colors.teal[50]!,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: Colors.teal,
        secondary: Colors.lightBlueAccent,
      ),
      cardColor: Colors.teal[200]!,
      indicatorColor: Colors.teal,
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
