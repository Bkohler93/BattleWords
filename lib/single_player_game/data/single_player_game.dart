import 'package:battle_words/single_player_game/domain/game_board_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/* expose repositories for rest of application to use */
final singlePlayerGameRepositoryProvider = Provider<SinglePlayerGameRepository>((ref) {
  return NewSinglePlayerGameRepository();
});

/* 
  This is an interface for the single player game repository
  Future expansions on this project may have to retrieve game states from external API calls. Implement a new repository in this case
  */
abstract class SinglePlayerGameRepository {
  Future<SinglePlayerGame> getSinglePlayerGame({int? id});
  Future<void> saveSinglePlayerGame();
}

class NewSinglePlayerGameRepository implements SinglePlayerGameRepository {
  @override
  Future<SinglePlayerGame> getSinglePlayerGame({int? id}) {
    final SinglePlayerGame game = SinglePlayerGame.generate();

    return Future.value(game);
  }

  @override
  Future<void> saveSinglePlayerGame() {
    throw UnimplementedError("saveSinglePlayerGame has not been implemented");
  }
}
