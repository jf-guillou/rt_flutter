import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rt_flutter/screens/tickets_screen.dart';
import 'package:rt_flutter/services/api_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rt_flutter/models/appstate_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final WebViewController controller = WebViewController();

  @override
  void initState() {
    super.initState();
    log("LoginScreen:initState");
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel("TokenExtractor", onMessageReceived: (message) {
        log('TokenExtractor');
        String token = message.message;
        Provider.of<AppState>(context, listen: false).token = token;
        APIService.instance.config.setAuthToken(token);
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const TicketsScreen()));
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            log('Page started loading: $url');
          },
          onPageFinished: (String url) {
            log('Page finished loading: $url');
            controller.currentUrl().then((value) async {
              log('Current url: $value');
              if (hasReachedTokensList(value)) {
                String owner = await getUserID(controller);
                PackageInfo packageInfo = await PackageInfo.fromPlatform();
                String description =
                    "${packageInfo.packageName}_${packageInfo.version}";
                generateToken(controller, owner, description);
              }
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(tokenListUrl());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: Builder(builder: (BuildContext context) {
        return WebViewWidget(controller: controller);
      }),
    );
  }

  Uri tokenListUrl() {
    Uri? uri = APIService.instance.config.uri;
    if (uri == null) {
      throw "Missing base uri";
    }

    return Uri.https(uri.host, '${uri.path}/Prefs/AuthTokens.html');
  }

  bool hasReachedTokensList(String? url) {
    return url == tokenListUrl().toString();
  }

  Future<String> getUserID(WebViewController controller) async {
    return controller
        .runJavaScriptReturningResult('RT.CurrentUser.id')
        .then((value) => value.toString());
  }

  void generateToken(
      WebViewController controller, String ownerID, String description) {
    String params = jsonEncode(
        {"Owner": ownerID, "Description": description, "Create": true});
    controller.runJavaScript(
        'fetch("${tokenListUrl()}", { method: "POST", body: new URLSearchParams($params) }).then((response) => { if (response.ok) { return response.text().then((text) => { window.TokenExtractor.postMessage(text.match("(\\\\d+-\\\\d+-\\\\w+)")[0]) }) }})');
  }
}
