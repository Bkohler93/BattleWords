import 'package:battle_words/src/common/widgets/page_layout.dart';
import 'package:flutter/material.dart';

class MultiplayerProfileScreen extends StatelessWidget {
  const MultiplayerProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //TODO whole screen
    return const ScreenLayout(
      menuPage: true,
      child: Center(child: Text("Profile Page")),
    );
  }
}
