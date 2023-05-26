import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: ElevatedButton(
          child: const Icon(Icons.home),
          onPressed: () => Navigator.of(context).pop(),
        ),
        body: const Text(
          "Settings Page",
        ),
      ),
    );
  }
}
