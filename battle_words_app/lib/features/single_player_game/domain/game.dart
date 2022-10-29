import 'package:battle_words/constants/game_details.dart';
import 'package:battle_words/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/helpers/data_types.dart';
import 'package:flutter/material.dart';

enum GameResult { playing, win, loss }

@immutable
class SinglePlayerGame {
  final GameBoard gameBoard;
  final List<HiddenWord> hiddenWords;
  final int movesRemaining;
  final GameResult gameResult;

  const SinglePlayerGame({
    required this.gameBoard,
    required this.hiddenWords,
    required this.movesRemaining,
    required this.gameResult,
  });

  //TODO
  factory SinglePlayerGame.fromMap(Map<String, dynamic> map) {
    throw UnimplementedError("Implement fromMap for SinglePlayerGame");
  }

  factory SinglePlayerGame.generate() {
    GameBoard gameBoard = List.generate(
      GAME_BOARD_SIZE,
      (row) => List.generate(
        GAME_BOARD_SIZE,
        (col) => SinglePlayerGameTile(row: row, col: col),
      ),
      growable: false,
    );

    List<HiddenWord> hiddenWords = [
      HiddenWord(word: HARD_CODED_WORDS[0]),
      HiddenWord(word: HARD_CODED_WORDS[1]),
      HiddenWord(word: HARD_CODED_WORDS[2])
    ];

    int movesRemaining = START_NUM_OF_MOVES;

    return SinglePlayerGame(
        gameBoard: gameBoard,
        movesRemaining: movesRemaining,
        hiddenWords: hiddenWords,
        gameResult: GameResult.playing);
  }

  factory SinglePlayerGame.from(SinglePlayerGame singlePlayerGame) {
    GameBoard gameBoardCopy = singlePlayerGame.gameBoard
        .map((List<SinglePlayerGameTile> row) => List<SinglePlayerGameTile>.from(row))
        .toList();

    List<HiddenWord> hiddenWordsCopy = List<HiddenWord>.from(singlePlayerGame.hiddenWords);

    int movesRemainingCopy = singlePlayerGame.movesRemaining;

    return SinglePlayerGame(
        gameBoard: gameBoardCopy,
        hiddenWords: hiddenWordsCopy,
        movesRemaining: movesRemainingCopy,
        gameResult: singlePlayerGame.gameResult);
  }

  //TODO
  Map<String, dynamic> toMap() {
    throw UnimplementedError("Implement toMap for SinglePlayerGame");
  }

  bool isTileCovered({required int row, required int col}) {
    return gameBoard[row][col].isCovered;
  }
}

extension MutableSinglePlayerGame on SinglePlayerGame {
  SinglePlayerGame reduceMovesRemaining() {
    return SinglePlayerGame(
      gameBoard: copyGameBoard(gameBoard),
      hiddenWords: copyHiddenWords(hiddenWords),
      movesRemaining: movesRemaining - 1,
      gameResult: gameResult,
    );
  }

  SinglePlayerGame flipTile({required int row, required int col}) {
    SinglePlayerGame singlePlayerGameCopy = SinglePlayerGame.from(this);

    singlePlayerGameCopy.gameBoard[row][col] = singlePlayerGameCopy.gameBoard[row][col].flip();

    return singlePlayerGameCopy;
  }

  SinglePlayerGame setGameResult(GameResult result) {
    return SinglePlayerGame(
      gameBoard: copyGameBoard(gameBoard),
      hiddenWords: copyHiddenWords(hiddenWords),
      movesRemaining: movesRemaining,
      gameResult: result,
    );
  }
}