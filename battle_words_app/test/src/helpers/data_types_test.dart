import 'package:battle_words/src/constants/game_details.dart';
import 'package:battle_words/src/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/src/features/single_player_game/domain/tile_coords.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/keyboard/domain/letter.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/keyboard/presentation/keyboard.dart';
import 'package:battle_words/src/helpers/data_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('copyGameBoard returns a copy of an existing GameBoard', () {
    final gameBoard = List.generate(
        GAME_BOARD_SIZE,
        (row) => List.generate(GAME_BOARD_SIZE,
            (col) => SinglePlayerGameTile(coordinates: TileCoordinates(col: col, row: row))));

    final gameBoardCopy = copyGameBoard(gameBoard);

    final matchNumRows = GAME_BOARD_SIZE;
    final matchNumCols = GAME_BOARD_SIZE;

    final actualNumRows = gameBoard.length;
    final actualNumCols = gameBoard[0].length;

    expect(actualNumCols, matchNumCols);
    expect(actualNumRows, matchNumRows);
  });

  test('copyHiddenWords returns a copy of an existing List of HiddenWords', () {
    final List<HiddenWord> hiddenWords = [
      HiddenWord(word: 'bat'),
      HiddenWord(word: 'foot'),
      HiddenWord(word: 'catch')
    ];

    final hiddenWordsCopy = copyHiddenWords(hiddenWords);

    final matchWords = ['bat', 'foot', 'catch'];
    final actualWords =
        List.generate(hiddenWordsCopy.length, (index) => hiddenWordsCopy[index].word);

    expect(actualWords, matchWords);
  });

  test(
      'createBlankKeyboardLetterMap() returns a KeyboardLetterMap with correct number of keys and correct letters',
      () {
    final testKeyboardLetterMap = createBlankKeyboardLetterMap();

    final matchNumLetters = 26;
    final matchLetterStatusForEachKey = KeyboardLetterStatus.unchecked;
    final matchLetters = "qwertyuiopasdfghjklzxcvbnm";

    final actualNumLetters = testKeyboardLetterMap.length;
    final actualLetterStatusForEachKey = testKeyboardLetterMap.values.fold(
        KeyboardLetterStatus.unchecked,
        ((previousValue, element) => previousValue == KeyboardLetterStatus.unchecked &&
                element == KeyboardLetterStatus.unchecked
            ? KeyboardLetterStatus.unchecked
            : KeyboardLetterStatus.error));
    final actualLetters = testKeyboardLetterMap.keys.toList().join();

    expect(actualLetters, matchLetters,
        reason: 'KeyboardLetterMap should have all characters of the alphabet');
    expect(actualLetterStatusForEachKey, matchLetterStatusForEachKey,
        reason: "KeyboardLetterMap should initialize all keys to KeyboardLetterStatus.unchecked");
    expect(actualNumLetters, matchNumLetters,
        reason: "KeyboardLetterMap should have every letter of the alphabet, so 26 letters.");
  });
}
