import 'package:battle_words/features/single_player_game/domain/hidden_word.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('test HiddenWord model', () {
    test('constructor creates a HiddenWord with its found property set to false', () {
      final hiddenWord = HiddenWord(word: "sauce");

      expect(hiddenWord.found, false);
      expect(hiddenWord.word, "sauce");
    });
  });
}
