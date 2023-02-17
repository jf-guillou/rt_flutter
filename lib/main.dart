import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rt_flutter/models/appstate_model.dart';
import 'package:rt_flutter/screens/splash_screen.dart';

void main() {
  runApp(ChangeNotifierProvider(
      create: (context) => AppState(), child: const RT()));
}

class RT extends StatelessWidget {
  const RT({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Request Tracker Flutter client',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}
