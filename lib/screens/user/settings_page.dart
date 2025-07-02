import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/app_state.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final appState = Provider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24.0),
        children: [
          SwitchListTile(
            title: const Text('Enable Notifications'),
            value: appState.notificationsEnabled,
            onChanged: (val) {
              appState.notificationsEnabled = val;
            },
          ),
          SwitchListTile(
            title: const Text('Dark Mode'),
            value: appState.isDarkMode,
            onChanged: (val) {
              appState.isDarkMode = val;
            },
          ),
        ],
      ),
    );
  }
}
