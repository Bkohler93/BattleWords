import 'package:flutter/material.dart';

class MultiplayerHomePage extends StatefulWidget {
  const MultiplayerHomePage({super.key});

  @override
  State<MultiplayerHomePage> createState() => _MultiplayerHomePageState();
}

class _MultiplayerHomePageState extends State<MultiplayerHomePage> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: ElevatedButton(
          child: Icon(Icons.home),
          onPressed: () => Navigator.of(context).pop(),
        ),
        body: Container(
          child: Text(
            "Multiplayer Home Page",
          ),
        ),
      ),
    );
  }
}
