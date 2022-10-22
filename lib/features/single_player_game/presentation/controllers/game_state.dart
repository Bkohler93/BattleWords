import 'package:battle_words/features/single_player_game/application/game_service.dart';
import 'package:battle_words/features/single_player_game/data/game_repository.dart';
import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
*   Name: SinglePlayerGameController
*   Description: This class contains methods that allow the UI to manipulate the state of the single player game. Utilizes StateNotifier to provide an immutable state to the UI.
*/
class SinglePlayerGameController extends StateNotifier<AsyncValue<SinglePlayerGame>> {
  SinglePlayerGameController({required this.repository, required this.singlePlayerGameService})
      : super(const AsyncLoading()) {
    _fetchNewGame();
  }

  Future<void> _fetchNewGame() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return await singlePlayerGameService.createSinglePlayerGame();
    });
  }

  final MockSinglePlayerGameRepository repository;
  final SinglePlayerGameService singlePlayerGameService;

  void handleTileTap({required row, required col}) async {
    state = singlePlayerGameService.uncoverGameTile()
  }

  // void reduceMovesRemaining() {
  //   state = state.reduceMovesRemaining();
  // }
}

final singlePlayerGameControllerProvider =
    StateNotifierProvider<SinglePlayerGameController, AsyncValue<SinglePlayerGame>>((ref) {
  final singlePlayerGameRepository = ref.watch(singlePlayerGameRepositoryProvider);
  final singlePlayerGameService = ref.watch(singlePlayerGameServiceProvider);
  return SinglePlayerGameController(
      repository: singlePlayerGameRepository, singlePlayerGameService: singlePlayerGameService);
});
