import 'package:battle_words/constants/game_details.dart';
import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:battle_words/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/features/single_player_game/presentation/single_player_page.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/game_state.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/game_board_tile.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/game_board_view.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/word_status_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sizer/sizer.dart';

void main() {
  group(
    "test single player page",
    () {
      Widget createTestWidget({required ProviderContainer container, required Widget child}) {
        return MediaQuery(
          data: MediaQueryData(),
          child: UncontrolledProviderScope(
            container: container,
            child: Sizer(builder: (context, orientation, deviceType) {
              return MaterialApp(
                home: child,
              );
            }),
          ),
        );
      }

      test('provider creates a valid single player state', () {
        final container = ProviderContainer();

        final singlePlayerGameState = container.read(singlePlayerGameControllerProvider).value!;

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
        final isCovered = singlePlayerGameState.isTileCovered(row: 0, col: 0);

        expect(isCovered, true);
      });

      testWidgets('single player page has a game board and word status indicators', (tester) async {
        final container = ProviderContainer();

        await tester.pumpWidget(createTestWidget(container: container, child: SinglePlayerPage()));

        final wordStatusIndicatorRow = find.byType(WordStatusIndicatorRow);
        //final gameBoardView = find.byType(GameBoardView);
        final wordStatusIndicators =
            find.descendant(of: wordStatusIndicatorRow, matching: find.byType(WordStatusIndicator));

        //expect(gameBoardView, findsOneWidget);
        expect(wordStatusIndicatorRow, findsOneWidget,
            reason: "to display where words have been found or not");
        expect(wordStatusIndicators, findsNWidgets(HARD_CODED_WORDS.length));
      });

      testWidgets(
        'tap on first tile uncovers tile and reduces moves remaining',
        (tester) async {
          final container = ProviderContainer();
          final row = 0;
          final col = 0;

          await tester.pumpWidget(createTestWidget(
              container: container,
              child: GameBoardTileWidget(
                singlePlayerGameTile: SinglePlayerGameTile(
                  row: row,
                  col: col,
                ),
              )));

          bool isCovered = container
              .read(singlePlayerGameControllerProvider)
              .value!
              .gameBoard[row][col]
              .isCovered;

          expect(isCovered, true, reason: "game tile isCovered property starts as true");

          await tester.tap(find.byType(GestureDetector));

          isCovered = container
              .read(singlePlayerGameControllerProvider)
              .value!
              .gameBoard[row][col]
              .isCovered;

          expect(isCovered, false,
              reason: "game tile isCovered property changes to false after game tile taps");
        },
      );
    },
  );
}
