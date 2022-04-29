import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rt_flutter/services/api_service.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rt_flutter/models/appstate_model.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
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
        return WebView(
          initialUrl: tokenListUrl(),
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.complete(webViewController);
          },
          javascriptChannels: [
            JavascriptChannel(
                name: 'TokenExtractor',
                onMessageReceived: (message) {
                  String token = message.message;
                  print(token);
                  Provider.of<AppState>(context, listen: false).token = token;
                })
          ].toSet(),
          onProgress: (int progress) {
            print("WebView is loading (progress : $progress%)");
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
            _controller.future.then(
                (controller) => controller.currentUrl().then((value) async {
                      if (hasReachedTokensList(value)) {
                        String owner = await getUserID(controller);
                        PackageInfo packageInfo =
                            await PackageInfo.fromPlatform();
                        String description =
                            packageInfo.packageName + "_" + packageInfo.version;
                        generateToken(controller, owner, description);
                      }
                    }));
          },
          gestureNavigationEnabled: true,
        );
      }),
    );
  }

  String tokenListUrl() {
    return APIService.instance.config!.uri.toString() +
        '/Prefs/AuthTokens.html';
  }

  bool hasReachedTokensList(String? url) {
    return url == tokenListUrl();
  }

  Future<String> getUserID(WebViewController controller) async {
    return controller.runJavascriptReturningResult('RT.CurrentUser.id');
  }

  void generateToken(
      WebViewController controller, String ownerID, String description) {
    String params = jsonEncode(
        {"Owner": ownerID, "Description": description, "Create": true});
    controller.runJavascript(
        'fetch("${tokenListUrl()}", { method: "POST", body: new URLSearchParams($params) }).then((response) => { ' +
            'if (response.ok) { return response.text().then((text) => { ' +
            'window.TokenExtractor.postMessage(text.match("(\\\\d+-\\\\d+-\\\\w+)")[0]) }) }})');
  }
}
