import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'settings_screen.dart';

class TrackScreen extends StatefulWidget {
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
  _TrackScreenState createState() => _TrackScreenState();
}

class _TrackScreenState extends State<TrackScreen> {
  Position? _currentPosition;
  double _currentSpeed = 0.0;
  Completer<GoogleMapController> _mapController = Completer();
  Marker? _currentLocationMarker;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _startLocationUpdates() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled. Please enable them in your settings.';
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied. Please allow location access.';
      }
    }

    // Subscribe to position updates
    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1, // Update every meter
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = position;
        _currentSpeed = position.speed * 3.6; // Convert from m/s to km/h

        // Update current location marker
        _currentLocationMarker = Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(position.latitude, position.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueBlue),
        );
      });

      // Move the map to the current location
      if (_mapController.isCompleted) {
        _mapController.future.then((controller) {
          controller.animateCamera(
            CameraUpdate.newLatLng(
              LatLng(position.latitude, position.longitude),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trackName), // Dynamic track name
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
      body: Column(
        children: [
          // Track Logo
          _buildTrackLogo(),
          const SizedBox(height: 20),

          // Speed and Position
          _buildSpeedAndPosition(theme),

          const SizedBox(height: 20),

          // Google Maps Live GPS Feed
          Expanded(
            child: _buildGoogleMaps(),
          ),
        ],
      ),
      backgroundColor: theme.colorScheme.surface,
    );
  }

  Widget _buildTrackLogo() {
    return Image.asset(
      widget.trackLogoPath,
      height: 100,
      fit: BoxFit.contain,
    );
  }

  Widget _buildSpeedAndPosition(ThemeData theme) {
    return Column(
      children: [
        Text(
          'Current Speed: ${_currentSpeed.toStringAsFixed(1)} km/h',
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          _currentPosition != null
              ? 'Lat: ${_currentPosition!.latitude.toStringAsFixed(5)}, Lng: ${_currentPosition!.longitude.toStringAsFixed(5)}'
              : 'Fetching location...',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleMaps() {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _currentPosition != null
            ? LatLng(_currentPosition!.latitude, _currentPosition!.longitude)
            : const LatLng(0.0, 0.0),
        zoom: 16,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      markers: _currentLocationMarker != null ? {_currentLocationMarker!} : {},
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
    );
  }
}
