import 'package:battle_words/features/single_player_game/domain/single_player_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* expose repositories for rest of application to use */
final singlePlayerGameRepositoryProvider = Provider<SinglePlayerGameRepository>((ref) {
  return SinglePlayerGameRepository();
});

/* 
  This is an interface for the single player game repository
  Future expansions on this project may have to retrieve game states from external API calls. Implement a new repository in this case.
  */
abstract class ISinglePlayerGameRepository {
  Future<SinglePlayerGame> getSinglePlayerGame();
  Future<void> saveSinglePlayerGame();
  SinglePlayerGame mockSinglePlayerGame();
}

class SinglePlayerGameRepository implements ISinglePlayerGameRepository {
  @override
  Future<SinglePlayerGame> getSinglePlayerGame() {
    throw UnimplementedError("implement getSingleplayerGame from SinglePlayerGameRepository");
    // retrieve single player save from db
  }

  @override
  Future<void> saveSinglePlayerGame() {
    throw UnimplementedError("saveSinglePlayerGame has not been implemented");
    // save single player game state in db
  }

  @override
  SinglePlayerGame mockSinglePlayerGame() {
    return SinglePlayerGame.generate();
  }

  void loadSinglePlayerGame() {}
}
