// lib/screens/settings_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../themes/theme_builder.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Language Setting
          ListTile(
            title: const Text('Language'),
            subtitle: Text(settingsProvider.language),
            trailing: const Icon(Icons.language),
            onTap: () => _showLanguageDialog(context, settingsProvider),
          ),

          // Choose Theme
          ListTile(
            title: const Text('Select Theme'),
            subtitle: Text(settingsProvider.currentTheme),
            trailing: const Icon(Icons.palette),
            onTap: () => _showThemeDialog(context, settingsProvider),
          ),

          // App Info Section
          ListTile(
            title: const Text('About'),
            subtitle: const Text('App version and team info'),
            trailing: const Icon(Icons.info_outline),
            onTap: () => _showAboutDialog(context),
          ),

          // Help & Support Section
          ListTile(
            title: const Text('Help & Support'),
            subtitle: const Text('Contact us or check FAQs'),
            trailing: const Icon(Icons.help_outline),
            onTap: () => _showHelpDialog(context),
          ),

          // Divider before Footer
          const Divider(),

          // Credits Footer
          Container(
            padding: const EdgeInsets.all(16.0),
            alignment: Alignment.center,
            child: const Text(
              'Made by rtavares and salavirad\nVersion 2.0.0',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  // Method to show Language Dialog
  void _showLanguageDialog(BuildContext context, SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Language'),
          content: DropdownButton<String>(
            isExpanded: true,
            value: settingsProvider.language,
            items: ['English', 'Spanish', 'French', 'German']
                .map((String language) {
              return DropdownMenuItem<String>(
                value: language,
                child: Text(language),
              );
            }).toList(),
            onChanged: (String? newLanguage) {
              if (newLanguage != null) {
                settingsProvider.setLanguage(newLanguage);
              }
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  // Method to show Theme Dialog
  void _showThemeDialog(BuildContext context, SettingsProvider settingsProvider) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Select Theme'),
          content: DropdownButton<String>(
            isExpanded: true,
            value: settingsProvider.currentTheme,
            items: ThemeBuilder.availableThemes.map((String theme) {
              return DropdownMenuItem<String>(
                value: theme,
                child: Text(theme),
              );
            }).toList(),
            onChanged: (String? newTheme) {
              if (newTheme != null) {
                settingsProvider.setTheme(newTheme);
              }
              Navigator.of(context).pop();
            },
          ),
        );
      },
    );
  }

  // Method to show About Dialog
  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('About'),
          content: const Text(
              'TrackG\nVersion: 2.0.0\ndeveloped by rtavares and salavirad.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  // Method to show Help Dialog
  void _showHelpDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Help & Support'),
          content: const Text(
              'For any issues or support, please contact us at jonny.shaba@sunrise.ch or visit our FAQ section.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
