import 'package:battle_words/common/widgets/page_layout.dart';
import 'package:battle_words/common/widgets/screen_route_link.dart';
import 'package:battle_words/features/home_screen/presentation/controller.dart';
import 'package:battle_words/features/multiplayer/presentation/home.dart';
import 'package:battle_words/features/single_player_game/presentation/screens/home.dart';
import 'package:battle_words/features/user_settings/presentation/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    //TODO HomePageState for determining if loadaing or not .. needed .. ? idk
    // final state = ref.watch(homePageControllerProvider);
    return PageLayout(
      menuPage: true,
      child: Column(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(),
          ),
          Expanded(
            flex: 0,
            child: Container(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  screenRoute(SinglePlayerHomePage(), "Single Player", context),
                  screenRoute(MultiplayerHomePage(), "Multiplayer", context),
                  screenRoute(SettingsPage(), "Settings", context),
                ],
              ),
            ),
          ),
          Expanded(
            flex: 0,
            child: Container(
              color: Colors.white,
            ),
          )
        ],
      ),
    );
  }
}
