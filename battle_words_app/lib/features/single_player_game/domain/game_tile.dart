import 'package:flutter/material.dart';

@immutable
class SinglePlayerGameTile {
  final int col;
  final int row;
  final bool isCovered;
  final String letter;

  const SinglePlayerGameTile({
    required this.row,
    required this.col,
    this.isCovered = true,
    this.letter = '',
  });

  factory SinglePlayerGameTile.from(SinglePlayerGameTile gameTile) {
    return SinglePlayerGameTile(
      row: gameTile.row,
      col: gameTile.col,
      isCovered: gameTile.isCovered,
      letter: gameTile.letter,
    );
  }

  bool isEmpty() => letter.isEmpty;
}

extension MutableSinglePlayerGameTile on SinglePlayerGameTile {
  SinglePlayerGameTile flip() {
    return SinglePlayerGameTile(
      row: row,
      col: col,
      isCovered: !isCovered,
      letter: letter,
    );
  }

  SinglePlayerGameTile setLetter(String newLetter) {
    return SinglePlayerGameTile(
      col: col,
      row: row,
      isCovered: isCovered,
      letter: newLetter,
    );
  }
}
