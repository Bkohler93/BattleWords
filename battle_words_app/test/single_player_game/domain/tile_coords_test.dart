import 'package:battle_words/features/single_player_game/domain/tile_coords.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testing TileCoordinates model', () {
    test('constructor generates a TileCoordinates object with given row and col', () {
      final tileCoordinates = TileCoordinates(col: 0, row: 0);

      expect(tileCoordinates.col, 0);
      expect(tileCoordinates.row, 0);
    });
  });
}
