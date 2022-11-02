import 'package:battle_words/features/single_player_game/domain/tile_coords.dart';

enum HiddenWordDirection { down, right, unassigned }

class HiddenWord {
  HiddenWord({
    required this.word,
    this.found = false,
    this.letterCoords,
    this.wordDirection = HiddenWordDirection.unassigned,
  }) : length = word.length;
  final String word;
  final int length;
  Map<int, TileCoordinates>?
      letterCoords; //int is the index of current letter, coordinates are the location on the game board.
  HiddenWordDirection wordDirection;
  bool found;
}
