import 'package:battle_words/features/single_player_game/presentation/controllers/game_state.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/keyboard_letters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuessInputController extends StateNotifier<String> {
  GuessInputController({required this.ref}) : super("");
  final ref;

  void backspace() {
    if (state.length == 0) {
      state = state;
    } else {
      state = state.substring(0, state.length - 1);
    }
  }

  void tapTextKey(String newChar) {
    state = state + newChar;
  }

  void guess() {
    //  1.  check if any letters are entered, if not return
    if (state.isEmpty) return;
    //  2.  check if the word is a real word (use outside to handle this), display error message that word is not real if so
    //! delete below, only to show that keyboard letters can change colors
    ref.read(keyboardLettersControllerProvider.notifier).uncoverLetters(state);
    //  3.  send the guess to the singlePlayerController to process the guess
    ref.read(singlePlayerGameControllerProvider.notifier).handleWordGuess(state);
    //  4.  Find any letters in the correct position and uncover them on the keyboard
    state = "";
  }
}

final guessWordInputControllerProvider = StateNotifierProvider<GuessInputController, String>((ref) {
  return GuessInputController(ref: ref);
});
