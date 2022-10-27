import 'package:battle_words/constants/game_details.dart';
import 'package:battle_words/features/single_player_game/application/game_service.dart';
import 'package:battle_words/features/single_player_game/data/game_repository.dart';
import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test SinglePlayerGame service', () {
    test('Flipping game board tile returns new board with uncovered tile', () async {
      final mockRepository = MockSinglePlayerGameRepository();
      final game = SinglePlayerGame.generate();
      int col = 0;
      int row = 0;

      final singlePlayerGameService =
          SinglePlayerGameService(singlePlayerGameRepository: mockRepository);

      expect(game.gameBoard[col][row].isCovered, true);

      final updatedGame = await singlePlayerGameService.flipGameBoardTile(
          col: col, row: row, singlePlayerGame: game);

      expect(updatedGame.gameBoard[col][row].isCovered, false);
    });

    test('Reduce number of moves remaining after flipping game board tile', () async {
      final mockRepository = MockSinglePlayerGameRepository();
      final game = SinglePlayerGame.generate();

      final singlePlayerGameService =
          SinglePlayerGameService(singlePlayerGameRepository: mockRepository);

      expect(game.movesRemaining, START_NUM_OF_MOVES,
          reason: "Expect maximum number of moves at start");

      final updatedGame =
          await singlePlayerGameService.flipGameBoardTile(col: 0, row: 0, singlePlayerGame: game);

      expect(updatedGame.movesRemaining, START_NUM_OF_MOVES - 1,
          reason: "movesRemaining decremented after flipGameBoardTile is called");
    });

    test('create a new single player game returns a single player game', () async {
      final mockRepository = MockSinglePlayerGameRepository();

      final singlePlayerGameService =
          SinglePlayerGameService(singlePlayerGameRepository: mockRepository);

      final game = await singlePlayerGameService.createSinglePlayerGame();

      expect(game, isA<SinglePlayerGame>());
    });
  });
}
