import 'dart:async';

import 'package:battle_words/features/single_player_game/bloc/single_player_bloc.dart';
import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:battle_words/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/features/single_player_game/domain/tile_coords.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* expose repositories for rest of application to use */
final singlePlayerRepositoryProvider = Provider<MockSinglePlayerRepository>((ref) {
  return MockSinglePlayerRepository();
});

/* 
  This is an interface for the single player game repository
  Future expansions on this project may have to retrieve game states from external API calls. Implement a new repository in this case.
  */
abstract class ISinglePlayerRepository {
  FutureOr<SinglePlayerState> getSinglePlayerGame();
  FutureOr<bool> setSinglePlayerGame(SinglePlayerState singlePlayerGame);
  FutureOr<SinglePlayerState> updateGameByTileTap({required int col, required int row});
}

class MockSinglePlayerRepository implements ISinglePlayerRepository {
  @override
  Future<SinglePlayerState> getSinglePlayerGame() async {
    await Future.delayed(Duration(milliseconds: 5));
    return SinglePlayerState.generate();
  }

  @override
  Future<bool> setSinglePlayerGame(SinglePlayerState singlePlayerGame) async {
    return true;
  }

  @override
  FutureOr<SinglePlayerState> updateGameByTileTap({required int col, required int row}) {
    // TODO: implement updateGameByTileTap
    throw UnimplementedError();
  }
}

class SinglePlayerRepository implements ISinglePlayerRepository {
  @override
  Future<SinglePlayerState> getSinglePlayerGame() {
    return Future.value(SinglePlayerState.generate());
  }

  void loadSinglePlayerGame() {}

  @override
  FutureOr<bool> setSinglePlayerGame(SinglePlayerState singlePlayerGame) {
    return true;
  }

  @override
  FutureOr<SinglePlayerState> updateGameByTileTap({required int col, required int row}) {
    final state = SinglePlayerState.generate();

    //hardcoded changing value
    state.gameBoard[col][row] = SinglePlayerGameTile(
        coordinates: TileCoordinates(col: col, row: row), tileStatus: TileStatus.empty);

    return state;
  }
}
