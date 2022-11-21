import 'package:battle_words/features/single_player_game/data/repositories/hidden_words.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/single_player_game.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/keyboard_letters.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum GuessWordStatus { invalidWord, shortWord, longWord, validWord, noWord }

class GuessInputState {
  GuessInputState({this.guessWord = "", this.status = GuessWordStatus.validWord});
  String guessWord;
  GuessWordStatus status;
}

class GuessInputController extends StateNotifier<GuessInputState> {
  GuessInputController({required this.ref, required this.hiddenWordsRepository})
      : super(GuessInputState(guessWord: ""));
  final ref;
  final IHiddenWordsRepository hiddenWordsRepository;

  void handleBackspaceTap() {
    if (state.guessWord.isEmpty) {
      state = state;
    } else {
      state = GuessInputState(guessWord: state.guessWord.substring(0, state.guessWord.length - 1));
    }
  }

  void handleKeyTap(String newChar) {
    state =
        state.guessWord.length > 5 ? state : GuessInputState(guessWord: state.guessWord + newChar);
  }

  void handleGuessTap() {
    if (state.guessWord.isEmpty) {
      state = GuessInputState(guessWord: "", status: GuessWordStatus.noWord);
      return;
    }
    if (state.guessWord.length > 5) {
      state = GuessInputState(guessWord: state.guessWord, status: GuessWordStatus.longWord);
      return;
    }

    if (state.guessWord.length < 3) {
      state = GuessInputState(guessWord: state.guessWord, status: GuessWordStatus.shortWord);
      return;
    }

    // Looks up [state.guessWord] in the database.
    // If word is found in database, status = [GuessWordStatus.validWord], otherwise [GuessWordStatus.invalidWord]
    final GuessWordStatus status = hiddenWordsRepository.checkIfValidWord(state.guessWord)
        ? GuessWordStatus.validWord
        : GuessWordStatus.invalidWord;

    if (status == GuessWordStatus.validWord) {
      ref.read(singlePlayerGameControllerProvider.notifier).handleWordGuess(state.guessWord);
      state = GuessInputState(guessWord: "", status: status);
      return;
    }
    // invalid word
    else {
      state = GuessInputState(guessWord: state.guessWord, status: status);
    }
  }
}

final guessWordInputControllerProvider =
    StateNotifierProvider<GuessInputController, GuessInputState>((ref) {
  return GuessInputController(
      ref: ref, hiddenWordsRepository: ref.watch(hiddenWordsRepositoryProvider));
});
