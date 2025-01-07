// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'track_screen.dart';
import 'settings_screen.dart';

class TrackSelectorScreen extends StatefulWidget {
  @override
  _TrackSelectorScreenState createState() => _TrackSelectorScreenState();
}

class _TrackSelectorScreenState extends State<TrackSelectorScreen> {
  final List<Map<String, dynamic>> tracks = [
    {
      'name': 'Current Position',
      'description': 'Drive responsibly! (Requires Location Services)',
      'imagePath': 'assets/placeholder.png',
      'logoPath': 'assets/placeholder.png',
      'boundingBox': null, // No predefined area
    },
    {
      'name': 'Nürburgring Nordschleife',
      'description': 'The Green Hell - 20.8 km of legendary racing history.',
      'imagePath': 'assets/track_nordschleife.jpg',
      'logoPath': 'assets/logo_nordschleife.png',
      'boundingBox': {
        'minLat': 50.3239,
        'maxLat': 50.4390,
        'minLng': 6.9369,
        'maxLng': 7.0149,
      },
    },
    {
      'name': 'Circuit de Spa-Francorchamps',
      'description': 'Home of the Belgian GP - Iconic turns like Eau Rouge.',
      'imagePath': 'assets/track_spa.jpg',
      'logoPath': 'assets/logo_spa.png',
      'boundingBox': {
        'minLat': 50.4283,
        'maxLat': 50.4515,
        'minLng': 5.9406,
        'maxLng': 5.9707,
      },
    },
    {
      'name': 'Silverstone Circuit',
      'description': 'The birthplace of Formula 1 - Fast and technical.',
      'imagePath': 'assets/track_silverstone.jpg',
      'logoPath': 'assets/logo_silverstone.png',
      'boundingBox': {
        'minLat': 52.0615,
        'maxLat': 52.0899,
        'minLng': -1.0201,
        'maxLng': -0.9956,
      },
    },
    {
      'name': 'Suzuka Circuit',
      'description': 'Tight battles, sharp turns, pure precision racing.',
      'imagePath': 'assets/track_suzuka.jpg',
      'logoPath': 'assets/logo_suzuka.png',
      'boundingBox': {
        'minLat': 34.8434,
        'maxLat': 34.8665,
        'minLng': 136.5878,
        'maxLng': 136.6100,
      },
    },
    {
      'name': 'Dangerous Road Winterthur Ed.',
      'description': 'Killer of Volvos. Ruthless and unforgiving.',
      'imagePath': 'assets/track_winti.jpeg',
      'logoPath': 'assets/logo_winti.png',
      'boundingBox': {
        'minLat': 47.4980,
        'maxLat': 47.5080,
        'minLng': 8.7010,
        'maxLng': 8.7210,
      },
    },
    {
      'name': 'Tsukuba Circuit',
      'description': 'Compact and technical - A favorite for time attack.',
      'imagePath': 'assets/track_tsukuba.jpg',
      'logoPath': 'assets/logo_tsukuba.png',
      'boundingBox': {
        'minLat': 36.1835,
        'maxLat': 36.1987,
        'minLng': 140.0862,
        'maxLng': 140.1052,
      },
    },
    {
      'name': 'Autodromo Nazionale Monza',
      'description': 'Temple of Speed - High-speed straights and chicanes.',
      'imagePath': 'assets/track_monza.jpg',
      'logoPath': 'assets/logo_monza.png',
      'boundingBox': {
        'minLat': 45.6105,
        'maxLat': 45.6235,
        'minLng': 9.2655,
        'maxLng': 9.2895,
      },
    },
    {
      'name': 'Autodromo Enzo e Dino Ferrari',
      'description': 'Imola - A historic circuit with challenging corners.',
      'imagePath': 'assets/track_imola.jpg',
      'logoPath': 'assets/logo_imola.png',
      'boundingBox': {
        'minLat': 44.3413,
        'maxLat': 44.3595,
        'minLng': 11.6986,
        'maxLng': 11.7209,
      },
    },
    {
      'name': 'Circuito Ascari',
      'description': 'Exclusive and technical - A driver’s paradise.',
      'imagePath': 'assets/track_ascari.jpg',
      'logoPath': 'assets/logo_ascari.png',
      'boundingBox': {
        'minLat': 36.7995,
        'maxLat': 36.8185,
        'minLng': -5.1650,
        'maxLng': -5.1450,
      },
    },
    {
      'name': 'Red Bull Ring',
      'description': 'Austria’s gem - High-speed and stunning scenery.',
      'imagePath': 'assets/track_redbullring.jpg',
      'logoPath': 'assets/logo_redbullring.png',
      'boundingBox': {
        'minLat': 47.2171,
        'maxLat': 47.2250,
        'minLng': 14.7555,
        'maxLng': 14.7705,
      },
    },
    {
      'name': 'Autodromo Vallelunga',
      'description': 'Technical and versatile - A testing ground for cars.',
      'imagePath': 'assets/track_vallelunga.jpg',
      'logoPath': 'assets/logo_vallelunga.png',
      'boundingBox': {
        'minLat': 42.1305,
        'maxLat': 42.1450,
        'minLng': 12.4135,
        'maxLng': 12.4350,
      },
    },
    {
      'name': 'Circuito de Vila Real',
      'description': 'A thrilling street circuit in Portugal.',
      'imagePath': 'assets/track_vilareal.jpg',
      'logoPath': 'assets/logo_vilareal.png',
      'boundingBox': {
        'minLat': 41.2930,
        'maxLat': 41.3050,
        'minLng': -7.7330,
        'maxLng': -7.7170,
      },
    },
    {
      'name': 'Autódromo Internacional do Algarve',
      'description': 'Portimão - Rollercoaster-like elevation changes.',
      'imagePath': 'assets/track_algarve.jpg',
      'logoPath': 'assets/logo_algarve.png',
      'boundingBox': {
        'minLat': 37.1820,
        'maxLat': 37.2000,
        'minLng': -8.6250,
        'maxLng': -8.6050,
      },
    },
    {
      'name': 'Circuit Paul Ricard',
      'description': 'Colorful stripes and high-speed straights.',
      'imagePath': 'assets/track_paulricard.jpg',
      'logoPath': 'assets/logo_paulricard.png',
      'boundingBox': {
        'minLat': 43.2475,
        'maxLat': 43.2610,
        'minLng': 5.7920,
        'maxLng': 5.8170,
      },
    },
    {
      'name': 'Mount Panorama Circuit',
      'description': 'Bathurst - A legendary track in Australia.',
      'imagePath': 'assets/track_mountpanorama.jpg',
      'logoPath': 'assets/logo_mountpanorama.png',
      'boundingBox': {
        'minLat': -33.4395,
        'maxLat': -33.4255,
        'minLng': 149.5400,
        'maxLng': 149.5650,
      },
    },
  ];

