// lib/screens/track_screen.dart
import 'package:flutter/material.dart';
import 'settings_screen.dart';

class TrackScreen extends StatelessWidget {
  final String trackName;
  final String trackDescription;
  final String trackLogoPath;

  const TrackScreen({
    Key? key,
    required this.trackName,
    required this.trackDescription,
    required this.trackLogoPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(trackName), // Dynamic track name
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Track Logo Section
            _buildTrackLogo(),
            const SizedBox(height: 20),
            _buildTrackInfo(theme),
            const SizedBox(height: 20),
            _buildTimers(theme),
            const SizedBox(height: 20),
            _buildGaugesRow(theme),
          ],
        ),
      ),
      backgroundColor: theme.colorScheme.surface, // Use theme's surface color
    );
  }

  Widget _buildTrackLogo() {
    return Image.asset(
      trackLogoPath, // Dynamic logo image
      height: 100,
      fit: BoxFit.contain,
    );
  }

  Widget _buildTrackInfo(ThemeData theme) {
    return Column(
      children: [
        Text(
          trackName,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          trackDescription,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildTimers(ThemeData theme) {
    return Column(
      children: [
        Text(
          '01:23.592',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        Text(
          'PREDICTED: 07:23.000',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.secondary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          '-0.592',
          style: theme.textTheme.titleLarge?.copyWith(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGaugesRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildGauge('10', 'OAT', theme.colorScheme.primary),
        _buildGauge('Signal', 'STRENGTH', theme.colorScheme.secondary),
        _buildGauge('0.0', 'G-FORCE', theme.colorScheme.tertiary),
        _buildGauge('-3%', 'SLOPE', theme.colorScheme.error),
      ],
    );
  }

  Widget _buildGauge(String value, String label, Color color) {
    return Column(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 4),
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
