import 'package:battle_words/single_player_game/domain/single_player_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SinglePlayerGameController extends StateNotifier<SinglePlayerGame> {
  SinglePlayerGameController(super.state);

  void flipGameBoardTile() {
    state = state.flipTile(row: 3, col: 3);
  }

  void reduceMovesRemaining() {
    state = state.reduceMovesRemaining();
  }
}

final singlePlayerGameControllerProvider =
    StateNotifierProvider.autoDispose<SinglePlayerGameController, SinglePlayerGame>((ref) {
  return SinglePlayerGameController(SinglePlayerGame.generate());
});
