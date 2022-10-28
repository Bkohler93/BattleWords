// ignore_for_file: unused_local_variable

import 'package:battle_words/features/single_player_game/data/repositories/game.dart';
import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:battle_words/features/single_player_game/domain/game_tile.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SinglePlayerGameService {
  SinglePlayerGameService({required this.singlePlayerGameRepository});
  final MockSinglePlayerGameRepository singlePlayerGameRepository;

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

  Future<SinglePlayerGame> createSinglePlayerGame() {
    // get hidden words

    // arrange words on board

    // set moves remaining

    // set single player game in database

    // send single player game to controller
    return singlePlayerGameRepository.getSinglePlayerGame();
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

final singlePlayerGameServiceProvider = Provider<SinglePlayerGameService>((ref) {
  return SinglePlayerGameService(
      singlePlayerGameRepository: ref.watch(singlePlayerGameRepositoryProvider));
});
