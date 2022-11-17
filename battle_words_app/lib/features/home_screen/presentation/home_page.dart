import 'package:battle_words/features/home_screen/presentation/controller.dart';
import 'package:battle_words/features/multiplayer/presentation/multiplayer_home_page.dart';
import 'package:battle_words/features/single_player_game/presentation/single_player_home_page.dart';
import 'package:battle_words/features/single_player_game/presentation/single_player_page.dart';
import 'package:battle_words/features/user_settings/presentation/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  TextStyle _defaultMenuTextStyle() => const TextStyle(
        fontSize: 20,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.none,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      );

  Widget _homeScreenRoute(Widget screen, String screenName, BuildContext context) =>
      GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => screen,
          ),
        ),
        child: Container(
          width: double.infinity,
          child: Text(
            screenName,
            textAlign: TextAlign.start,
            style: _defaultMenuTextStyle(),
          ),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homePageControllerProvider);
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: state.isLoading
              ? const Text("Loading")
              : Padding(
                  padding: SizerUtil.deviceType == DeviceType.mobile
                      ? const EdgeInsets.all(14.0)
                      : const EdgeInsets.all(22.0),
                  child: Column(
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
                              _homeScreenRoute(SinglePlayerHomePage(), "Single Player", context),
                              _homeScreenRoute(MultiplayerHomePage(), "Multiplayer", context),
                              _homeScreenRoute(SettingsPage(), "Settings", context),
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
                ),
        ),
      ),
    );
  }
}
