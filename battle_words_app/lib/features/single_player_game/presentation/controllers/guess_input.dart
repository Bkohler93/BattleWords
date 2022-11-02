import 'package:battle_words/features/single_player_game/presentation/controllers/single_player_game.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/keyboard_letters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuessInputState {
  GuessInputState({this.guessWord = "", this.isValidWord = true});
  String guessWord;
  bool isValidWord;
}

class GuessInputController extends StateNotifier<GuessInputState> {
  GuessInputController({required this.ref}) : super(GuessInputState(guessWord: ""));
  final ref;

  void backspace() {
    if (state.guessWord.isEmpty) {
      state = state;
    } else {
      state = GuessInputState(guessWord: state.guessWord.substring(0, state.guessWord.length - 1));
    }
  }

  void tapTextKey(String newChar) {
    state =
        state.guessWord.length > 5 ? state : GuessInputState(guessWord: state.guessWord + newChar);
  }

  void guess() {
    if (state.guessWord.isEmpty) return;

    //* uncovers all letters on keyboard, regardless of if they are on the board or not. Update this
    //* to update keys with green/yello/grey on if they are present or not on the board.
    //ref.read(keyboardLettersControllerProvider.notifier).uncoverLetters(state.guessWord);

    // send guess word to the single player game controller to handle game state.
    ref.read(singlePlayerGameControllerProvider.notifier).handleWordGuess(state.guessWord);
    state = GuessInputState(guessWord: "");
  }
}

final guessWordInputControllerProvider =
    StateNotifierProvider<GuessInputController, GuessInputState>((ref) {
  return GuessInputController(ref: ref);
});
