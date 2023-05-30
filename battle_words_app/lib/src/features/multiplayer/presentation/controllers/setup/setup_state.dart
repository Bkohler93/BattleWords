import 'package:battle_words/src/features/multiplayer/domain/setup_gameboard_tile.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:equatable/equatable.dart';

class SetupState extends Equatable {
  final bool placeWordToggle;
  final List<HiddenWord> hiddenWords;
  final bool placementIsValid;
  final List<List<SetupGameBoardTile>> gameBoard;
  final SetupGameBoardTile selectedTile;
  final HiddenWord selectedWord;
  final List<HiddenWord> selectedWords; // treat as stack of hidden words, only pop/push
  final SetupStatus status;
  final SelectedGameCoords selectedCoords;

  const SetupState(
      {required this.hiddenWords,
      required this.placementIsValid,
      required this.gameBoard,
      required this.selectedTile,
      required this.selectedWord,
      required this.selectedWords,
      required this.status,
      required this.selectedCoords,
      required this.placeWordToggle});

  SetupState copyWith(
      {List<HiddenWord>? hiddenWords,
      bool? placementIsValid,
      List<List<SetupGameBoardTile>>? gameBoard,
      SetupGameBoardTile? selectedTile,
      HiddenWord? selectedWord,
      List<HiddenWord>? selectedWords,
      SetupStatus? status,
      SelectedGameCoords? selectedCoords,
      bool? placeWordToggle}) {
    return SetupState(
      hiddenWords: hiddenWords ?? this.hiddenWords,
      placementIsValid: placementIsValid ?? this.placementIsValid,
      gameBoard: gameBoard ?? this.gameBoard,
      selectedTile: selectedTile ?? this.selectedTile,
      selectedWord: selectedWord ?? this.selectedWord,
      selectedWords: selectedWords ?? this.selectedWords,
      status: status ?? this.status,
      selectedCoords: selectedCoords ?? this.selectedCoords,
      placeWordToggle: placeWordToggle ?? this.placeWordToggle,
    );
  }

  factory SetupState.initial() => SetupState(
      hiddenWords: const [],
      placementIsValid: true,
      gameBoard: List.generate(6, (index) => List.generate(6, (index2) => SetupGameBoardTile())),
      selectedTile: SetupGameBoardTile(),
      selectedWord: HiddenWord(word: "no"),
      selectedWords: const [],
      status: SetupStatus.startSetup,
      placeWordToggle: true,
      selectedCoords: SelectedGameCoords(null, null));

  @override
  List<Object> get props => [
        placeWordToggle,
        hiddenWords,
        placementIsValid,
        gameBoard,
        selectedTile,
        selectedWord,
        selectedWords,
        status,
        selectedCoords
      ];
}

enum SetupStatus {
  settingUp,
  awaitingOpponent,
  opponentTimeout,
  connectionError,
  timeout,
  setupComplete,
  startSetup,
}

extension SetupStatusX on SetupStatus {
  bool get isSettingUp => this == SetupStatus.settingUp;
  bool get isAwaitingOpponent => this == SetupStatus.awaitingOpponent;
  bool get isOpponentTimeout => this == SetupStatus.opponentTimeout;
  bool get isConnectionError => this == SetupStatus.connectionError;
  bool get isTimeout => this == SetupStatus.timeout;
  bool get isSetupComplete => this == SetupStatus.setupComplete;
  bool get isStartSetup => this == SetupStatus.startSetup;
}

class SelectedGameCoords {
  final int? col;
  final int? row;

  SelectedGameCoords(this.col, this.row);
}

extension IsGameCoordsSelected on SelectedGameCoords {
  bool get isSelected => col != null && row != null;
}