  String searchQuery = '';
  late List<Map<String, dynamic>> filteredTracks;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    filteredTracks = tracks; // Initialize with all tracks
  }

  void _filterTracks(String query) {
    setState(() {
      searchQuery = query.trim().toLowerCase(); // Normalize the query

      if (searchQuery.isEmpty) {
        filteredTracks = tracks; // Show all tracks if the query is empty
      } else {
        // Use regex to match the query anywhere in the name or description
        final regex = RegExp(RegExp.escape(searchQuery), caseSensitive: false);

        filteredTracks = tracks.where((track) {
          final trackName = track['name']!;
          final trackDescription = track['description']!;
          return regex.hasMatch(trackName) || regex.hasMatch(trackDescription);
        }).toList();
      }
    });
  }

  Future<void> _autoLocateTrack() async {
    setState(() {
      isLoading = true;
    });
    try {
      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          // Permissions are denied
          throw 'Location permissions are denied. Please enable them in settings.';
        }
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final userLat = position.latitude;
      final userLng = position.longitude;

      // Check if user is within any track's bounding box
      for (var track in tracks) {
        final boundingBox = track['boundingBox'];
        if (boundingBox != null) {
          if (userLat >= boundingBox['minLat'] &&
              userLat <= boundingBox['maxLat'] &&
              userLng >= boundingBox['minLng'] &&
              userLng <= boundingBox['maxLng']) {
            // Match found! Show the track screen
            Navigator.of(context).push(_createSlideRoute(
              TrackScreen(
                trackName: track['name'],
                trackDescription: track['description'],
                trackLogoPath: track['logoPath'],
              ),
            ));
            setState(() {
              isLoading = false;
            });
            return;
          }
        }
      }

      // No track matched
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No track found at your location.')),
      );
    } catch (e) {
      // Handle errors (e.g., location permissions denied)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }


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
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search Tracks...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: _filterTracks,
            ),
          ),
          // Auto-Locate Button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(), // Show spinner if loading
                  )
                : ElevatedButton.icon(
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
              onPressed: _autoLocateTrack,
            ),
          ),
          // Track Selector Buttons
          Expanded(
            child: ListView.builder(
              itemCount: filteredTracks.length,
              itemBuilder: (context, index) {
                final track = filteredTracks[index];
                return _buildTrackButton(
                  context,
                  name: track['name']!,
                  description: track['description']!,
                  imagePath: track['imagePath']!,
                  logoPath: track['logoPath']!,
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
    required String logoPath,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(_createSlideRoute(
          TrackScreen(
            trackName: name,
            trackDescription: description,
            trackLogoPath: logoPath,
          ),
        ));
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

  Route _createSlideRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0); // Slide in from the right
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }
}
