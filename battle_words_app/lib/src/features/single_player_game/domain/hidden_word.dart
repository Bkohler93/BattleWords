import 'package:battle_words/src/features/single_player_game/domain/tile_coords.dart';

enum HiddenWordDirection { down, right, unassigned }

class HiddenWord {
  HiddenWord({
    required this.word,
    this.isWordFound = false,
    this.letterCoords,
    this.wordDirection = HiddenWordDirection.unassigned,
  })  : length = word.length,
        areLettersFound = List.generate(
          word.length,
          (_) => false,
          growable: false,
        );

  final String word;
  final int length;

  /// int is the index of current letter, coordinates are the location on the game board.
  Map<int, TileCoordinates>? letterCoords;
  HiddenWordDirection wordDirection;
  bool isWordFound;

  /// each boolean value represents if each letter of the hidden word have been found or not. Used in [word_status_indicator]
  List<bool> areLettersFound;
}
