import 'package:flutter/material.dart';
import 'package:trackg/screens/main_menu_screen.dart';
import 'package:provider/provider.dart';
import 'providers/settings_provider.dart';
import 'providers/telemetry_provider.dart';
import 'themes/theme_builder.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => SettingsProvider()),
        // it bricks track selector for some unknown reason...
        // dispose also doesnt work properly i.e. it doesnt get cleared in the tel_screen
        //ChangeNotifierProvider(create: (context) => TelemetryProvider()), // Add TelemetryProvider
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, child) {
        return MaterialApp(
          title: 'TrackG',
          theme: ThemeBuilder.getTheme(settingsProvider.currentTheme),
          darkTheme: ThemeBuilder.getTheme('Dark'),
          themeMode: settingsProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: MainMenuScreen(),
        );
      },
    );
  }
}
