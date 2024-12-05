// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context); // Access the current theme

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nordschleife BTG'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary, // Use primary color from ColorScheme
        actions: [
          // Settings Icon
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to SettingsScreen
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
            _buildConnectionStatus(theme),
            const SizedBox(height: 20),
            _buildLapInfo(theme),
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

  // Adjusted to use theme's colors for the connection status
  Widget _buildConnectionStatus(ThemeData theme) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.secondaryContainer, // Use secondary container color
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'CONNECTED!',
        style: theme.textTheme.bodyLarge?.copyWith(
          color: theme.colorScheme.onSecondaryContainer, // Contrast text color
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _buildLapInfo(ThemeData theme) {
    return Column(
      children: [
        Image.asset(
          'assets/nurburgring_logo.png',
          height: 50,
        ),
        const SizedBox(height: 8),
        Text(
          'Lap 3',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface, // Adapt to surface color
          ),
        ),
      ],
    );
  }

  // Adjusted to use theme's text styles and colors
  Widget _buildTimers(ThemeData theme) {
    return Column(
      children: [
        Text(
          '01:23.592',
          style: theme.textTheme.headlineLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface, // Adapt to surface color
          ),
        ),
        Text(
          'PREDICTED: 07:23.000',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.secondary, // Use theme's secondary color
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

  // Gauges now adapt to the theme's colors
  Widget _buildGaugesRow(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildGauge('10', 'OAT', theme.colorScheme.primary, theme),
        _buildGauge('Signal', 'STRENGTH', theme.colorScheme.secondary, theme),
        _buildGauge('0.0', 'G-FORCE', theme.colorScheme.tertiary, theme),
        _buildGauge('-3%', 'SLOPE', theme.colorScheme.error, theme), // Example with error color
      ],
    );
  }

  // Adjust gauge color based on the theme using colorScheme
  Widget _buildGauge(String value, String label, Color color, dynamic theme) {
    return Column(
      children: [
        Container(
          height: 80,
          width: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 4), // Use theme color
          ),
          child: Center(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color, // Ensure text uses the same color as the gauge
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: theme.colorScheme.onSurface, // Adapt to surface color
          ),
        ),
      ],
    );
  }
}
