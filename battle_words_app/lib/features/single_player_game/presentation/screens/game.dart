import 'package:battle_words/common/widgets/page_layout.dart';
import 'package:battle_words/features/keyboard/presentation/keyboard.dart';
import 'package:battle_words/common/widgets/pause_button.dart';
import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:battle_words/common/controllers/show_pause.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/single_player_game.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/guess_input.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/keyboard_letters.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/game_board_view.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/game_result_notification.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/guess_input_display.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/word_status_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class SinglePlayerPage extends ConsumerWidget {
  const SinglePlayerPage({
    Key? key,
  }) : super(key: key);

  ///controls whether the pause menu is showing or not
  void toggleIsPauseMenuShowing(WidgetRef ref) {
    print("flipping pause menu");
    ref.read(isPauseMenuShowingProvider.notifier).update((state) => !state);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //watch and rebuild when state changes
    final gameState = ref.watch(singlePlayerGameControllerProvider);
    final keyboardLetterMap = ref.watch(keyboardLettersControllerProvider);
    bool _isPauseMenuShowing = ref.watch(isPauseMenuShowingProvider);

    //display loading here as well using async methods when required
    return PageLayout(
      menuPage: false,
      child: gameState.isLoading
          ? const CircularProgressIndicator()
          : gameState.hasError
              ? const Text("UH OH")
              : Stack(
                  //alignment: Alignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("Moves remaining: ${gameState.value!.movesRemaining}"),
                        GameBoardView(singlePlayerGame: gameState.value!),
                        WordStatusIndicatorRow(singlePlayerGame: gameState.value!),
                        GuessInputDisplay(),
                        Keyboard(
                            onBackspace: () {
                              ref.read(guessWordInputControllerProvider.notifier).backspace();
                            },
                            onGuess: () {
                              ref.read(guessWordInputControllerProvider.notifier).guess();
                            },
                            onTextInput: (text) {
                              ref.read(guessWordInputControllerProvider.notifier).tapTextKey(text);
                            },
                            letterMap: keyboardLetterMap),
                      ],
                    ),

                    /// displays end of game popup with return to main menu button
                    Positioned(
                      top: 30.h,
                      left: 25.w,
                      child: gameState.value!.gameResult == GameResult.loss
                          ? GameResultNotification(result: "Loser!")
                          : gameState.value!.gameResult == GameResult.win
                              ? GameResultNotification(result: "Winner!")
                              : Text(""),
                    ),

                    Positioned(
                      top: 2.h,
                      right: 5.w,
                      child: PauseButton(
                        updatePauseMenuVisibility: toggleIsPauseMenuShowing,
                        ref: ref,
                      ),
                    ),
                  ],
                ),
    );
  }
}
