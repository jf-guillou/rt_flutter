import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:rt_flutter/components/textfield_popup.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:provider/provider.dart';
import 'package:rt_flutter/services/api_service.dart';
import 'package:rt_flutter/models/appstate_model.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    log("SettingsScreen:initState");
  }

  @override
  Widget build(BuildContext context) {
    AppState appState = Provider.of<AppState>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      // We're using a Builder here so we have a context that is below the Scaffold
      // to allow calling Scaffold.of(context) so we can show a snackbar.
      body: SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Common'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                  leading: const Icon(Icons.language),
                  title: const Text('Request Tracker url'),
                  value: Text(appState.url ?? "not set"),
                  onPressed: (context) => {
                        showDialog(
                            context: context,
                            builder: (context) => TextFieldPopup(
                                    "Request Tracker url",
                                    "https://example.com/rt",
                                    appState.url ?? "", (String value) async {
                                  if (!_urlValidator(value)) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Malformed url'),
                                      ),
                                    );
                                    return;
                                  }
                                  APIService.instance.config.setUrl(value);
                                  bool success =
                                      await APIService.instance.ping();
                                  if (!success) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text('Cannot reach url'),
                                      ),
                                    );
                                    return;
                                  }
                                  appState.url = value;
                                  setState(() => {});
                                })),
                      }),
            ],
          ),
        ],
      ),
    );
  }

  bool _urlValidator(String? url) {
    if (url == null) return false;
    Uri? uri = Uri.tryParse(url);
    return uri != null &&
        uri.isScheme("HTTPS") &&
        uri.isAbsolute &&
        uri.host.isNotEmpty &&
        !uri.path.endsWith('/');
  }
}
