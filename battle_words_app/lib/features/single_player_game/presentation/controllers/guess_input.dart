import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuessInputController extends StateNotifier<String> {
  GuessInputController() : super("");

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
    throw UnimplementedError("Need to hook up outside Dictionary API to check if real world");

    //TODO
    //  1.  check if any letters are entered, if not return
    //  2.  check if the word is a real word (use outside to handle this), display error message that word is not real if so
    //  3.  Find any exact matches of word on board, uncover that word, update key letters
    //  4.  Find any letters in the correct position and uncover them on the keyboard
  }
}

final guessWordInputControllerProvider = StateNotifierProvider<GuessInputController, String>((ref) {
  return GuessInputController();
});
