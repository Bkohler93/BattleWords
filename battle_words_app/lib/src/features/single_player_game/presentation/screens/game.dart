import 'package:battle_words/src/common/widgets/page_layout.dart';
import 'package:battle_words/src/common/widgets/pause_button.dart';
import 'package:battle_words/src/common/controllers/show_pause.dart';
import 'package:battle_words/src/common/widgets/keyboard/domain/letter.dart';
import 'package:battle_words/src/common/widgets/keyboard/presentation/keyboard.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/game.dart';
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

class SinglePlayerPage extends StatelessWidget {
  const SinglePlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SinglePlayerRepository(),
      child: BlocProvider<SinglePlayerBloc>(
        lazy: false,
        create: (context) => SinglePlayerBloc(
          repository: RepositoryProvider.of<SinglePlayerRepository>(context),
        ),
        child: SinglePlayerView(),
      ),
    );
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
          if (state.isInitial) {
            BlocProvider.of<SinglePlayerBloc>(context).add(StartGameEvent());
            return CircularProgressIndicator();
          } else if (state.isLoading) {
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
                    //TODO Move keyboard into GuessInputDisplay
                    GuessInputDisplay(),

                    //TODO END HERE
                  ],
                ),

                /// displays end of game popup with return to main menu button
                //TODO This is where the GameResultNotification is shown or not. It is janky, mayberedesign
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
                          child: Container())

                      //*gameState.value!.gameResult == GameResult.loss
                      // ? GameResultNotification(
                      //     result: "Loser!", hiddenWords: gameState.value!.hiddenWords)
                      // : gameState.value!.gameResult == GameResult.win
                      //     ? GameResultNotification(
                      //         result: "Winner!", hiddenWords: gameState.value!.hiddenWords)
                      //Text(""),
                      ),
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
