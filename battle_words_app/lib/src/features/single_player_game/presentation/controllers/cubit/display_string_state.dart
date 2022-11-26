part of 'display_string_cubit.dart';

//* 5 States, also need access to these fields: String displayString, GuessInputState displayState

//* 1 - Normal State: regular black text, will be the state as new characters are added/removed
//* 2 - Abnormal State: regular black text, shake at start, notify that word is too short/long/nonexistent
//* 3 - Invalid State: red text, word is not real
//* 4 - Previously Guessed State: yellow-similar text, already guessed (FUNCTIONALITY NOT IMPLEMENTED)
//* 5 - Guessing State: maybe animate the text away, this means the guessed word has been sent to the GameManager to create the next game state.

enum DisplayStringStatus { normal, incorrectLength, invalid, previouslyGuessed, guessing }

extension DisplayStringStatusX on DisplayStringStatus {
  bool get isNormal => this == DisplayStringStatus.normal;
  bool get isIncorrectLength => this == DisplayStringStatus.incorrectLength;
  bool get isInvalid => this == DisplayStringStatus.invalid;
  bool get isPreviouslyGuessed => this == DisplayStringStatus.previouslyGuessed;
  bool get isGuessing => this == DisplayStringStatus.guessing;
}

class DisplayStringState extends Equatable {
  const DisplayStringState({
    required this.displayString,
    this.displayStringStatus = DisplayStringStatus.normal,
  });
  final String displayString;
  final DisplayStringStatus displayStringStatus;

  @override
  List<Object> get props => [
        displayString,
      ];

  DisplayStringState copyWith({String? string, DisplayStringStatus? status}) {
    return DisplayStringState(
      displayString: string ?? displayString,
      displayStringStatus: status ?? displayStringStatus,
    );
  }
}
