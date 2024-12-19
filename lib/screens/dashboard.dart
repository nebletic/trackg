// lib/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:fuzzywuzzy/fuzzywuzzy.dart';
import 'track_screen.dart';
import 'settings_screen.dart';

class TrackSelectorScreen extends StatefulWidget {
  @override
  _TrackSelectorScreenState createState() => _TrackSelectorScreenState();
}

class _TrackSelectorScreenState extends State<TrackSelectorScreen> {
  final List<Map<String, String>> tracks = [
    {
      'name': 'Current Position',
      'description': 'Drive responsibly! (Requires Location Services)',
      'imagePath': 'assets/placeholder.png',
      'logoPath': 'assets/placeholder.png',
    },
    {
      'name': 'Nürburgring Nordschleife',
      'description': 'The Green Hell - 20.8 km of legendary racing history.',
      'imagePath': 'assets/track_nordschleife.jpg',
      'logoPath': 'assets/logo_nordschleife.png',
    },
    {
      'name': 'Circuit de Spa-Francorchamps',
      'description': 'Home of the Belgian GP - Iconic turns like Eau Rouge.',
      'imagePath': 'assets/track_spa.jpg',
      'logoPath': 'assets/logo_spa.png',
    },
    {
      'name': 'Silverstone Circuit',
      'description': 'The birthplace of Formula 1 - Fast and technical.',
      'imagePath': 'assets/track_silverstone.jpg',
      'logoPath': 'assets/logo_silverstone.png',
    },
    {
      'name': 'Suzuka Circuit',
      'description': 'Tight battles, sharp turns, pure precision racing.',
      'imagePath': 'assets/track_suzuka.jpg',
      'logoPath': 'assets/logo_suzuka.png',
    },
    {
      'name': 'Dangerous Road Winterthur Ed.',
      'description': 'Killer of Volvos. Ruthless and unforgiving.',
      'imagePath': 'assets/track_winti.jpeg',
      'logoPath': 'assets/logo_winti.png',
    },
    {
    'name': 'Tsukuba Circuit',
    'description': 'Compact and technical - A favorite for time attack.',
    'imagePath': 'assets/track_tsukuba.jpg',
    'logoPath': 'assets/logo_tsukuba.png',
    },
    {
      'name': 'Autodromo Nazionale Monza',
      'description': 'Temple of Speed - High-speed straights and chicanes.',
      'imagePath': 'assets/track_monza.jpg',
      'logoPath': 'assets/logo_monza.png',
    },
    {
      'name': 'Autodromo Enzo e Dino Ferrari',
      'description': 'Imola - A historic circuit with challenging corners.',
      'imagePath': 'assets/track_imola.jpg',
      'logoPath': 'assets/logo_imola.png',
    },
    {
      'name': 'Circuito Ascari',
      'description': 'Exclusive and technical - A driver’s paradise.',
      'imagePath': 'assets/track_ascari.jpg',
      'logoPath': 'assets/logo_ascari.png',
    },
    {
      'name': 'Red Bull Ring',
      'description': 'Austria’s gem - High-speed and stunning scenery.',
      'imagePath': 'assets/track_redbullring.jpg',
      'logoPath': 'assets/logo_redbullring.png',
    },
    {
      'name': 'Autodromo Vallelunga',
      'description': 'Technical and versatile - A testing ground for cars.',
      'imagePath': 'assets/track_vallelunga.jpg',
      'logoPath': 'assets/logo_vallelunga.png',
    },
    {
      'name': 'Circuito de Vila Real',
      'description': 'A thrilling street circuit in Portugal.',
      'imagePath': 'assets/track_vilareal.jpg',
      'logoPath': 'assets/logo_vilareal.png',
    },
    {
      'name': 'Autódromo Internacional do Algarve',
      'description': 'Portimão - Rollercoaster-like elevation changes.',
      'imagePath': 'assets/track_algarve.jpg',
      'logoPath': 'assets/logo_algarve.png',
    },
    {
      'name': 'Circuito do Estoril',
      'description': 'Once home to F1 - A classic Portuguese circuit.',
      'imagePath': 'assets/track_estoril.jpg',
      'logoPath': 'assets/logo_estoril.png',
    },
    {
      'name': 'Circuit Paul Ricard',
      'description': 'Colorful stripes and high-speed straights.',
      'imagePath': 'assets/track_paulricard.jpg',
      'logoPath': 'assets/logo_paulricard.png',
    },
    {
      'name': 'Circuit de Bresse',
      'description': 'A compact French track for versatile racing.',
      'imagePath': 'assets/track_bresse.png',
      'logoPath': 'assets/logo_bresse.png',
    },
    {
      'name': 'Anneau du Rhin',
      'description': 'Technical French track with a rich racing culture.',
      'imagePath': 'assets/track_anneaudurhin.jpg',
      'logoPath': 'assets/logo_anneaudurhin.png',
    },
    {
      'name': 'Circuit des 24 Heures du Mans',
      'description': 'Home of the iconic endurance race.',
      'imagePath': 'assets/track_lemans.jpg',
      'logoPath': 'assets/logo_lemans.png',
    },
    {
      'name': 'Hockenheimring Baden-Württemberg',
      'description': 'A German classic with high-speed straights.',
      'imagePath': 'assets/track_hockenheimring.jpg',
      'logoPath': 'assets/logo_hockenheimring.png',
    },
    {
      'name': 'Bilster Berg',
      'description': 'Challenging and modern - Germany’s hidden gem.',
      'imagePath': 'assets/track_bilsterberg.png',
      'logoPath': 'assets/logo_bilsterberg.png',
    },
    {
      'name': 'Sachsenring',
      'description': 'Tight corners and elevation changes in Germany.',
      'imagePath': 'assets/track_sachsenring.jpg',
      'logoPath': 'assets/logo_sachsenring.png',
    },
    {
      'name': 'Indianapolis Motor Speedway',
      'description': 'The Brickyard - A legendary oval and road course.',
      'imagePath': 'assets/track_indianapolis.png',
      'logoPath': 'assets/logo_indianapolis.png',
    },
    {
      'name': 'Circuit of The Americas',
      'description': 'Austin’s F1 home - Fast and technical sections.',
      'imagePath': 'assets/track_cota.jpg',
      'logoPath': 'assets/logo_cota.png',
    },
    {
      'name': 'Laguna Seca',
      'description': 'The Corkscrew - Iconic elevation drop in the US.',
      'imagePath': 'assets/track_laguna.jpg',
      'logoPath': 'assets/logo_laguna.png',
    },
    {
      'name': 'Willow Springs Racetrack',
      'description': 'High-speed corners in the Californian desert.',
      'imagePath': 'assets/track_willowsprings.png',
      'logoPath': 'assets/logo_willowsprings.png',
    },
    {
      'name': 'Autódromo José Carlos Pace',
      'description': 'Interlagos - Home of thrilling F1 finales.',
      'imagePath': 'assets/track_interlagos.jpg',
      'logoPath': 'assets/logo_interlagos.png',
    },
    {
      'name': 'Mount Panorama Circuit',
      'description': 'Bathurst - A legendary track in Australia.',
      'imagePath': 'assets/track_mountpanorama.jpg',
      'logoPath': 'assets/logo_mountpanorama.png',
    },
  ];

