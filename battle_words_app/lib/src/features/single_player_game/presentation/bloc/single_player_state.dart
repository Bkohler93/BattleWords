part of 'single_player_bloc.dart';

@JsonEnum()
enum GameStatus {
  @JsonValue('initial')
  initial,
  @JsonValue('loading')
  loading,
  @JsonValue('playing')
  playing,
  @JsonValue('win')
  win,
  @JsonValue('loss')
  loss,
  @JsonValue('failure')
  failure,
}

extension GameStatusX on GameStatus {
  bool get isInitial => this == GameStatus.initial;
  bool get isLoading => this == GameStatus.loading;
  bool get isPlaying => this == GameStatus.playing;
  bool get isWin => this == GameStatus.win;
  bool get isLoss => this == GameStatus.loss;
  bool get isFailure => this == GameStatus.failure;
}

@immutable
@JsonSerializable()
class SinglePlayerState extends Equatable {
  final List<List<SinglePlayerGameTile>> gameBoard; //enum GameBoartd
  final List<String> wordsGuessed;
  final List<HiddenWord> hiddenWords;
  final int movesRemaining;
  final GameStatus gameStatus;
  final Map<String, KeyboardLetterStatus> keyboardLetterMap; //KeyboardLettermap

  const SinglePlayerState({
    this.gameBoard = const [],
    this.hiddenWords = const [],
    this.wordsGuessed = const [],
    this.movesRemaining = START_NUM_OF_MOVES,
    this.gameStatus = GameStatus.loading,
    this.keyboardLetterMap = const {},
  });

  SinglePlayerState copyWith({
    int? movesRemaining,
    GameBoard? gameBoard,
    List<HiddenWord>? hiddenWords,
    GameStatus? gameStatus,
    KeyboardLetterMap? keyboardLetterMap,
    List<String>? wordsGuessed,
  }) {
    return SinglePlayerState(
      gameBoard: gameBoard ?? this.gameBoard,
      movesRemaining: movesRemaining ?? this.movesRemaining,
      hiddenWords: hiddenWords ?? this.hiddenWords,
      gameStatus: gameStatus ?? this.gameStatus,
      keyboardLetterMap: keyboardLetterMap ?? this.keyboardLetterMap,
      wordsGuessed: wordsGuessed ?? this.wordsGuessed,
    );
  }

  //! move this logic into Isolate !\\
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
        keyboardLetterMap: keyboardLetterMap,
        wordsGuessed: const []);
  }

  @override
  List<Object?> get props => [
        movesRemaining,
        gameBoard,
        hiddenWords,
        gameStatus,
        keyboardLetterMap,
        wordsGuessed,
      ];

  factory SinglePlayerState.fromJson(Map<String, dynamic> json) =>
      _$SinglePlayerStateFromJson(json);
  Map<String, dynamic> toJson() => _$SinglePlayerStateToJson(this);
}
