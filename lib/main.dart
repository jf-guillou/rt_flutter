import 'package:flutter/material.dart';
import 'package:rt_flutter/screens/splash_screen.dart';

void main() {
  runApp(RT());
}

class RT extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Request Tracker Flutter client',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
    );
  }
}
