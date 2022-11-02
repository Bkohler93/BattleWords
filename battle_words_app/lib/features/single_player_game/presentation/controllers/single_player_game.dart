import 'package:battle_words/features/single_player_game/application/game_service.dart';
import 'package:battle_words/features/single_player_game/data/repositories/game.dart';
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
  final MockSinglePlayerGameRepository repository;
  final SinglePlayerGameService singlePlayerGameService;

  Future<void> _fetchNewGame() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return await singlePlayerGameService.createSinglePlayerGame();
    });
  }

  Future<void> resetGameState() async {
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return SinglePlayerGame.generate();
    });
  }

  void handleTileTap({required row, required col}) async {
    final singlePlayerGame = state.value!;
    state = const AsyncLoading();

    state = await AsyncValue.guard(() async {
      return await singlePlayerGameService.flipGameBoardTile(
        singlePlayerGame: singlePlayerGame,
        row: row,
        col: col,
      );
    });
  }

  void handleWordGuess(String guessWord) async {
    final singlePlayerGame = state.value!;
    state = await AsyncValue.guard(() async {
      return singlePlayerGameService.processWordGuess(
          singlePlayerGame: singlePlayerGame, word: guessWord);
    });

    // for (var word in state.value!.hiddenWords) {
    //   if (word.word == guessWord) {
    //     print("exact match");
    //     state = await AsyncValue.guard(() async {
    //       return singlePlayerGameService.handleExactMatch(
    //           word: guessWord, singlePlayerGame: SinglePlayerGame.from(state.value!));
    //     });
    //     return;
    //   }
    // }
  }
}

final singlePlayerGameControllerProvider =
    StateNotifierProvider<SinglePlayerGameController, AsyncValue<SinglePlayerGame>>((ref) {
  final singlePlayerGameRepository = ref.watch(singlePlayerGameRepositoryProvider);
  final singlePlayerGameService = ref.watch(singlePlayerGameServiceProvider);
  return SinglePlayerGameController(
      repository: singlePlayerGameRepository, singlePlayerGameService: singlePlayerGameService);
});
