import 'package:battle_words/src/features/single_player_game/data/repositories/hidden_words.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'display_string_state.dart';

class DisplayStringCubit extends Cubit<DisplayStringState> {
  DisplayStringCubit({required this.repository})
      : super(const DisplayStringState(displayString: ""));
  final HiddenWordsRepository repository;

  void handleTapBackspace() {
    final string = state.displayString.substring(0, state.displayString.length - 1);
    emit(state.copyWith(string: string));
  }

  void handleTextInput(String input) {
    emit(state.copyWith(string: state.displayString + input));
  }

  void handleTapGuess() {
    if (state.displayString.length > 5 || state.displayString.length < 3) {
      emit(state.copyWith(status: DisplayStringStatus.incorrectLength));
      return;
    }

    if (repository.checkIfValidWord(state.displayString)) {
      emit(state.copyWith(status: DisplayStringStatus.guessing));
    }
  }
}
