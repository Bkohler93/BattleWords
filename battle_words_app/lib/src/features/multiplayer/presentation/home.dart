import 'package:battle_words/src/common/widgets/page_layout.dart';
import 'package:battle_words/src/common/widgets/screen_route_link.dart';
import 'package:flutter/material.dart';

class MultiplayerHomeScreen extends StatefulWidget {
  const MultiplayerHomeScreen({super.key});

  @override
  State<MultiplayerHomeScreen> createState() => MultiplayerHomeScreenState();
}

class MultiplayerHomeScreenState extends State<MultiplayerHomeScreen> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return PageLayout(
      menuPage: true,
      child: Column(children: [
        Expanded(
          flex: 1,
          child: Container(color: colorScheme.background),
        ),
        Expanded(
          flex: 1,
          child: Container(color: colorScheme.background),
        ),
        Expanded(
          flex: 1,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              screenRoute('/multiplayer/profile', "Profile", context),
              screenRoute('/multiplayer/matchmaking', "Find Game", context),
              screenRoute('/', "Return to Home", context),
            ],
          ),
        ),
        Expanded(
          flex: 1,
          child: Container(color: colorScheme.background),
        ),
      ]),
    );
  }
}
