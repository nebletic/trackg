import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:latlong2/latlong.dart'; // For LatLng
import 'settings_screen.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:developer';

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
  LatLng? _currentPosition; // Default position is now nullable
  double _currentSpeed = 0.0; // Speed in km/h
  double _currentAltitude = 0.0; // Altitude in meters
  double _distanceTraveled = 0.0; // Total distance in meters
  double _currentSlope = 0.0; // New gauge for slope
  double _gForceX = 0.0;
  double _gForceY = 0.0;
  double _gForceZ = 0.0;
  LatLng? _previousPosition;
  double _mapHeading = 0.0; // Map rotation angle in degrees

  final MapController _mapController = MapController();
  final FlutterBluePlus _flutterBlue = FlutterBluePlus();
  BluetoothDevice? _connectedDevice;
  BluetoothCharacteristic? _characteristic;

  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
    _connectToBluetooth();
  }

  Future<void> _connectToBluetooth() async {
    log('Starting Bluetooth scan...');
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10)); // Increase scan duration
    FlutterBluePlus.scanResults.listen((scanResult) async {
      for (var result in scanResult) {
        log('Found device: ${result.device.platformName}');
        if (result.device.platformName == 'ESP32_BLE') { // Ensure the name matches exactly
          log('Found target device: ${result.device.platformName}');
          FlutterBluePlus.stopScan();
          _connectedDevice = result.device;
          try {
            await _connectedDevice!.connect();
            log('Connected to device: ${_connectedDevice!.name}');
            await _discoverServices();
          } catch (error) {
            log('Error connecting to BLE device: $error');
            _retryBluetoothConnection();
          }
          break;
        }
      }
    }, onDone: () {
      if (_connectedDevice == null) {
        log('No BLE device found, retrying...');
        _retryBluetoothConnection();
      }
    });
  }

  void _retryBluetoothConnection() {
    log('Retrying BLE connection...');
    Future.delayed(const Duration(seconds: 5), () {
      _connectToBluetooth();
    });
  }

  Future<void> _discoverServices() async {
    if (_connectedDevice == null) return;

    log('Discovering services...');
    try {
      List<BluetoothService> services = await _connectedDevice!.discoverServices();
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.notify) {
            _characteristic = characteristic;
            await _characteristic!.setNotifyValue(true);
            _characteristic!.lastValueStream.listen((value) {
              String data = utf8.decode(value);
              log('Received BLE data: $data');
              _processBluetoothData(data);
            });
          }
        }
      }
    } catch (error) {
      log('Error discovering services: $error');
      _retryBluetoothConnection();
    }
  }

  void _processBluetoothData(String data) {
    log('Processing Bluetooth data: $data');
    try {
      if (data.isNotEmpty) {
        final jsonData = jsonDecode(data);
        log('Parsed JSON data: $jsonData');
        setState(() {
          _currentSlope = jsonData['slope'] ?? 0.0;
          _gForceX = jsonData['g_force_x'] ?? 0.0;
          _gForceY = jsonData['g_force_y'] ?? 0.0;
          _gForceZ = jsonData['g_force_z'] ?? 0.0; // Remove gravity from Z-axis
        });
      } else {
        log('Received empty data');
      }
    } catch (e) {
      log('Error processing Bluetooth data: $e');
    }
  }

  Future<void> _startLocationUpdates() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw 'Location services are disabled.';
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw 'Location permissions are denied.';
      }
    }

    Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      _processPosition(position);
    });
  }

  void _processPosition(Position position) {
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      double rawSpeed = position.speed * 3.6;
      if (rawSpeed < 1.0) rawSpeed = 0.0;
      _currentSpeed = rawSpeed;
      _currentAltitude = position.altitude;

      if (_previousPosition != null) {
        double distance = const Distance().as(
          LengthUnit.Meter,
          _previousPosition!,
          _currentPosition!,
        );
        if (distance > 0.5) {
          _distanceTraveled += distance;
        }
      }
      _previousPosition = _currentPosition;
      _mapHeading = position.heading.toDouble();
    });
  }

  double _calculateTotalGForce() {
    double adjustedGForceZ = _gForceZ - 9.8;
    return math.sqrt(
      math.pow(_gForceX, 2) + math.pow(_gForceY, 2) + math.pow(adjustedGForceZ, 2),
    );
  }

  @override
  void dispose() {
    _connectedDevice?.disconnect();
    super.dispose();
  }

  Widget _buildStatsTable(ThemeData theme) {
    final stats = [
      {'Metric': '0-100 km/h', 'Value': 'N/A'},
      {'Metric': '100-0 km/h', 'Value': 'N/A'},
      {'Metric': '1/4 Mile', 'Value': 'N/A'},
      {'Metric': '400m', 'Value': 'N/A'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Table(
        border: TableBorder.all(
          color: theme.colorScheme.primary,
          width: 1,
        ),
        children: stats.map((row) {
          return TableRow(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  row['Metric']!,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  row['Value']!,
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }


  Widget _buildGauges(ThemeData theme) {
    return GestureDetector(
      onTap: _resetGauges,
      child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildGauge(
          value: _currentSpeed.toStringAsFixed(1),
          label: 'Speed (km/h)',
          color: theme.colorScheme.primary,
        ),
        _buildGauge(
          value: _currentAltitude.toStringAsFixed(1),
          label: 'Altitude (m)',
          color: theme.colorScheme.secondary,
        ),
        _buildGauge(
          value: (_distanceTraveled / 1000).toStringAsFixed(2),
          label: 'Distance (km)',
          color: theme.colorScheme.tertiary,
        ),
        _buildGauge(
          value: '${_currentSlope.toStringAsFixed(1)}%',
          label: 'Slope',
          color: theme.colorScheme.error,
        ),
        _buildGauge(
          value: '${_calculateTotalGForce().toStringAsFixed(2)} G', 
          label: 'Total G-Force', 
          color: theme.colorScheme.primary
          ),

        ],
      ),
    );
  }


  Widget _buildGauge({
    required String value,
    required String label,
    required Color color,
  }) {
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
                fontSize: 16,
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
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  void _resetGauges() {
    setState(() {
      _currentSpeed = 0.0;
      _currentAltitude = 0.0;
      _distanceTraveled = 0.0;
      _currentSlope = 0.0;
      _gForceX = 0.0;
      _gForceY = 0.0;
      _gForceZ = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.trackName),
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
      body: _currentPosition == null
          ? Center(child: CircularProgressIndicator()) // Show loading indicator until location is received
          : Column(
              children: [
                _buildTrackLogo(),
                const SizedBox(height: 20),
                _buildGauges(theme),
                const SizedBox(height: 20),
                Expanded(
                  flex: 1,
                  child: _buildStatsTable(theme),
                ),
                Expanded(
                  flex: 2,
                  child: _buildOpenStreetMap(),
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

  Widget _buildOpenStreetMap() {
    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: _currentPosition,
            zoom: 16.0,
            rotation: _mapHeading,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.trackg',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentPosition!,
                  width: 40,
                  height: 40,
                  builder: (context) => const Icon(
                    Icons.location_pin,
                    color: Colors.blue,
                    size: 40.0,
                  ),
                ),
              ],
            ),
          ],
        ),
        Positioned(
          bottom: 16,
          right: 16,
          child: FloatingActionButton(
            onPressed: () {
              _mapController.move(_currentPosition!, _mapController.zoom);
              _mapController.rotate(_mapHeading);
            },
            child: const Icon(Icons.my_location),
          ),
        ),
      ],
    );
  }
}