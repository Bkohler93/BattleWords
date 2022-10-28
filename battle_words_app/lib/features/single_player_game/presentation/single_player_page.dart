import 'package:battle_words/features/keyboard/presentation/keyboard_glob.dart';
import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/game_state.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/guess_input.dart';
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //watch and rebuild when state changes
    final state = ref.watch(singlePlayerGameControllerProvider);

    //display loading here as well using async methods when required
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        body: state.isLoading
            ? const CircularProgressIndicator()
            : state.hasError
                ? const Text("UH OH")
                : Stack(
                    //alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Moves remaining: ${state.value!.movesRemaining}"),
                          Column(
                            children: [
                              GameBoardView(singlePlayerGame: state.value!),
                              WordStatusIndicatorRow(singlePlayerGame: state.value!),
                            ],
                          ),
                          Column(
                            children: [
                              GuessInputDisplay(),
                              CustomKeyboard(
                                onBackspace: () {
                                  print("hit backspace");
                                  ref.read(guessWordInputControllerProvider.notifier).backspace();
                                },
                                onGuess: () {
                                  print("hit guess");
                                  //! GuessWordInput widget method to guess the word
                                  //ref.read(guessWordInputControllerProvider).guess();
                                },
                                onTextInput: (text) {
                                  print("typed $text");
                                  ref
                                      .read(guessWordInputControllerProvider.notifier)
                                      .tapTextKey(text);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Positioned(
                        top: 30.h,
                        child: state.value!.gameResult == GameResult.loss
                            ? GameResultNotification(result: "Loser!")
                            : state.value!.gameResult == GameResult.win
                                ? GameResultNotification(result: "Winner!")
                                : Text(""),
                      )
                    ],
                  ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
