import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rt_flutter/models/api_config_model.dart';
import 'package:rt_flutter/services/api_service.dart';
import 'package:rt_flutter/screens/tickets_screen.dart';
import 'package:rt_flutter/screens/login_screen.dart';
import 'package:rt_flutter/models/appstate_model.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    log("SplashScreen:initState");
    Provider.of<AppState>(context, listen: false).addListener(_initState);
  }

  void _initState() {
    Provider.of<AppState>(context, listen: false).removeListener(_initState);
    _initAPIConfig();
    _testConnectivity();
  }

  _initAPIConfig() {
    APIService.instance.config = APIConfig()
      ..setUrl('https://snps.univ-nantes.fr/rt');

    String? token = Provider.of<AppState>(context, listen: false).token;
    log("_initAPIConfig:$token");
    if (token != null && token.isNotEmpty) {
      log(token);
      APIService.instance.config?.setAuthToken(token);
    }
  }

  _testConnectivity() async {
    try {
      var rt = await APIService.instance.fetchRTSystemInfo();
      if (!rt.isValid()) {
        throw Exception('Unexpected RT version : ${rt.version}');
      }

      // ignore: use_build_context_synchronously
      if (!context.mounted) return;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const TicketsScreen()));
    } catch (e) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text('R|T',
                  style: TextStyle(
                      color: Theme.of(context).colorScheme.secondary,
                      decoration: TextDecoration.none))),
          const CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.redAccent),
          ),
        ],
      ),
    );
  }
}
