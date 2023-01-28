import 'package:battle_words/src/constants/game_details.dart';
import 'package:battle_words/src/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/src/features/single_player_game/domain/tile_coords.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/keyboard/domain/letter.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/moves_remaining_display.dart';
import 'package:battle_words/src/helpers/data_types.dart';
import 'package:flutter_test/flutter_test.dart';

//! This file contains test for old Domain/game.dart 
//! Need to update using the SinglePlayerState that SinglePlayerBloc uses

// void main() {
//   test("SinglePlayerGame constructor initializes all required attributes", () {
//     final gameBoard = createGameboard();
//     final hiddenWords = createMockHiddenWords(); //["yup", "here", "sauce"]
//     final gameResult = GameResult.playing;
//     final movesRemaining = START_NUM_OF_MOVES;
//     final keyboardLetterMap = createBlankKeyboardLetterMap();

//     final testGame = SinglePlayerGame(
//         gameBoard: gameBoard,
//         hiddenWords: hiddenWords,
//         movesRemaining: movesRemaining,
//         gameResult: gameResult,
//         keyboardLetterMap: keyboardLetterMap);

//     expect(testGame.gameBoard is GameBoard, true);
//     expect(testGame.gameResult is GameResult, true);
//     expect(testGame.hiddenWords is List<HiddenWord>, true);
//     expect(testGame.keyboardLetterMap is KeyboardLetterMap, true);
//     expect(testGame.movesRemaining is int, true);
//   });

//   test("SinglePlayerGame.generate() creates a valid SinglePlayerGame", () {
//     final testGame = SinglePlayerGame.generate();

//     final matchBoardSize = 36;
//     final matchHiddenWordsLength = 3;
//     final matchMovesRemaining = START_NUM_OF_MOVES;

//     final actualBoardSize = testGame.gameBoard.length * testGame.gameBoard[0].length;
//     final actualHiddenWordsLength = testGame.hiddenWords.length;
//     final actualMovesRemaining = testGame.movesRemaining;

//     expect(actualHiddenWordsLength, matchHiddenWordsLength);
//     expect(actualMovesRemaining, matchMovesRemaining);
//     expect(actualBoardSize, matchBoardSize);
//   });

//   test(
//       "SinglePlayerGame.copyWith(movesRemaining: 3) returns a SinglePlayerGame while only updating movesRemaining",
//       () {
//     final testGame = SinglePlayerGame.generate();
//     final updatedGame = testGame.copyWith(movesRemaining: 3);

//     final matchMovesRemaining = 3;
//     final actualMovesRemaining = updatedGame.movesRemaining;

//     expect(actualMovesRemaining, matchMovesRemaining);
//   });

//   test(
//       "SinglePlayerGame.copyWith(gameBoard: [gameboard with all tiles set to TileStatus.empty]) returns a SinglePlayerGame while only updating the gameBoard",
//       () {
//     final testGame = SinglePlayerGame.generate();
//     final updatedGameBoard = List.generate(
//         GAME_BOARD_SIZE,
//         (row) => List.generate(
//             GAME_BOARD_SIZE,
//             (col) => SinglePlayerGameTile(
//                 coordinates: TileCoordinates(col: col, row: row), tileStatus: TileStatus.empty)));

//     final updatedGame = testGame.copyWith(gameBoard: updatedGameBoard);

//     final matchIsEveryTileEmpty = true;
//     final actualIsEveryTileEmpty = updatedGame.gameBoard.every(
//       (row) => row.every((tile) => tile.tileStatus == TileStatus.empty),
//     );

//     expect(actualIsEveryTileEmpty, matchIsEveryTileEmpty);
//   });

//   test(
//       "SinglePlayerGame.copyWith(hiddenWords: newHiddenWords) returns a SinglePlayerGame while only updating the hiddenWords",
//       () {
//     final testGame = SinglePlayerGame.generate();
//     final updatedHiddenWords = [
//       HiddenWord(word: "new"),
//       HiddenWord(word: "what"),
//       HiddenWord(word: "cheese")
//     ];

//     final updatedGame = testGame.copyWith(hiddenWords: updatedHiddenWords);

//     final matchHiddenWords = ["new", "what", "cheese"];
//     final actualHiddenWords = updatedGame.hiddenWords.map((hiddenWord) => hiddenWord.word).toList();

//     expect(actualHiddenWords, matchHiddenWords);
//   });

//   test(
//       "SinglePlayerGame.copyWith(gameResult: [GameResult.win]) returns a SinglePlayerGame while only updating the gameResult to GameResult.win",
//       () {
//     final testGame = SinglePlayerGame.generate();

//     final updatedGame = testGame.copyWith(gameResult: GameResult.win);

//     final matchGameResult = GameResult.win;
//     final actualGameResult = updatedGame.gameResult;

//     expect(actualGameResult, matchGameResult);
//   });

//   test(
//       "SinglePlayerGame.copyWith(keyboardLetterMap: [KeyboardLetterMap all keys set to KeyboardLetterStatus.complete]) returns a SinglePlayerGame while only updating every key on keyboardLettermap to KeyboardLetterStatus.complete",
//       () {
//     final testGame = SinglePlayerGame.generate();
//     final updatedKeyboardLetterMap = createBlankKeyboardLetterMap().map(
//       (key, value) => MapEntry(key, KeyboardLetterStatus.complete),
//     );

//     final updatedGame = testGame.copyWith(keyboardLetterMap: updatedKeyboardLetterMap);

//     final matchAreAllKeyStatusesComplete = true;
//     final actualAreAllKeyStatusesComplete = updatedGame.keyboardLetterMap.values
//         .every((letterStatus) => letterStatus == KeyboardLetterStatus.complete);

//     expect(actualAreAllKeyStatusesComplete, matchAreAllKeyStatusesComplete);
//   });
// }
