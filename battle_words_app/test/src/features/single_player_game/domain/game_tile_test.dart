import 'dart:io';

import 'package:battle_words/src/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/src/features/single_player_game/domain/tile_coords.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('SinglePlayerGameTile initializes with valid Coordinates and default values', () {
    final tile = SinglePlayerGameTile(coordinates: TileCoordinates(col: 2, row: 2));

    final matchCoordinates = TileCoordinates(col: 2, row: 2);
    final matchLetter = '';
    final matchTileStatus = TileStatus.hidden;

    final actualCoordinates = tile.coordinates;
    final actualLetter = tile.letter;
    final actualTileStatus = tile.tileStatus;

    expect(actualLetter, matchLetter);
    expect(actualCoordinates, matchCoordinates);
    expect(actualTileStatus, matchTileStatus);
  });

  test("SinglePlayerGameTile.from(gameTile) returns a copy of an existing gameTile", () {
    final matchTile = SinglePlayerGameTile(coordinates: TileCoordinates(col: 2, row: 2));
    final actualTile = SinglePlayerGameTile.from(matchTile);

    expect(actualTile.letter, matchTile.letter);
    expect(actualTile.coordinates, matchTile.coordinates);
    expect(actualTile.tileStatus, matchTile.tileStatus);
  });

  test(
      "Mutable extension uncover(TileStatus status) sets a game tile's status to [status] argument",
      () {
    SinglePlayerGameTile testTile =
        SinglePlayerGameTile(coordinates: TileCoordinates(col: 2, row: 3));

    expect(testTile.tileStatus, TileStatus.hidden,
        reason: "SinglePlayerGameTile constructor results in [TileStatus.hidden] for created tile");

    TileStatus matchStatus = TileStatus.empty;

    testTile = testTile.uncover(TileStatus.empty);
    final actualStatus = testTile.tileStatus;

    expect(actualStatus, matchStatus);
  });

  test(
      "Mutable extension setLetter(newLetter) on a SinglePlayerGameTile returns a new tile with [newLetter] as the tile's [letter] property",
      () {
    var testTile = SinglePlayerGameTile(coordinates: TileCoordinates(col: 1, row: 2));

    expect(testTile.letter, '',
        reason: "SinglePlayerGameTile constructor results in empty string for [letter] property");

    testTile = testTile.setLetter('a');

    final matchLetter = 'a';
    final actualLetter = testTile.letter;

    expect(actualLetter, matchLetter);
  });
}
