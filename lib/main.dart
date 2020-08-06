import 'package:rt_flutter/screens/home_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(RT());
}

class RT extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Request Tracker Flutter client',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomeScreen(title: 'RT'),
    );
  }
}
