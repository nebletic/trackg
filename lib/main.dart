import 'package:flutter/material.dart';
import 'screens/dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TrackG',
      theme: ThemeData.dark(), // Dunkles Thema für den Stil
      home: DashboardScreen(), // Hier die neue Seite einfügen
    );
  }
}
