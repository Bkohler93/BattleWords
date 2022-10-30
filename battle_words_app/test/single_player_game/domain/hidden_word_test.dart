import 'package:battle_words/features/single_player_game/domain/hidden_word.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test HiddenWord model', () {
    test('constructor creates a HiddenWord with its found property set to false', () {
      final hiddenWord = HiddenWord(word: "sauce");

      expect(hiddenWord.found, false);
      expect(hiddenWord.word, "sauce");
    });

    test(
        'constructor results in a length property equal to the length of the string entered as word property',
        () {
      final hiddenWord = HiddenWord(word: "sauce");

      final expected = 5;
      final test = hiddenWord.length;

      expect(test, expected);
    });
  });
}
