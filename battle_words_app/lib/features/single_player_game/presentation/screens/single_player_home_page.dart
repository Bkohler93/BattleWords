import 'package:battle_words/common/widgets/page_layout.dart';
import 'package:battle_words/common/widgets/screen_route_link.dart';
import 'package:battle_words/features/home_screen/presentation/home_page.dart';
import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:battle_words/features/single_player_game/presentation/screens/single_player_page.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SinglePlayerHomePage extends StatefulWidget {
  const SinglePlayerHomePage({super.key});

  @override
  State<SinglePlayerHomePage> createState() => SinglePlayerHomePageState();
}

class SinglePlayerHomePageState extends State<SinglePlayerHomePage> {
  @override
  Widget build(BuildContext context) {
    return PageLayout(
      menuPage: true,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              alignment: Alignment.bottomLeft,
              child: const Text(
                "Single Player",
                style: TextStyle(
                  fontSize: 30.0,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Games Won"),
                            Text("32"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("High Score"),
                            Text("7"),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text("Current Streak"),
                            Text("3"),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                const Expanded(
                  flex: 1,
                  child: SizedBox(),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(),
                screenRoute(
                  SinglePlayerPage(),
                  "Play",
                  context,
                ),
                screenRoute(
                  HomePage(),
                  "Back to Home",
                  context,
                ),
              ],
            )),
          ),
          Expanded(
            flex: 1,
            child: Container(),
          ),
        ]),
      ),
    );
  }
}
