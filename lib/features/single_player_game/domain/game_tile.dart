import 'package:flutter/material.dart';

@immutable
class SinglePlayerGameTile {
  final int col;
  final int row;
  final bool isCovered;

  const SinglePlayerGameTile({required this.row, required this.col, bool? isCovered})
      : isCovered = isCovered ?? true;

  factory SinglePlayerGameTile.from(SinglePlayerGameTile gameTile) {
    return SinglePlayerGameTile(
      row: gameTile.row,
      col: gameTile.col,
      isCovered: gameTile.isCovered,
    );
  }
}

extension MutableSinglePlayerGameTile on SinglePlayerGameTile {
  SinglePlayerGameTile flip() {
    return SinglePlayerGameTile(row: row, col: col, isCovered: !isCovered);
  }
}
