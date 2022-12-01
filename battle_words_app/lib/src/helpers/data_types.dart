import 'package:battle_words/src/constants/game_details.dart';
import 'package:battle_words/src/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/src/features/single_player_game/domain/tile_coords.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/keyboard/domain/letter.dart';
import 'package:flutter/material.dart';

typedef GameBoard = List<List<SinglePlayerGameTile>>;
typedef GameBoardRow = List<SinglePlayerGameTile>;
typedef GameBoardTileView = List<List<Widget>>;
typedef KeyboardLetterMap = Map<String, KeyboardLetterStatus>;

GameBoard copyGameBoard(GameBoard gameBoard) {
  return gameBoard.map((GameBoardRow row) => GameBoardRow.from(row)).toList();
}

GameBoard createGameboard() {
  return List.generate(
    GAME_BOARD_SIZE,
    (row) => List.generate(
      GAME_BOARD_SIZE,
      (col) => SinglePlayerGameTile(
        coordinates: TileCoordinates(
          col: col,
          row: row,
        ),
      ),
    ),
  );
}

List<HiddenWord> createMockHiddenWords() {
  return [HiddenWord(word: "yup"), HiddenWord(word: "here"), HiddenWord(word: "sauce")];
}

List<HiddenWord> copyHiddenWords(List<HiddenWord> hiddenWords) {
  return List<HiddenWord>.from(hiddenWords);
}

KeyboardLetterMap createBlankKeyboardLetterMap() => {
      "q": KeyboardLetterStatus.unchecked,
      "w": KeyboardLetterStatus.unchecked,
      "e": KeyboardLetterStatus.unchecked,
      "r": KeyboardLetterStatus.unchecked,
      "t": KeyboardLetterStatus.unchecked,
      "y": KeyboardLetterStatus.unchecked,
      "u": KeyboardLetterStatus.unchecked,
      "i": KeyboardLetterStatus.unchecked,
      "o": KeyboardLetterStatus.unchecked,
      "p": KeyboardLetterStatus.unchecked,
      "a": KeyboardLetterStatus.unchecked,
      "s": KeyboardLetterStatus.unchecked,
      "d": KeyboardLetterStatus.unchecked,
      "f": KeyboardLetterStatus.unchecked,
      "g": KeyboardLetterStatus.unchecked,
      "h": KeyboardLetterStatus.unchecked,
      "j": KeyboardLetterStatus.unchecked,
      "k": KeyboardLetterStatus.unchecked,
      "l": KeyboardLetterStatus.unchecked,
      "z": KeyboardLetterStatus.unchecked,
      "x": KeyboardLetterStatus.unchecked,
      "c": KeyboardLetterStatus.unchecked,
      "v": KeyboardLetterStatus.unchecked,
      "b": KeyboardLetterStatus.unchecked,
      "n": KeyboardLetterStatus.unchecked,
      "m": KeyboardLetterStatus.unchecked,
    };
