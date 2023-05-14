import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rt_flutter/screens/settings_screen.dart';
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
  String _state = "";

  @override
  void initState() {
    super.initState();
    log("SplashScreen:initState");
    setState(() {
      _state = "Reading preferences";
    });
    Provider.of<AppState>(context, listen: false).addListener(_postPrefs);
  }

  void _postPrefs() async {
    log("SplashScreen:_postPrefs");
    AppState appState = Provider.of<AppState>(context, listen: false)
      ..removeListener(_postPrefs);

    setState(() {
      _state = "Setup services";
    });

    // Fetch URL or goto Settings
    String? url = appState.url;
    log("_postPrefs:url:$url");
    if (url == null || url.isEmpty) {
      if (!context.mounted) return;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SettingsScreen()));
      return;
    }
    APIService.instance.config.setUrl(url);

    // Fetch token or goto Login
    String? token = appState.token;
    log("_postPrefs:token:$token");
    if (token == null || token.isEmpty) {
      if (!context.mounted) return;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const SettingsScreen()));
      return;
    }
    APIService.instance.config.setAuthToken(token);

    setState(() {
      _state = "Checking connectivity";
    });

    try {
      await _testConnectivity();
      setState(() {
        _state = "Retrieving user data";
      });

      _fetchUserNameIfNecessary(appState);
      setState(() {
        _state = "Starting";
      });

      // ignore: use_build_context_synchronously
      if (!context.mounted) return;
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const TicketsScreen()));
    } catch (e) {
      // TODO: navigate to LoginScreen on connection failure is wrong
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    }
  }

  Future<void> _testConnectivity() async {
    log("_testConnectivity");

    var rt = await APIService.instance.fetchRTSystemInfo();
    if (!rt.isValidVersion()) {
      throw Exception('Unexpected RT version : ${rt.version}');
    }
  }

  Future<void> _fetchUserNameIfNecessary(AppState appState) async {
    if (appState.id == null || appState.id == "") {
      var user = await APIService.instance.fetchUser(appState.uid!);
      log("_fetchUserNameIfNecessary:${user.username}");
      appState.id = user.username;
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
          Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text(_state,
                  style: const TextStyle(
                      color: Colors.black,
                      fontSize: 11.0,
                      decoration: TextDecoration.none))),
        ],
      ),
    );
  }
}
