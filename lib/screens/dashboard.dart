// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'track_screen.dart';
import 'settings_screen.dart';

class DashboardScreen extends StatelessWidget {
  final List<Map<String, String>> tracks = [
    {
      'name': 'Nürburgring Nordschleife',
      'description': 'The Green Hell - 20.8 km of legendary racing history.',
      'imagePath': 'assets/track_nordschleife.jpg',
    },
    {
      'name': 'Circuit de Spa-Francorchamps',
      'description': 'Home of the Belgian GP - Iconic turns like Eau Rouge.',
      'imagePath': 'assets/track_spa.jpg',
    },
    {
      'name': 'Silverstone Circuit',
      'description': 'The birthplace of Formula 1 - Fast and technical.',
      'imagePath': 'assets/track_silverstone.jpg',
    },
    {
      'name': 'Suzuka Circuit',
      'description': 'Tight battles, sharp turns, pure precision racing.',
      'imagePath': 'assets/track_suzuka.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select a Track'),
        centerTitle: true,
        backgroundColor: theme.colorScheme.primary,
        actions: [
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
      body: Column(
        children: [
          // Auto-Locate Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.gps_fixed),
              label: const Text('Auto-Locate Track'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: theme.colorScheme.primary,
                foregroundColor: theme.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                // Placeholder for GPS logic
              },
            ),
          ),
          // Track Selector Buttons
          Expanded(
            child: ListView.builder(
              itemCount: tracks.length,
              itemBuilder: (context, index) {
                final track = tracks[index];
                return _buildTrackButton(
                  context,
                  name: track['name']!,
                  description: track['description']!,
                  imagePath: track['imagePath']!,
                  onTap: () {
                    // Navigate to the selected track's screen
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackButton(
    BuildContext context, {
    required String name,
    required String description,
    required String imagePath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => TrackScreen(
              trackName: name,
              trackDescription: description,
              trackLogoPath: imagePath,
            ),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
        height: 120,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.srcOver,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
