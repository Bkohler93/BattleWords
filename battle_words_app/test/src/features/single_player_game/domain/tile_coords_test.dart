import 'package:battle_words/src/features/single_player_game/domain/tile_coords.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test("TileCoordinates(col, row) returnsa  TileCoordinates instance with col and row attributes",
      () {
    const matchCol = 2;
    const matchRow = 3;

    const coordinates = TileCoordinates(col: 2, row: 3);

    final actualCol = coordinates.col;
    final actualRow = coordinates.row;

    expect(actualCol, matchCol);
    expect(actualRow, matchRow);
  });
}
