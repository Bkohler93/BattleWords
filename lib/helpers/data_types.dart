import 'package:battle_words/features/single_player_game/domain/single_player_state.dart';
import 'package:flutter/material.dart';

typedef GameBoard = List<List<SinglePlayerGameTile>>;
typedef GameBoardRow = List<SinglePlayerGameTile>;
typedef GameBoardTileView = List<List<Widget>>;

GameBoard copyGameBoard(GameBoard gameBoard) {
  return gameBoard.map((GameBoardRow row) => GameBoardRow.from(row)).toList();
}

List<HiddenWord> copyHiddenWords(List<HiddenWord> hiddenWords) {
  return List<HiddenWord>.from(hiddenWords);
}
