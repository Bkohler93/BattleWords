import 'package:battle_words/constants/game_details.dart';
import 'package:battle_words/features/single_player_game/presentation/single_player_page.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/game_board_tile.dart';
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
        return UncontrolledProviderScope(
          container: container,
          child: Sizer(builder: (context, orientation, deviceType) {
            return MaterialApp(
              home: child,
            );
          }),
        );
      }

      testWidgets('single player page has a game board and word status indicators', (tester) async {
        final container = ProviderContainer();

        final singlePlayerPage = SinglePlayerPage();

        await tester.pumpWidget(createTestWidget(container: container, child: singlePlayerPage));

        await tester.pumpAndSettle();

        final wordStatusIndicatorRow =
            find.descendant(of: find.byType(Column), matching: find.byType(WordStatusIndicatorRow));

        //final gameBoardView = find.byType(GameBoardView);
        final wordStatusIndicators =
            find.descendant(of: find.byType(Column), matching: find.byType(WordStatusIndicator));

        expect(wordStatusIndicatorRow, findsOneWidget,
            reason: "indicates whether words have been found or not.");
        expect(wordStatusIndicators, findsNWidgets(HARD_CODED_WORDS.length));
      });

      testWidgets(
        'tap on first tile causes tile to turn and display letter',
        (tester) async {
          final container = ProviderContainer();
          final row = 0;
          final col = 0;

          // container.read(singlePlayerGameControllerProvider.notifier).state =
          //     AsyncValue.data(SinglePlayerGame.generate());

          final singlePlayerPage = SinglePlayerPage();

          //pump SinglePlayerGame widget, then look for first GameBoardTileWidget to tap on. (should be row 7, col 0)
          await tester.pumpWidget(createTestWidget(container: container, child: singlePlayerPage));

          await tester.pumpAndSettle();

          //final gameBoardTile = await tester.firstWidget(find.byType(GameBoardTileWidget));

          var borderColor = ((tester
                      .firstWidget<Container>(find.descendant(
                          of: find.byType(GameBoardTileWidget), matching: find.byType(Container)))
                      .decoration as BoxDecoration)
                  .border as Border)
              .bottom
              .color;

          //expect color black38
          expect(borderColor, Colors.black38);

          final gestureDetector = tester.firstWidget(find.descendant(
              of: find.byType(GameBoardTileWidget), matching: find.byType(GestureDetector)));

          await tester.tap(find.byWidget(gestureDetector));
          await tester.pumpAndSettle();

          borderColor = ((tester
                      .firstWidget<Container>(find.descendant(
                          of: find.byType(GameBoardTileWidget), matching: find.byType(Container)))
                      .decoration as BoxDecoration)
                  .border as Border)
              .bottom
              .color;

          //expect color red
          expect(borderColor, Colors.red);
        },
      );
    },
  );
}
