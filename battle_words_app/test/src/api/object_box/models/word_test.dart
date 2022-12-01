import 'package:battle_words/src/api/object_box/models/word.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Testing Word entity', () {
    final word = Word(length: 3, text: "bar");

    test('Word() constructor returns valid Word entity with default id', () {
      final matchLength = 3;
      final matchText = "bar";
      final matchId = 0;

      final actualLength = word.length;
      final actualText = word.text;
      final actualId = word.id;

      expect(actualLength, matchLength);
      expect(actualText, matchText);
      expect(actualId, matchId);
    });

    test('Word.toString() prints a correctly formatted string', () {
      final matchText = "Word{id: 0, text: bar, length: 3}";
      final actualText = word.toString();

      expect(actualText, matchText);
    });
  });
}
