import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rt_flutter/screens/home_screen.dart';
import 'package:rt_flutter/services/api_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rt_flutter/models/appstate_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final WebViewController controller = WebViewController();

  @override
  void initState() {
    super.initState();
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel("TokenExtractor", onMessageReceived: (message) {
        String token = message.message;
        Provider.of<AppState>(context, listen: false).token = token;
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => HomeScreen()));
      })
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            controller.currentUrl().then((value) async {
              if (hasReachedTokensList(value)) {
                String owner = await getUserID(controller);
                PackageInfo packageInfo = await PackageInfo.fromPlatform();
                String description =
                    packageInfo.packageName + "_" + packageInfo.version;
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
    Uri? uri = APIService.instance.config!.uri;
    if (uri == null) {
      throw "Missing base uri";
    }

    uri.pathSegments.add("Prefs");
    uri.pathSegments.add("AuthTokens.html");

    return uri;
  }

  bool hasReachedTokensList(String? url) {
    return url == tokenListUrl();
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
        'fetch("${tokenListUrl()}", { method: "POST", body: new URLSearchParams($params) }).then((response) => { ' +
            'if (response.ok) { return response.text().then((text) => { ' +
            'window.TokenExtractor.postMessage(text.match("(\\\\d+-\\\\d+-\\\\w+)")[0]) }) }})');
  }
}
