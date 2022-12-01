import 'package:battle_words/src/features/single_player_game/domain/tile_coords.dart';
import 'package:flutter/material.dart';

enum TileStatus { hidden, empty, letterFound, wordFound }

extension TileStatusX on TileStatus {
  bool get isHidden => this == TileStatus.hidden;
  bool get isEmpty => this == TileStatus.empty;
  bool get isLetterFound => this == TileStatus.letterFound;
  bool get isWordFound => this == TileStatus.wordFound;
}

@immutable
class SinglePlayerGameTile {
  final TileCoordinates coordinates;
  final TileStatus tileStatus;
  final String letter;

  const SinglePlayerGameTile({
    required this.coordinates,
    this.tileStatus = TileStatus.hidden,
    this.letter = '',
  });

  factory SinglePlayerGameTile.from(SinglePlayerGameTile gameTile) {
    return SinglePlayerGameTile(
      coordinates: gameTile.coordinates,
      tileStatus: gameTile.tileStatus,
      letter: gameTile.letter,
    );
  }

  bool isEmpty() => letter.isEmpty;
  bool isNotEmpty() => letter.isNotEmpty;
}

extension MutableSinglePlayerGameTile on SinglePlayerGameTile {
  /// uncovers tile to display the correct status after replacing
  /// existing status (most likely [TileStatus.hidden]) to a correct
  /// status reflecting whether a letter is present or not.
  SinglePlayerGameTile uncover(TileStatus status) {
    return SinglePlayerGameTile(
      coordinates: coordinates,
      tileStatus: status,
      letter: letter,
    );
  }

  SinglePlayerGameTile setLetter(String newLetter) {
    return SinglePlayerGameTile(
      coordinates: coordinates,
      tileStatus: tileStatus,
      letter: newLetter,
    );
  }
}
