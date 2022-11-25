part of 'single_player_bloc.dart';

enum GameStatus { initial, loading, playing, win, loss, failure }

extension GameStatusX on GameStatus {
  bool get isInitial => this == GameStatus.initial;
  bool get isLoading => this == GameStatus.loading;
  bool get isPlaying => this == GameStatus.playing;
  bool get isWin => this == GameStatus.win;
  bool get isLoss => this == GameStatus.loss;
  bool get isFailure => this == GameStatus.failure;
}

@immutable
class SinglePlayerState extends Equatable {
  final GameBoard gameBoard;
  final List<HiddenWord> hiddenWords;
  final int movesRemaining;
  final GameStatus gameStatus;
  final KeyboardLetterMap keyboardLetterMap; //Map<String, KeyboardLetterStatus>

  const SinglePlayerState({
    this.gameBoard = const [],
    this.hiddenWords = const [],
    this.movesRemaining = START_NUM_OF_MOVES,
    this.gameStatus = GameStatus.initial,
    this.keyboardLetterMap = const {},
  });

  SinglePlayerState copyWith({
    int? movesRemaining,
    GameBoard? gameBoard,
    List<HiddenWord>? hiddenWords,
    GameStatus? gameStatus,
    KeyboardLetterMap? keyboardLetterMap,
  }) {
    return SinglePlayerState(
        gameBoard: gameBoard ?? this.gameBoard,
        movesRemaining: movesRemaining ?? this.movesRemaining,
        hiddenWords: hiddenWords ?? this.hiddenWords,
        gameStatus: gameStatus ?? this.gameStatus,
        keyboardLetterMap: keyboardLetterMap ?? this.keyboardLetterMap);
  }

  factory SinglePlayerState.generate() {
    GameBoard gameBoard = List.generate(
      GAME_BOARD_SIZE,
      (row) => List.generate(
        GAME_BOARD_SIZE,
        (col) => SinglePlayerGameTile(coordinates: TileCoordinates(col: col, row: row)),
      ),
      growable: false,
    );

    List<HiddenWord> hiddenWords = [
      HiddenWord(word: HARD_CODED_WORDS[0]),
      HiddenWord(word: HARD_CODED_WORDS[1]),
      HiddenWord(word: HARD_CODED_WORDS[2])
    ];

    int movesRemaining = START_NUM_OF_MOVES;

    KeyboardLetterMap keyboardLetterMap = createBlankKeyboardLetterMap();

    return SinglePlayerState(
        gameBoard: gameBoard,
        movesRemaining: movesRemaining,
        hiddenWords: hiddenWords,
        gameStatus: GameStatus.playing,
        keyboardLetterMap: keyboardLetterMap);
  }

  @override
  List<Object?> get props => [
        movesRemaining,
        gameBoard,
        hiddenWords,
        gameStatus,
        keyboardLetterMap,
      ];
}