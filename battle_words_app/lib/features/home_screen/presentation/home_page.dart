import 'package:battle_words/common/widgets/page_layout.dart';
import 'package:battle_words/common/widgets/screen_route_link.dart';
import 'package:battle_words/features/home_screen/presentation/controller.dart';
import 'package:battle_words/features/multiplayer/presentation/multiplayer_home_page.dart';
import 'package:battle_words/features/single_player_game/presentation/screens/single_player_home_page.dart';
import 'package:battle_words/features/user_settings/presentation/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homePageControllerProvider);
    return PageLayout(
      menuPage: true,
      child: state.isLoading
          ? const Text("Loading")
          : Column(
              children: <Widget>[
                Expanded(
                  flex: 2,
                  child: Container(),
                ),
                Expanded(
                  flex: 1,
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
                  flex: 1,
                  child: Container(
                    color: Colors.white,
                  ),
                )
              ],
            ),
    );
  }
}
