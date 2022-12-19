import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/common/widgets/page_layout.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/game/game.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/score/interface.dart';
import 'package:battle_words/src/features/single_player_game/presentation/controllers/pause_menu/pause_menu_cubit.dart';
import 'package:battle_words/src/features/single_player_game/presentation/controllers/score/score_cubit.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/pause_button.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/game/interface.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/game_board_view.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/game_result_notification.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/guess_input_display.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/moves_remaining_display.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/pause_menu.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/word_status_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SinglePlayerPage extends StatefulWidget {
  const SinglePlayerPage({super.key});

  @override
  State<SinglePlayerPage> createState() => _SinglePlayerPageState();
}

class _SinglePlayerPageState extends State<SinglePlayerPage> {
  void resetGame() {
    print("resetting game");
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ISinglePlayerRepository>(
          // lazy: false,
          //Isolate is created when SinglePlayerIsolateRepository is created
          create: (context) => SinglePlayerWatchRepository(
              store: RepositoryProvider.of<ObjectBoxStore>(context),
              storeReference: RepositoryProvider.of<ObjectBoxStore>(context).reference),
        ),
        RepositoryProvider(
          create: (context) => SinglePlayerScoreObjectBoxRepository(
              storeReference: RepositoryProvider.of<ObjectBoxStore>(context).reference),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SinglePlayerBloc>(
            create: (context) => SinglePlayerBloc(
              repository: RepositoryProvider.of<ISinglePlayerRepository>(context),
            )..add(StartGameEvent()),
          ),
          BlocProvider(
            create: (context) => PauseMenuCubit(),
          ),
          BlocProvider(
            create: (context) => SinglePlayerScoreCubit(
              repository: RepositoryProvider.of<SinglePlayerScoreObjectBoxRepository>(context),
            ),
          ),
        ],
        child: SinglePlayerView(
          resetGame: resetGame,
        ),
      ),
    );
  }
}

class SinglePlayerView extends StatelessWidget {
  const SinglePlayerView({Key? key, required this.resetGame}) : super(key: key);
  final VoidCallback resetGame;

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      menuPage: false,
      child: BlocSelector<SinglePlayerBloc, SinglePlayerState, GameStatus>(
        selector: ((state) => state.gameStatus),
        builder: (context, state) {
          if (state.isLoading) {
            return const CircularProgressIndicator();
          } else {
            return Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: const [
                    MovesRemaining(),
                    GameBoardView(),
                    WordStatusIndicatorRow(),
                    GuessInputDisplay(),
                  ],
                ),
                Positioned(
                    child: Align(
                  alignment: Alignment.center,
                  child: (state.isWin || state.isLoss)
                      ? GameResultNotification(
                          result: state,
                        )
                      : const Text(""),
                )),
                Positioned(
                  // top: 2.h,
                  // right: 5.w,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0),
                      child: BlocBuilder<PauseMenuCubit, bool>(
                        builder: ((context, state) {
                          return PauseButton(
                            showOrHidePauseMenu:
                                BlocProvider.of<PauseMenuCubit>(context).showOrHidePauseMenu,
                            isPauseMenuShowing: state,
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  // top: 15.h,
                  child: Align(
                    alignment: Alignment.center,
                    child: BlocBuilder<PauseMenuCubit, bool>(
                      builder: (context, state) {
                        return SinglePlayerPauseMenu(
                          isPauseMenuShowing: state,
                          showOrHidePauseMenu:
                              BlocProvider.of<PauseMenuCubit>(context).showOrHidePauseMenu,
                          resetGame: resetGame,
                        );
                      },
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
