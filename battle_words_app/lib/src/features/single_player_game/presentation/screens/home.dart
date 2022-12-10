import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/api/shared_preferences/cubit/settings_cubit.dart';
import 'package:battle_words/src/common/widgets/page_layout.dart';
import 'package:battle_words/src/common/widgets/screen_route_link.dart';
import 'package:battle_words/src/features/home_screen/presentation/home.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/score/interface.dart';
import 'package:battle_words/src/features/single_player_game/presentation/controllers/score/score_cubit.dart';
import 'package:battle_words/src/features/single_player_game/presentation/screens/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class SinglePlayerHomePage extends StatelessWidget {
  const SinglePlayerHomePage({super.key});
  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      lazy: false,
      create: (context) => SinglePlayerScoreObjectBoxRepository(
          storeReference: RepositoryProvider.of<ObjectBoxStore>(context).reference),
      child: BlocProvider<SinglePlayerScoreCubit>(
          create: ((context) => SinglePlayerScoreCubit(
                repository: RepositoryProvider.of<SinglePlayerScoreObjectBoxRepository>(context),
              )),
          child: SinglePlayerHomeView()),
    );
  }
}

class SinglePlayerHomeView extends StatefulWidget {
  const SinglePlayerHomeView({super.key});

  @override
  State<SinglePlayerHomeView> createState() => SinglePlayerHomeViewState();
}

class SinglePlayerHomeViewState extends State<SinglePlayerHomeView> {
  @override
  Widget build(BuildContext context) {
    //lazy  load is active so repository and bloc will not be loaded until SinglePlayerGame page initializes
    return BlocSelector<SettingsCubit, SettingsState, bool>(
      selector: (state) {
        return state.isFirstLaunch;
      },
      builder: (context, state) {
        if (state) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) {
                return Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: 200,
                          child: Text("Tutorial goes here"),
                        ),
                        TextButton(
                          child: Text('dismiss'),
                          onPressed: () {
                            BlocProvider.of<SettingsCubit>(context)
                                .updateSettings(isFirstLaunch: false);
                            SchedulerBinding.instance.addPostFrameCallback((_) {
                              Navigator.pop(context);
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          });
        }
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
                              children: [
                                const Text("Games Won"),
                                BlocSelector<SinglePlayerScoreCubit, SinglePlayerScoreState, int>(
                                  selector: (state) => state.totalGamesWon,
                                  builder: (context, state) {
                                    return Text("$state");
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("High Score"),
                                BlocSelector<SinglePlayerScoreCubit, SinglePlayerScoreState, int>(
                                  selector: (state) => state.highestWinStreak,
                                  builder: (context, state) {
                                    return Text("$state");
                                  },
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text("Current Streak"),
                                BlocSelector<SinglePlayerScoreCubit, SinglePlayerScoreState, int>(
                                  selector: (state) => state.currentWinStreak,
                                  builder: (context, state) {
                                    return Text("$state");
                                  },
                                ),
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
                      onReturn: BlocProvider.of<SinglePlayerScoreCubit>(context).reloadScoreData,
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
      },
    );
  }
}
