import 'package:flutter/material.dart';
import 'network_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NetworkService networkService = NetworkService();
  Map<String, dynamic>? data;

  void fetchData() async {
    final fetchedData = await networkService.fetchData();
    setState(() {
      data = fetchedData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("TrackG Home")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: fetchData,
              child: const Text("Daten abrufen"),
            ),
            const SizedBox(height: 20),
            data != null
                ? Text("Geschwindigkeit: ${data!['speed']}, G-Kräfte: ${data!['g_forces']}")
                : const Text("Keine Daten abgerufen"),
          ],
        ),
      ),
    );
  }
}
