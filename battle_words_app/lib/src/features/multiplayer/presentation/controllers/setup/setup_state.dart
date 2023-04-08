part of 'setup_bloc.dart';

class SetupState extends Equatable {
  final List<HiddenWord> hiddenWords;
  final bool placementIsValid;
  final SetupGameBoard gameBoard;
  final SetupGameBoardTile selectedTile;
  final HiddenWord selectedWord;
  final List<HiddenWord> selectedWords; // treat as stack of hidden words, only pop/push
  final SetupStatus status;

  const SetupState(
      {required this.hiddenWords,
      required this.placementIsValid,
      required this.gameBoard,
      required this.selectedTile,
      required this.selectedWord,
      required this.selectedWords,
      required this.status});

  SetupState copyWith(
      {List<HiddenWord>? hiddenWords,
      bool? placementIsValid,
      SetupGameBoard? gameBoard,
      SetupGameBoardTile? selectedTile,
      HiddenWord? selectedWord,
      List<HiddenWord>? selectedWords,
      SetupStatus? status}) {
    return SetupState(
      hiddenWords: hiddenWords ?? this.hiddenWords,
      placementIsValid: placementIsValid ?? this.placementIsValid,
      gameBoard: gameBoard ?? this.gameBoard,
      selectedTile: selectedTile ?? this.selectedTile,
      selectedWord: selectedWord ?? this.selectedWord,
      selectedWords: selectedWords ?? this.selectedWords,
      status: status ?? this.status,
    );
  }

  factory SetupState.initial() => SetupState(
      hiddenWords: const [],
      placementIsValid: true,
      gameBoard: const SetupGameBoard(gameBoard: []),
      selectedTile: SetupGameBoardTile(),
      selectedWord: HiddenWord(word: "no"),
      selectedWords: const [],
      status: SetupStatus.startSetup);

  @override
  List<Object> get props =>
      [hiddenWords, placementIsValid, gameBoard, selectedTile, selectedWord, selectedWords, status];
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