  String searchQuery = '';
  late List<Map<String, String>> filteredTracks;

  @override
  void initState() {
    super.initState();
    filteredTracks = tracks; // Initialize with all tracks
  }

  //it still doesnt search properly...can we start from the beginning? it should search for it across all the strings and if it matches with like this regex "*circuit*" it should show me all tracks with circuit ANYWHERE in the name or description.

  void _filterTracks(String query) {
    setState(() {
      searchQuery = query.trim().toLowerCase(); // Normalize query

      if (searchQuery.isEmpty) {
        filteredTracks = tracks; // Show all tracks if query is empty
      } else {
        // Step 1: Exact substring match
        final exactMatches = tracks.where((track) {
          final trackName = track['name']!.toLowerCase();
          final trackDescription = track['description']!.toLowerCase();
          return trackName.contains(searchQuery) || trackDescription.contains(searchQuery);
        }).toList();

        // Step 2: Fuzzy matching (if no exact matches or for broader matching)
        //final fuzzyMatches = tracks.where((track) {
        //  final trackName = track['name']!;
        //  final trackDescription = track['description']!;
//
        //  final nameScore = partialRatio(searchQuery, trackName.toLowerCase());
        //  final descriptionScore = partialRatio(searchQuery, trackDescription.toLowerCase());
//
        //  // Keep tracks with a match score above 60
        //  return nameScore > 50 || descriptionScore > 50;
        //}).toList();

        // Combine results, giving preference to exact matches
        filteredTracks = [...exactMatches]
            .toSet()
            .toList(); // Remove duplicates
      }
    });
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
              itemCount: filteredTracks.length, 
              itemBuilder: (context, index) {
                final track = tracks[index];
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
