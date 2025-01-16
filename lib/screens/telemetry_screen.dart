import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/telemetry_provider.dart';

class TelemetryScreen extends StatelessWidget {
  const TelemetryScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final telemetryProvider = Provider.of<TelemetryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Telemetry Data'),
      ),
      body: telemetryProvider.telemetryData.isEmpty
          ? const Center(child: Text('No telemetry data available.'))
          : ListView.builder(
              itemCount: telemetryProvider.telemetryData.length,
              itemBuilder: (context, index) {
                final entry = telemetryProvider.telemetryData[index];
                return ListTile(
                  title: Text('Time: ${entry['time']}'),
                  subtitle: Text(
                    'Speed: ${entry['speed']} km/h, Altitude: ${entry['altitude']} m\n'
                    'G-Force X: ${entry['g_force_x']}, Y: ${entry['g_force_y']}, Z: ${entry['g_force_z']}',
                  ),
                );
              },
            ),
    );
  }
}
