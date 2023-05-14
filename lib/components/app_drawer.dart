import 'package:flutter/material.dart';
import 'package:rt_flutter/screens/settings_screen.dart';
import 'package:rt_flutter/screens/tickets_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.background,
            ),
            child: Column(children: [
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('R|T',
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.secondary,
                          fontSize: 42.0,
                          decoration: TextDecoration.none)))
            ]),
          ),
          ListTile(
            title: const Text('Tickets'),
            leading: const Icon(Icons.list),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const TicketsScreen()));
            },
          ),
          ListTile(
            title: const Text('Settings'),
            leading: const Icon(Icons.settings),
            onTap: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                  builder: (context) => const SettingsScreen()));
            },
          ),
        ],
      ),
    );
  }
}
