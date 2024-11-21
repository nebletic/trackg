// lib/providers/settings_provider.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  // State variables
  bool _isDarkMode = false;
  String _language = 'English';
  String _currentTheme = 'Default'; // For multiple themes

  // Getters
  bool get isDarkMode => _isDarkMode;
  String get language => _language;
  String get currentTheme => _currentTheme;

  // Constructor to load saved settings
  SettingsProvider() {
    _loadSettings();
  }

  // Toggle Dark Mode
  void toggleDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
    _saveSettings();
  }

  // Set Language
  void setLanguage(String language) {
    _language = language;
    notifyListeners();
    _saveSettings();
  }

  // Change Theme
  void setTheme(String themeName) {
    _currentTheme = themeName;
    notifyListeners();
    _saveSettings();
  }

  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    _language = prefs.getString('language') ?? 'English';
    _currentTheme = prefs.getString('currentTheme') ?? 'Default';
    notifyListeners();
  }

  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', _isDarkMode);
    prefs.setString('language', _language);
    prefs.setString('currentTheme', _currentTheme);
  }
}
