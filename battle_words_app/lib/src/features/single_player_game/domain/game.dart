// import 'package:battle_words/src/constants/game_details.dart';
// import 'package:battle_words/src/features/single_player_game/domain/game_tile.dart';
// import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
// import 'package:battle_words/src/features/single_player_game/domain/tile_coords.dart';
// import 'package:battle_words/src/features/single_player_game/presentation/widgets/keyboard/domain/letter.dart';
// import 'package:battle_words/src/helpers/data_types.dart';
// import 'package:flutter/material.dart';

// //!
// //! DELETE ME ONCE [application/game_service.dart] is no longer needed.
// //!
// //!
// enum GameResult { playing, win, loss }

// extension GameResultX on GameResult {
//   bool get isPlaying => this == GameResult.playing;
//   bool get isWin => this == GameResult.win;
//   bool get isLoss => this == GameResult.loss;
// }

// @immutable
// class SinglePlayerGame {
//   final GameBoard gameBoard;
//   final List<HiddenWord> hiddenWords;
//   final int movesRemaining;
//   final GameResult gameResult;
//   final KeyboardLetterMap keyboardLetterMap; //Map<String, KeyboardLetterStatus>

//   const SinglePlayerGame({
//     required this.gameBoard,
//     required this.hiddenWords,
//     required this.movesRemaining,
//     required this.gameResult,
//     required this.keyboardLetterMap,
//   });

//   //TODO
//   factory SinglePlayerGame.fromMap(Map<String, dynamic> map) {
//     throw UnimplementedError("Implement fromMap for SinglePlayerGame");
//   }

//   factory SinglePlayerGame.generate() {
//     GameBoard gameBoard = List.generate(
//       GAME_BOARD_SIZE,
//       (row) => List.generate(
//         GAME_BOARD_SIZE,
//         (col) => SinglePlayerGameTile(coordinates: TileCoordinates(col: col, row: row)),
//       ),
//       growable: false,
//     );

//     List<HiddenWord> hiddenWords = [
//       HiddenWord(word: HARD_CODED_WORDS[0]),
//       HiddenWord(word: HARD_CODED_WORDS[1]),
//       HiddenWord(word: HARD_CODED_WORDS[2])
//     ];

//     int movesRemaining = START_NUM_OF_MOVES;

//     KeyboardLetterMap keyboardLetterMap = createBlankKeyboardLetterMap();

//     return SinglePlayerGame(
//         gameBoard: gameBoard,
//         movesRemaining: movesRemaining,
//         hiddenWords: hiddenWords,
//         gameResult: GameResult.playing,
//         keyboardLetterMap: keyboardLetterMap);
//   }

//   factory SinglePlayerGame.from(SinglePlayerGame singlePlayerGame) {
//     GameBoard gameBoardCopy = singlePlayerGame.gameBoard
//         .map((List<SinglePlayerGameTile> row) => List<SinglePlayerGameTile>.from(row))
//         .toList();

//     List<HiddenWord> hiddenWordsCopy = List<HiddenWord>.from(singlePlayerGame.hiddenWords);

//     KeyboardLetterMap keyboardLetterMap =
//         Map<String, KeyboardLetterStatus>.from(singlePlayerGame.keyboardLetterMap);

//     int movesRemainingCopy = singlePlayerGame.movesRemaining;

//     return SinglePlayerGame(
//       gameBoard: gameBoardCopy,
//       hiddenWords: hiddenWordsCopy,
//       movesRemaining: movesRemainingCopy,
//       gameResult: singlePlayerGame.gameResult,
//       keyboardLetterMap: keyboardLetterMap,
//     );
//   }

//   //TODO
//   Map<String, dynamic> toMap() {
//     throw UnimplementedError("Implement toMap for SinglePlayerGame");
//   }

//   bool isTileCovered({required int row, required int col}) {
//     return gameBoard[row][col].tileStatus == TileStatus.hidden;
//   }

//   SinglePlayerGame copyWith({
//     int? movesRemaining,
//     GameBoard? gameBoard,
//     List<HiddenWord>? hiddenWords,
//     GameResult? gameResult,
//     KeyboardLetterMap? keyboardLetterMap,
//   }) {
//     return SinglePlayerGame(
//         gameBoard: gameBoard ?? this.gameBoard,
//         movesRemaining: movesRemaining ?? this.movesRemaining,
//         hiddenWords: hiddenWords ?? this.hiddenWords,
//         gameResult: gameResult ?? this.gameResult,
//         keyboardLetterMap: keyboardLetterMap ?? this.keyboardLetterMap);
//   }
// }

// extension MutableSinglePlayerGame on SinglePlayerGame {
//   SinglePlayerGame reduceMovesRemaining() {
//     return SinglePlayerGame(
//       gameBoard: copyGameBoard(gameBoard),
//       hiddenWords: copyHiddenWords(hiddenWords),
//       movesRemaining: movesRemaining - 1,
//       gameResult: gameResult,
//       keyboardLetterMap: keyboardLetterMap,
//     );
//   }

//   SinglePlayerGame flipTile({required int row, required int col}) {
//     SinglePlayerGame singlePlayerGameCopy = SinglePlayerGame.from(this);
//     switch (singlePlayerGameCopy.gameBoard[row][col].letter) {
//       case "":
//         singlePlayerGameCopy.gameBoard[row][col] =
//             singlePlayerGameCopy.gameBoard[row][col].uncover(TileStatus.empty);
//         break;
//       default:
//         singlePlayerGameCopy.gameBoard[row][col] =
//             singlePlayerGameCopy.gameBoard[row][col].uncover(TileStatus.letterFound);
//     }

//     return singlePlayerGameCopy;
//   }

//   SinglePlayerGame setGameResult(GameResult result) {
//     return SinglePlayerGame(
//       gameBoard: copyGameBoard(gameBoard),
//       hiddenWords: copyHiddenWords(hiddenWords),
//       movesRemaining: movesRemaining,
//       gameResult: result,
//       keyboardLetterMap: KeyboardLetterMap.from(keyboardLetterMap),
//     );
//   }
// }
