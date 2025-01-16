import 'package:flutter/foundation.dart';

class TelemetryProvider with ChangeNotifier {
  // List to store telemetry data for the current session
  final List<Map<String, dynamic>> _telemetryData = [];

  // Getter to retrieve telemetry data
  List<Map<String, dynamic>> get telemetryData => List.unmodifiable(_telemetryData);

  // Add a telemetry entry
  void addTelemetry(Map<String, dynamic> entry) {
    _telemetryData.add(entry);
    notifyListeners(); // Notify listeners about the change
  }

  // Clear telemetry data (e.g., when the session ends)
  void clearTelemetry() {
    _telemetryData.clear();
    notifyListeners(); // Notify listeners about the change
  }
}
