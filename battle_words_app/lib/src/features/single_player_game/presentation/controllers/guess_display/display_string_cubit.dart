import 'dart:async';

import 'package:battle_words/src/features/single_player_game/data/repositories/hidden_words/interface.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'display_string_state.dart';

class DisplayStringCubit extends Cubit<DisplayStringState> {
  DisplayStringCubit({required this.repository})
      : super(const DisplayStringState(displayString: ""));
  final HiddenWordsRepository repository;

  FutureOr<void> init() async {
    emit(state.copyWith(displayStringStatus: DisplayStringStatus.loading));
    await repository.init();
    emit(state.copyWith(displayStringStatus: DisplayStringStatus.normal));
  }

  void handleTapBackspace() {
    if (state.displayString.isEmpty) {
      emit(state);
      return;
    }

    final string = state.displayString.substring(0, state.displayString.length - 1);
    emit(
      state.copyWith(
        displayString: string,
        displayStringStatus: DisplayStringStatus.normal,
      ),
    );
  }

  void handleTextInput(String input) {
    emit(
      state.copyWith(
        displayString: state.displayString + input,
        displayStringStatus: DisplayStringStatus.normal,
      ),
    );
  }

  void handleTapGuess() {
    if (state.displayString.length > 5 || state.displayString.length < 3) {
      emit(
        state.copyWith(
          displayStringStatus: DisplayStringStatus.incorrectLength,
        ),
      );
      return;
    }

    if (repository.checkIfValidWord(state.displayString)) {
      emit(
        state.copyWith(
          displayStringStatus: DisplayStringStatus.guessing,
        ),
      );
      return;
    } else {
      emit(
        state.copyWith(
          displayStringStatus: DisplayStringStatus.invalid,
        ),
      );
      return;
    }
  }

  void resetDisplay() {
    emit(
      state.copyWith(
        displayString: "",
        displayStringStatus: DisplayStringStatus.normal,
      ),
    );
  }
}
