import 'package:http/http.dart' as http;
import 'dart:convert';

class NetworkService {
  final String baseUrl = "http://192.168.4.1"; // IP des TrackG-Geräts

  Future<Map<String, dynamic>?> fetchData() async {
    final url = Uri.parse("$baseUrl/data");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        print("Fehler beim Abrufen der Daten: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Verbindungsfehler: $e");
      return null;
    }
  }
}
