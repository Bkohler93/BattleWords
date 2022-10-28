import 'package:battle_words/features/single_player_game/domain/game_tile.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test SinglePlayerGameTile model', () {
    test("constructor returns a valid SinglePlayerGameTile object", () {
      final gameTile = SinglePlayerGameTile(col: 0, row: 0);

      expect(gameTile, isA<SinglePlayerGameTile>());
      expect(gameTile.isCovered, true, reason: "game tile should start the game being covered");
      expect(gameTile.letter, '',
          reason: "by default every game tile should not have a letter present");
    });

    test("generate a copy of a game board tile", () {
      final gameTile = SinglePlayerGameTile(row: 0, col: 0);

      final gameTileCopy = SinglePlayerGameTile.from(gameTile);

      expect(gameTileCopy, isA<SinglePlayerGameTile>());
    });

    test("flipping a game tile causes isCovered property to be false", () {
      final gameTile = SinglePlayerGameTile(row: 0, col: 0);

      expect(gameTile.isCovered, true);

      final gameTileFlipped = gameTile.flip();

      expect(gameTileFlipped.isCovered, false);
    });
  });
}
