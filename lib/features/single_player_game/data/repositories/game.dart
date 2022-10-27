import 'dart:async';

import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* expose repositories for rest of application to use */
final singlePlayerGameRepositoryProvider = Provider<MockSinglePlayerGameRepository>((ref) {
  return MockSinglePlayerGameRepository();
});

/* 
  This is an interface for the single player game repository
  Future expansions on this project may have to retrieve game states from external API calls. Implement a new repository in this case.
  */
abstract class ISinglePlayerGameRepository {
  FutureOr<SinglePlayerGame> getSinglePlayerGame();
  FutureOr<SinglePlayerGame> setSinglePlayerGame(SinglePlayerGame singlePlayerGame);
}

class MockSinglePlayerGameRepository implements ISinglePlayerGameRepository {
  @override
  Future<SinglePlayerGame> getSinglePlayerGame() async {
    await Future.delayed(Duration(milliseconds: 5));
    return SinglePlayerGame.generate();
  }

  @override
  Future<SinglePlayerGame> setSinglePlayerGame(SinglePlayerGame singlePlayerGame) async {
    await Future.delayed(Duration(milliseconds: 5));
    return SinglePlayerGame.generate();
  }
}

class SinglePlayerGameRepository implements ISinglePlayerGameRepository {
  @override
  Future<SinglePlayerGame> getSinglePlayerGame() {
    throw UnimplementedError("Hook up database to this method first");
  }

  void loadSinglePlayerGame() {}

  @override
  FutureOr<SinglePlayerGame> setSinglePlayerGame(SinglePlayerGame singlePlayerGame) {
    // TODO: implement setSinglePlayerGame
    throw UnimplementedError();
  }
}
