import 'package:battle_words/constants/game_details.dart';
import 'package:battle_words/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/helpers/data_types.dart';
import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test SinglePlayerGame model', () {
    test('All properties of game board  are correct types', () {
      SinglePlayerGame singlePlayerGame = SinglePlayerGame.generate();
      expect(singlePlayerGame.gameBoard, isA<GameBoard>());

      expect(singlePlayerGame.hiddenWords, isA<List<HiddenWord>>());
      expect(singlePlayerGame.movesRemaining, isA<int>());
    });

    test('Uncovering top left tile results in that tile being uncovered', () {
      SinglePlayerGame singlePlayerGame = SinglePlayerGame.generate();
      var row = 0;
      var col = 0;
      singlePlayerGame = singlePlayerGame.flipTile(row: row, col: col);

      expect(singlePlayerGame.isTileCovered(row: row, col: col), false);
    });

    test('Reduce number of moves remaining', () {
      SinglePlayerGame singlePlayerGame = SinglePlayerGame.generate();
      expect(singlePlayerGame.movesRemaining, START_NUM_OF_MOVES,
          reason: "Expect maximum number of moves at start");

      singlePlayerGame = singlePlayerGame.reduceMovesRemaining();

      expect(singlePlayerGame.movesRemaining, START_NUM_OF_MOVES - 1,
          reason: "movesRemaining decremented after reduceMovesRemaining is called");
    });

    test('Hidden words have hardcoded values', () {
      SinglePlayerGame singlePlayerGame = SinglePlayerGame.generate();
      List<HiddenWord> expectedHiddenWords = [
        HiddenWord(word: HARD_CODED_WORDS[0]),
        HiddenWord(word: HARD_CODED_WORDS[1]),
        HiddenWord(word: HARD_CODED_WORDS[2]),
      ];
      expect(singlePlayerGame.hiddenWords[0].word, expectedHiddenWords[0].word);
      expect(singlePlayerGame.hiddenWords[1].word, expectedHiddenWords[1].word);
      expect(singlePlayerGame.hiddenWords[2].word, expectedHiddenWords[2].word);
    });

    test('isTileCovered returns true on a tile that is covered.', () {
      final singlePlayerGame = SinglePlayerGame.generate();

      final expected = true;
      final test = singlePlayerGame.isTileCovered(row: 0, col: 0);

      expect(test, expected);
    });

    test('isTileCovered returns false on a tile that is not covered.', () {
      var singlePlayerGame = SinglePlayerGame.generate();

      final expected = false;
      singlePlayerGame = singlePlayerGame.flipTile(row: 0, col: 0);
      final test = singlePlayerGame.isTileCovered(row: 0, col: 0);

      expect(test, expected);
    });
  });
}
