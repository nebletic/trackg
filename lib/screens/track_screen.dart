import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_compass/flutter_compass.dart'; // New for compass integration
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:latlong2/latlong.dart'; // For LatLng
import 'settings_screen.dart';
import 'dart:convert';
import 'dart:math' as math;
import 'dart:async';

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
  LatLng? _currentPosition; // User's current GPS position
  double _currentSpeed = 0.0; // Speed in km/h
  double _smoothedSpeed = 0.0; 
  double _currentAltitude = 0.0; // Altitude in meters
  double _distanceTraveled = 0.0; // Total distance in meters
  double _currentSlope = 0.0;
  double _gForceX = 0.0, _gForceY = 0.0, _gForceZ = 0.0; // G-force components
  double _mapHeading = 0.0; // Compass heading
  double _pitch = 0.0; // Pitch angle
  double _roll = 0.0; // Roll angle
  bool _mapReady = false;
  bool _isConnected = false; // Bluetooth connection status
  LatLng? _previousPosition;

  final MapController _mapController = MapController();
  final FlutterBluePlus _flutterBlue = FlutterBluePlus();
  BluetoothDevice? _connectedDevice;

  StreamSubscription<Position>? _positionStreamSubscription;
  StreamSubscription<CompassEvent>? _compassStreamSubscription;

  // 0-100 km/h measurement variables
  bool _isMeasuring = false;
  DateTime? _startTime;
  double _zeroToHundredTime = 0.0;
  final double _speedThreshold = 5.0; // Speed threshold to start measurement
  final int _smoothingWindowSize = 5; // Window size for speed smoothing
  final List<double> _speedWindow = [];


  @override
  void initState() {
    super.initState();
    _startLocationUpdates();
    _connectToBluetooth();
    _startCompassUpdates();
  }
  // ---------------------------------------------------
  // BLUETOOTH
  // ---------------------------------------------------
  Future<void> _connectToBluetooth() async {
    FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    FlutterBluePlus.scanResults.listen((results) async {
      for (var result in results) {
        if (result.device.platformName == 'ESP32_BLE') {
          FlutterBluePlus.stopScan();
          _connectedDevice = result.device;
          try {
            await _connectedDevice!.connect();
            setState(() {
              _isConnected = true;
            });
            await _discoverServices();
          } catch (error) {
            setState(() {
              _isConnected = false;
            });
            _retryBluetoothConnection();
          }
          break;
        }
      }
    });
  }

  void _retryBluetoothConnection() {
    Future.delayed(const Duration(seconds: 5), _connectToBluetooth);
  }

  Future<void> _discoverServices() async {
    if (_connectedDevice == null) return;

    try {
      List<BluetoothService> services = await _connectedDevice!.discoverServices();
      for (var service in services) {
        for (var characteristic in service.characteristics) {
          if (characteristic.properties.notify) {
            await characteristic.setNotifyValue(true);
            characteristic.lastValueStream.listen((value) {
              _processBluetoothData(utf8.decode(value));
            });
          }
        }
      }
    } catch (error) {
      setState(() {
        _isConnected = false;
      });
      _retryBluetoothConnection();
    }
  }

  void _processBluetoothData(String data) {
    try {
      final jsonData = jsonDecode(data);
      setState(() {
        _currentSlope = jsonData['slope'] ?? 0.0;
        _gForceX = jsonData['g_force_x'] ?? 0.0;
        _gForceY = jsonData['g_force_y'] ?? 0.0;
        _gForceZ = jsonData['g_force_z'] ?? 0.0; // Z-axis without gravity subtracted
        _pitch = jsonData['pitch'] ?? 0.0;
        _roll = jsonData['roll'] ?? 0.0;
      });
    } catch (_) {}
  }

  // ---------------------------------------------------
  // GPS
  // ---------------------------------------------------
  Future<void> _startLocationUpdates() async {
    _positionStreamSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 1,
      ),
    ).listen((Position position) {
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _currentSpeed = position.speed * 3.6; // m/s to km/h
        _currentAltitude = position.altitude;

        // Apply speed smoothing
        _speedWindow.add(_currentSpeed);
        if (_speedWindow.length > _smoothingWindowSize) {
          _speedWindow.removeAt(0);
        }
        _smoothedSpeed = _speedWindow.reduce((a, b) => a + b) / _speedWindow.length;

        if (_previousPosition != null) {
          final distance = Geolocator.distanceBetween(
            _previousPosition!.latitude,
            _previousPosition!.longitude,
            position.latitude,
            position.longitude,
          );
          _distanceTraveled += distance;
        }

        _previousPosition = _currentPosition;

        if (_mapReady && _currentPosition != null) {
          // Move map only when ready
          _mapController.move(_currentPosition!, _mapController.zoom);
        }

        // Automatic 0-100 km/h measurement
        if (_isMeasuring) {
          if (_smoothedSpeed >= 100.0) {
            _zeroToHundredTime = DateTime.now().difference(_startTime!).inMilliseconds / 1000.0;
            _isMeasuring = false;
          }
        } else if (_smoothedSpeed > _speedThreshold && _smoothedSpeed < 5.0) {
          _startTime = DateTime.now();
          _isMeasuring = true;
        }
      });
    });
  }

  void _startCompassUpdates() {
  _compassStreamSubscription = FlutterCompass.events!.listen((CompassEvent event) {      if (_mapReady) {
        setState(() {
          _mapHeading = event.heading ?? 0.0;
        });
        _mapController.rotate(_mapHeading);
      }
    });
  }

 double _calculateNetGForce() {
  // Adjust Z-axis by removing gravity and ensure the result can go negative
  double adjustedGForceZ = _isConnected ? _gForceZ - 9.8 : _gForceZ;

  // Avoid NaN by ensuring inputs are valid
  if (_gForceX.isNaN || _gForceY.isNaN || adjustedGForceZ.isNaN) {
    return 0.0; // Return 0 if any value is invalid
  }

  // Calculate the net G-force using the adjusted Z-axis
  return math.sqrt(
    math.pow(_gForceX, 2) + math.pow(_gForceY, 2) + math.pow(adjustedGForceZ, 2),
  ) *
      (adjustedGForceZ < 0 ? -1 : 1); // Preserve direction for braking (negative)
}

  // ---------------------------------------------------
  // DISPOSE
  // ---------------------------------------------------
  @override
  void dispose() {
    // Disconnect Bluetooth device
    _connectedDevice?.disconnect();

    // Cancel location updates
    _positionStreamSubscription?.cancel();

    // Cancel compass updates
    _compassStreamSubscription?.cancel();

    // Stop Bluetooth scan
    FlutterBluePlus.stopScan();

    // Dispose map controller
    _mapController.dispose();

    super.dispose();
  }

  // ---------------------------------------------------
  // WIDGETS (ACTUAL UI)
  // ---------------------------------------------------
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
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsScreen()));
            },
          ),
        ],
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                _buildTrackLogo(),
                const SizedBox(height: 10),
                _buildGauges(theme),
                const SizedBox(height: 10),
                _buildConnectionStatus(),
                const SizedBox(height: 10),
                _buildPitchRollIndicator(theme),
                const SizedBox(height: 10),
                Expanded(flex: 1, child: _buildStatsTable(theme)),
                Expanded(flex: 2, child: _buildOpenStreetMap()),
              ],
            ),
    );
  }

  // ---------------------------------------------------
  // FUNCTIONS FOR WIDGETS
  // ---------------------------------------------------
  Widget _buildTrackLogo() {
    return Image.asset(widget.trackLogoPath, height: 60, fit: BoxFit.contain);
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
          color: theme.colorScheme.tertiary,
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
          value: '${_calculateNetGForce().toStringAsFixed(2)} G', 
          label: 'Total G-Force', 
          color: theme.colorScheme.tertiary,
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
          height: 70,
          width: 70,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 4),
          ),
          child: Center(
            child: Text(value, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }

  Widget _buildConnectionStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('Bluetooth Status: ', style: const TextStyle(fontSize: 10),),
        Container(
          height: 10,
          width: 10,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _isConnected ? Colors.green : Colors.red,
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

  Widget _buildPitchRollIndicator(ThemeData theme) {
    const double maxOffset = 40.0; // Maximum offset for the ball
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            // Outer Circle
            ClipOval(
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.grey, width: 4),
                ),
              ),
            ),
            // Moving Ball
            Transform.translate(
              offset: Offset(
                (_roll.clamp(-1, 1) * maxOffset),
                (_pitch.clamp(-1, 1) * -maxOffset),
              ),
              child: Container(
                height: 20,
                width: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Text('Roll: ${_roll.toStringAsFixed(1)}°', style: theme.textTheme.bodySmall?.copyWith(fontSize: 10)),
            Text('Pitch: ${_pitch.toStringAsFixed(1)}°', style: theme.textTheme.bodySmall?.copyWith(fontSize: 10)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatsTable(ThemeData theme) {
    final stats = [
      {'Metric': '0-100 km/h', 'Value': _zeroToHundredTime > 0 ? '${_zeroToHundredTime.toStringAsFixed(2)} s' : 'N/A'},
      {'Metric': '100-0 km/h', 'Value': 'N/A'},
      {'Metric': '400m', 'Value': 'N/A'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Table(
        border: TableBorder.all(color: theme.colorScheme.primary, width: 1),
        children: stats.map((row) {
          return TableRow(
            children: [
              Padding(padding: const EdgeInsets.all(8.0), child: Text(row['Metric']!.toString(), style: theme.textTheme.bodyMedium)),
              Padding(padding: const EdgeInsets.all(8.0), child: Text(row['Value']!.toString(), style: theme.textTheme.bodyMedium)),
            ],
          );
        }).toList(),
      ),
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
            onMapReady: () {
              setState(() {
                _mapReady = true; // Mark the map as ready
              });
            },
            ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
              userAgentPackageName: 'com.example.trackapp',
            ),
            MarkerLayer(
              markers: [
                Marker(
                  point: _currentPosition!,
                  builder: (context) => const Icon(Icons.location_pin, size: 40, color: Colors.blue),
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
