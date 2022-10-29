// ignore_for_file: unused_local_variable

import 'package:battle_words/api/object_box/object_box.dart';
import 'package:battle_words/constants/game_details.dart';
import 'package:battle_words/features/single_player_game/data/repositories/game.dart';
import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:battle_words/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/helpers/data_types.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final singlePlayerGameServiceProvider = Provider<SinglePlayerGameService>((ref) {
  return SinglePlayerGameService(
      singlePlayerGameRepository: ref.watch(singlePlayerGameRepositoryProvider),
      objectBoxRepository: ref.watch(objectBoxRepositoryProvider));
});

class SinglePlayerGameService {
  SinglePlayerGameService(
      {required this.singlePlayerGameRepository, required this.objectBoxRepository});
  final MockSinglePlayerGameRepository singlePlayerGameRepository;
  final IObjectBoxRepository objectBoxRepository;

  Future<SinglePlayerGame> flipGameBoardTile(
      {required int row, required int col, required SinglePlayerGame singlePlayerGame}) {
    final SinglePlayerGameTile gameTile = singlePlayerGame.gameBoard[row][col];

    if (!gameTile.isCovered) {
      return Future.value(SinglePlayerGame.from(singlePlayerGame));
    }

    //! check if all words have been uncovered, return with GameResult.win

    //! reduce moves remaining
    singlePlayerGame = singlePlayerGame.flipTile(col: col, row: row);

    singlePlayerGame = _findUncoveredWords(singlePlayerGame: singlePlayerGame);

    singlePlayerGame = _checkIfWin(singlePlayerGame: singlePlayerGame);

    if (singlePlayerGame.gameResult != GameResult.win) {
      singlePlayerGame = _reduceMovesRemaining(singlePlayerGame: singlePlayerGame);
    }
    return _setSinglePlayerGame(singlePlayerGame: singlePlayerGame);
  }

  Future<SinglePlayerGame> handleWordGuess({required SinglePlayerGame singlePlayerGame}) {
    throw UnimplementedError("Not implemented handling word guesses yet");
  }

  SinglePlayerGame _reduceMovesRemaining({required SinglePlayerGame singlePlayerGame}) {
    //reduce moves remaining
    singlePlayerGame = singlePlayerGame.reduceMovesRemaining();

    //check if 0, set GameResult to GameResult.win
    if (singlePlayerGame.movesRemaining == 0) {
      singlePlayerGame = singlePlayerGame.setGameResult(GameResult.loss);
    }

    // set in database
    return SinglePlayerGame.from(singlePlayerGame);
  }

  Future<SinglePlayerGame> createSinglePlayerGame() async {
    // get hidden words
    final List<HiddenWord> hiddenWords = await objectBoxRepository.getRandomWords();

    // create gameboard
    GameBoard gameBoard = List.generate(GAME_BOARD_SIZE,
        (row) => List.generate(GAME_BOARD_SIZE, (col) => SinglePlayerGameTile(col: col, row: row)));

    //arrange words on board
    gameBoard = _arrangeGameBoard(gameBoard, hiddenWords);

    // set moves remaining

    // set single player game in database

    // send single player game to controller
    return singlePlayerGameRepository.getSinglePlayerGame();
  }

  GameBoard _arrangeGameBoard(GameBoard gameBoard, List<HiddenWord> hiddenWords) {
    for (var hiddenWord in hiddenWords) {}

    return List.generate(
      GAME_BOARD_SIZE,
      (row) => List.generate(
        GAME_BOARD_SIZE,
        (col) => SinglePlayerGameTile(col: col, row: row),
      ),
    );
  }

  // ignore: unused_element
  Future<SinglePlayerGame> _fetchSinglePlayerGame() {
    return singlePlayerGameRepository.getSinglePlayerGame();
  }

  // ignore: unused_element
  Future<SinglePlayerGame> _setSinglePlayerGame({required SinglePlayerGame singlePlayerGame}) {
    return Future.value(SinglePlayerGame.from(singlePlayerGame));

    // ignore: dead_code
    final gameService = singlePlayerGameRepository.getSinglePlayerGame();
  }

  //! implement this, lots of logic involved.
  SinglePlayerGame _findUncoveredWords({required SinglePlayerGame singlePlayerGame}) {
    return SinglePlayerGame.from(singlePlayerGame);
  }

  SinglePlayerGame _checkIfWin({required SinglePlayerGame singlePlayerGame}) {
    return SinglePlayerGame.from(singlePlayerGame);
  }
}
