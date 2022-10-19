import 'package:battle_words/constants/game_details.dart';
import 'package:battle_words/features/single_player_game/domain/single_player_state.dart';
import 'package:battle_words/features/single_player_game/presentation/single_player_page.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/ui_state.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/game_board_tile.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/game_board_view.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/word_status_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';

void main() {
  Widget createWidgetForTesting({required Widget child}) {
    return ProviderScope(child: Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(home: child);
      },
    ));
  }

  group("test single player page", () {
    test('provider creates a valid single player state', () {
      //container allows access to providers
      final container = ProviderContainer(overrides: [
        // define overrides here if required, such as using a fake repository instead of making API calls
      ]);

      final singlePlayerGameState = container.read(singlePlayerGameControllerProvider);

      //test properties of state provided by provider
      final movesRemaining = singlePlayerGameState.movesRemaining;
      final numberOfTiles =
          singlePlayerGameState.gameBoard.length * singlePlayerGameState.gameBoard[0].length;
      final numberOfHiddenWords = singlePlayerGameState.hiddenWords.length;

      expect(movesRemaining, START_NUM_OF_MOVES);
      expect(numberOfTiles, GAME_BOARD_SIZE * GAME_BOARD_SIZE);
      expect(numberOfHiddenWords, HARD_CODED_WORDS.length);

      //test methods that alter single player game state
      singlePlayerGameState.flipTile(row: 0, col: 0);
      final isCovered = singlePlayerGameState.isTileUncovered(row: 0, col: 0);

      expect(isCovered, false);
    });

    testWidgets('single player page has a game board and word status indicators', (tester) async {
      await tester.pumpWidget(createWidgetForTesting(child: const SinglePlayerPage()));

      //allow any animations to settle
      await tester.pumpAndSettle();

      final wordStatusIndicatorRow = find.byType(WordStatusIndicatorRow);
      final gameBoardView = find.byType(GameBoardView);
      final wordStatusIndicators =
          find.descendant(of: wordStatusIndicatorRow, matching: find.byType(WordStatusIndicator));

      expect(gameBoardView, findsOneWidget);
      expect(wordStatusIndicatorRow, findsOneWidget,
          reason: "to display where words have been found or not");
      expect(wordStatusIndicators, findsNWidgets(HARD_CODED_WORDS.length));
    });

    testWidgets('tap on first tile uncovers tile and reduces moves remaining', (tester) async {
      final container = ProviderContainer();

      final singlePlayerGameController = container.read(singlePlayerGameControllerProvider);

      int row = 0;
      int col = 0;
      await tester.pumpWidget(createWidgetForTesting(
          child: const GameBoardTileWidget(
              singlePlayerGameTile: SinglePlayerGameTile(col: 0, row: 0))));

      await tester.pumpAndSettle();

      expect(singlePlayerGameController.gameBoard[row][col].isCovered, true,
          reason: "tile should be covered before tapping");

      tester.tap(find.byType(GestureDetector));

      expect(singlePlayerGameController.gameBoard[row][col].isCovered, false,
          reason: "tile should be uncovered after tapping");
    });
  });
}
