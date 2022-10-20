import 'package:battle_words/features/single_player_game/domain/single_player_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
*   Name: SinglePlayerGameController
*   Description: This class contains methods that allow the UI to manipulate the state of the single player game. Utilizes StateNotifier to provide an immutable state to the UI. Has an optional parameter of an instance of the state model, SinglePlayerGame, which
*/
class SinglePlayerGameController extends StateNotifier<SinglePlayerGame> {
  SinglePlayerGameController() : super(SinglePlayerGame.generate());

  void flipGameBoardTile({required row, required col}) {
    state = state.flipTile(row: row, col: col);
  }

  void reduceMovesRemaining() {
    state = state.reduceMovesRemaining();
  }
}

final singlePlayerGameControllerProvider =
    StateNotifierProvider<SinglePlayerGameController, SinglePlayerGame>((ref) {
  return SinglePlayerGameController();
});
