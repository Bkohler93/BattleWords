import 'package:battle_words/src/features/single_player_game/domain/tile_coords.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'hidden_word.g.dart';

@JsonSerializable()
class HiddenWord {
  HiddenWord({
    required this.word,
    this.isWordFound = false,
    this.letterCoords,
    this.direction = Direction.unassigned,
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
  Direction direction;
  bool isWordFound;

  /// each boolean value represents if each letter of the hidden word have been found or not. Used in [word_status_indicator]
  List<bool> areLettersFound;

  factory HiddenWord.fromJson(Map<String, dynamic> json) => _$HiddenWordFromJson(json);
  Map<String, dynamic> toJson() => _$HiddenWordToJson(this);
}

@JsonEnum()
enum Direction {
  @JsonValue('vertical')
  vertical,
  @JsonValue('horizontal')
  horizontal,
  @JsonValue('unassigned')
  unassigned,
}

extension DirectionX on Direction {
  bool get isVertical => this == Direction.vertical;
  bool get isUnassigned => this == Direction.unassigned;
  bool get isHorizontal => this == Direction.horizontal;
}
