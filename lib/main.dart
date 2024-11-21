import 'package:flutter/material.dart';
import 'screens/dashboard.dart';
import 'package:provider/provider.dart';
import 'providers/settings_provider.dart';
import 'screens/settings_screen.dart';
import 'themes/theme_builder.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => SettingsProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          title: 'TrackG',
          theme: ThemeBuilder.getTheme(settingsProvider.currentTheme),
          darkTheme: ThemeBuilder.getTheme('Dark'),
          themeMode: settingsProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: DashboardScreen(),
        );
      },
    );
  }
}
