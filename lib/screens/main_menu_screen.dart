// lib/screens/main_menu_screen.dart
import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'dashboard.dart';
import 'settings_screen.dart';

class MainMenuScreen extends StatelessWidget {
  final List<String> newsItems = [
    'trackg isch ume',
    'n54 lauft no!!!',
    'cle 53 wird usglifert!',
    'volvo und pcv oder so',
    'mini het pops and bangs lauft nöd',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Title/News Section (Top 1/3)
          Expanded(
            flex: 1,
            child: Container(
              color: Theme.of(context).colorScheme.primary,
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
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: GridView.count(
                crossAxisCount: 2, // 2 buttons per row
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                children: [
                  _buildAnimatedMenuTile(
                    context,
                    title: 'Dashboard',
                    imagePath: 'assets/placeholder.png',
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
                    imagePath: 'assets/placeholder.png',
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
                    imagePath: 'assets/placeholder.png',
                    onTap: () {
                      // Add navigation to Profile screen
                    },
                  ),
                  _buildAnimatedMenuTile(
                    context,
                    title: 'Help',
                    imagePath: 'assets/placeholder.png',
                    onTap: () {
                      // Add navigation to Help/Support screen
                    },
                  ),
                  _buildAnimatedMenuTile(
                    context,
                    title: 'News',
                    imagePath: 'assets/placeholder.png',
                    onTap: () {
                      // Add navigation to News/Updates screen
                    },
                  ),
                  _buildAnimatedMenuTile(
                    context,
                    title: 'About',
                    imagePath: 'assets/placeholder.png',
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
      height: 100, // adjust the height as needed
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
    required String imagePath,
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
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(
                Colors.black.withOpacity(0.4), // Slightly opaque overlay
                BlendMode.srcOver,
              ),
            ),
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
                child: Text(
                  title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}