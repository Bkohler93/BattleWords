import 'package:battle_words/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/features/single_player_game/domain/tile_coords.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test SinglePlayerGameTile model', () {
    test("constructor returns a valid SinglePlayerGameTile object", () {
      final gameTile = SinglePlayerGameTile(coordinates: TileCoordinates(col: 0, row: 0));

      expect(gameTile, isA<SinglePlayerGameTile>());
      expect(gameTile.letter, '',
          reason: "by default every game tile should not have a letter present");
    });

    test("generate a copy of a game board tile", () {
      final gameTile = SinglePlayerGameTile(coordinates: TileCoordinates(col: 0, row: 0));

      final gameTileCopy = SinglePlayerGameTile.from(gameTile);

      expect(gameTileCopy, isA<SinglePlayerGameTile>());
    });

    test("flipping a game tile causes isCovered property to be false", () {
      final gameTile = SinglePlayerGameTile(coordinates: TileCoordinates(col: 0, row: 0));

      expect(gameTile.tileStatus, TileStatus.hidden);

      final gameTileFlipped = gameTile.uncover(TileStatus.letterFound);

      expect(gameTileFlipped.tileStatus == TileStatus.hidden, false);
    });

    test("calling setLetter on a game tile results in that game tile's letter being changed", () {
      var gameTile = SinglePlayerGameTile(coordinates: TileCoordinates(col: 0, row: 0), letter: '');

      gameTile = gameTile.setLetter("a");

      final expected = 'a';
      final test = gameTile.letter;

      expect(test, expected);
    });

    test("calling isEmpty on a game tile with an empty string returns true", () {
      final gameTile =
          SinglePlayerGameTile(coordinates: TileCoordinates(col: 0, row: 0), letter: '');

      final expected = true;
      final test = gameTile.isEmpty();

      expect(test, expected);
    });

    test("calling isEmpty on a game tile with a nonempty string returns false", () {
      final gameTile =
          SinglePlayerGameTile(coordinates: TileCoordinates(col: 0, row: 0), letter: 'a');

      final expected = false;
      final test = gameTile.isEmpty();

      expect(test, expected);
    });

    test("calling isNotEmpty on a game tile with an empty string returns false", () {
      final gameTile =
          SinglePlayerGameTile(coordinates: TileCoordinates(col: 0, row: 0), letter: '');

      final expected = false;
      final test = gameTile.isNotEmpty();

      expect(test, expected);
    });

    test("calling isNotEmpty on a game tile with a nonempty string returns true", () {
      final gameTile =
          SinglePlayerGameTile(coordinates: TileCoordinates(col: 0, row: 0), letter: 'a');

      final expected = true;
      final test = gameTile.isNotEmpty();

      expect(test, expected);
    });
  });
}
