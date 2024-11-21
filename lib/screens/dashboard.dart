import 'package:flutter/material.dart';

class DashboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nordschleife BTG'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Zahnrad-Button Funktionalität hier einfügen
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildConnectionStatus(),
            SizedBox(height: 20),
            _buildLapInfo(),
            SizedBox(height: 20),
            _buildTimers(),
            SizedBox(height: 20),
            _buildGaugesRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        'CONNECTED!',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildLapInfo() {
    return Column(
      children: [
        Image.asset(
          'assets/nurburgring_logo.png', // Nürburgring-Logo einfügen
          height: 50,
        ),
        SizedBox(height: 8),
        Text(
          'Lap 3',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildTimers() {
    return Column(
      children: [
        Text(
          '01:23.592',
          style: TextStyle(
            fontSize: 48,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          'PREDICTED: 07:23.000',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
        SizedBox(height: 8),
        Text(
          '-0.592',
          style: TextStyle(
            fontSize: 24,
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildGaugesRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildGauge('10', 'OAT', Colors.blue),
        _buildGauge('Signal', 'STRENGTH', Colors.green),
        _buildGauge('0.0', 'G-FORCE', Colors.red),
        _buildGauge('-3%', 'SLOPE', Colors.orange),
      ],
    );
  }

  Widget _buildGauge(String value, String label, Color color) {
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
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ],
    );
  }
}
