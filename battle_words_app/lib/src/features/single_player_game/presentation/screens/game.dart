import 'dart:isolate';

import 'package:battle_words/src/common/widgets/page_layout.dart';
import 'package:battle_words/src/common/widgets/pause_button.dart';
import 'package:battle_words/src/common/controllers/show_pause.dart';
import 'package:battle_words/src/common/widgets/keyboard/domain/letter.dart';
import 'package:battle_words/src/common/widgets/keyboard/presentation/keyboard.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/game/interface.dart';
import 'package:battle_words/src/features/single_player_game/data/sources/isolate/run_app.dart';
import 'package:battle_words/src/features/single_player_game/domain/game.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/game_board_view.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/game_result_notification.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/guess_input_display.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/pause_menu.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/word_status_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SinglePlayerPage extends StatefulWidget {
  const SinglePlayerPage({super.key});

  @override
  State<SinglePlayerPage> createState() => _SinglePlayerPageState();
}

class _SinglePlayerPageState extends State<SinglePlayerPage> {
  final ReceivePort fromGameManagerPort = ReceivePort();
  late final Isolate gameManager;

  bool _isGameManagerSpawned = false;

  void _spawnIsolate() async {
    final gameManagerSendPorts = {
      'repository': fromGameManagerPort.sendPort,
    };
    gameManager = await Isolate.spawn(runSinglePlayerGameManager, gameManagerSendPorts);

    setState(() {
      _isGameManagerSpawned = true;
    });
  }

  @override
  void initState() {
    super.initState();
    _spawnIsolate();
  }

  @override
  void dispose() {
    gameManager.kill();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isGameManagerSpawned
        ? RepositoryProvider<ISinglePlayerRepository>(
            lazy: false,
            create: (context) =>
                SinglePlayerIsolateRepository(fromGameManagerPort: fromGameManagerPort),
            child: BlocProvider<SinglePlayerBloc>(
              lazy: false,
              create: (context) => SinglePlayerBloc(
                repository: RepositoryProvider.of<ISinglePlayerRepository>(context),
              ),
              child: SinglePlayerView(),
            ),
          )
        : CircularProgressIndicator();
  }
}

class SinglePlayerView extends StatefulWidget {
  const SinglePlayerView({
    Key? key,
  }) : super(key: key);

  @override
  State<SinglePlayerView> createState() => _SinglePlayerViewState();
}

class _SinglePlayerViewState extends State<SinglePlayerView> {
  ///controls whether the pause menu is showing or not
  void toggleIsPauseMenuShowing(WidgetRef ref) {
    print("flipping pause menu");
    ref.read(isPauseMenuShowingProvider.notifier).update((state) => !state);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PageLayout(
      menuPage: false,
      child: BlocSelector<SinglePlayerBloc, SinglePlayerState, GameStatus>(
        selector: ((state) => state.gameStatus),
        builder: (context, state) {
          // BlocProvider.of<SinglePlayerBloc>(context).add(StartGameEvent());
          if (state.isLoading) {
            return CircularProgressIndicator();
          } else {
            return Stack(
              alignment: Alignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text("Moves remaining: ${/*movesRemaining*/ 0}"),
                    GameBoardView(),
                    WordStatusIndicatorRow(),
                    GuessInputDisplay(),
                  ],
                ),
                Positioned(
                  child: Align(
                      alignment: Alignment.center,
                      child: BlocListener<SinglePlayerBloc, SinglePlayerState>(
                          listener: (context, state) => {
                                if (state.gameStatus == GameStatus.win ||
                                    state.gameStatus == GameStatus.loss)
                                  {
                                    GameResultNotification(
                                      result: state.gameStatus,
                                      hiddenWords: state.hiddenWords,
                                    )
                                  }
                              },
                          child: Container())),
                ),
                Positioned(
                  // top: 2.h,
                  // right: 5.w,
                  child: Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(0.0, 10.0, 10.0, 0),
                      child: PauseButton(
                        updatePauseMenuVisibility: toggleIsPauseMenuShowing,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  // top: 15.h,
                  child: Align(
                    alignment: Alignment.center,
                    child: SinglePlayerPauseMenu(
                      isPauseMenuShowing: false,
                      closePauseMenu: toggleIsPauseMenuShowing,
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
