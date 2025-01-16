// lib/screens/main_menu_screen.dart
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'dashboard.dart';
import 'settings_screen.dart';

class MainMenuScreen extends StatelessWidget {
  final List<String> newsItems = [
    'TrackG v2',
    'NEW TRACKS: Nürburgring, Spa-Francorchamps, and more!',
    'Jonny Shaba',
    'COMING SOON: Lap Time Leaderboards!',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
        Container(
          height: 20,
          color: Theme.of(context).colorScheme.primary,
          ),
        // App Logo
        Container(
          width: double.infinity,
          color: Theme.of(context).colorScheme.primary,
          padding: const EdgeInsets.all(16.0),
          child: Image.asset(
            'assets/menu_trackglogo_tr.png',
            height: 60, // Adjust the height as needed
          ),
        ),
        // Title/News Section (Top 1/3)
        ColoredBox(
          color: Theme.of(context).colorScheme.primary,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'App News',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                _buildNewsCarousel(context),
              ],
            ),
          ),
        ),
          // Buttons Section (Bottom 2/3)
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
              crossAxisCount: 2, // 2 buttons per row
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              children: [
                _buildAnimatedMenuTile(
                  context,
                  title: 'Track Selection',
                  icon: Icons.track_changes,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => TrackSelectorScreen(),
                      ),
                    );
                  },
                ),
                _buildAnimatedMenuTile(
                  context,
                  title: 'Settings',
                  icon: Icons.settings,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => SettingsScreen(),
                      ),
                    );
                  },
                ),
                _buildAnimatedMenuTile(
                  context,
                  title: 'Profile',
                  icon: Icons.person,
                  onTap: () {
                    // Add navigation to Profile screen
                  },
                ),
                _buildAnimatedMenuTile(
                  context,
                  title: 'Help',
                  icon: Icons.help,
                  onTap: () {
                    // Add navigation to Help/Support screen
                  },
                ),
                _buildAnimatedMenuTile(
                  context,
                  title: 'News',
                  icon: Icons.article,
                  onTap: () {
                    // Add navigation to News/Updates screen
                  },
                ),
                _buildAnimatedMenuTile(
                  context,
                  title: 'About',
                  icon: Icons.info,
                  onTap: () {
                    // Add navigation to About screen
                  },
                ),
              ],
            ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNewsCarousel(BuildContext context) {
    return SizedBox(
      height: 70, // adjust the height as needed
      child: Swiper(
        autoplay: true,
        autoplayDelay: 3000,
        itemCount: newsItems.length,
        itemBuilder: (context, index) {
          return Center(
            child: Text(
              newsItems[index],
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
              textAlign: TextAlign.center,
            ),
          );
        },
      ),
    );
  }


  // Animated Tile with Hover and Ripple Effects
  Widget _buildAnimatedMenuTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: theme.colorScheme.primary.withOpacity(0.1),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.onSurface.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(4, 4),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              splashColor: theme.colorScheme.primary.withOpacity(0.2), // Ripple effect
              onTap: onTap,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 40, color: theme.colorScheme.onSurface),
                    const SizedBox(height: 8),
                    Text(
                      title,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: theme.colorScheme.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}