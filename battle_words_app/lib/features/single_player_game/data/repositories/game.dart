import 'dart:async';

import 'package:battle_words/features/single_player_game/bloc/single_player_bloc.dart';
import 'package:battle_words/features/single_player_game/domain/game.dart';
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
  FutureOr<SinglePlayerState> setSinglePlayerGame(SinglePlayerState singlePlayerGame);
}

class MockSinglePlayerRepository implements ISinglePlayerRepository {
  @override
  Future<SinglePlayerState> getSinglePlayerGame() async {
    await Future.delayed(Duration(milliseconds: 5));
    return SinglePlayerState.generate();
  }

  @override
  Future<SinglePlayerState> setSinglePlayerGame(SinglePlayerState singlePlayerGame) async {
    await Future.delayed(Duration(milliseconds: 5));
    return SinglePlayerState.generate();
  }
}

class SinglePlayerRepository implements ISinglePlayerRepository {
  @override
  Future<SinglePlayerState> getSinglePlayerGame() {
    return Future.value(SinglePlayerState.generate());
  }

  void loadSinglePlayerGame() {}

  @override
  FutureOr<SinglePlayerState> setSinglePlayerGame(SinglePlayerState singlePlayerGame) {
    // TODO: implement setSinglePlayer
    throw UnimplementedError();
  }
}
