import 'package:flutter/material.dart';
import 'home_screen.dart'; // Importiere dein HomeScreen-Widget

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackG App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(), // Hier sollte dein HomeScreen geladen werden
    );
  }
}
