import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("HiddenWords tests", () {
    test("HiddenWord(word, letterCoords) creates a HiddenWord with default properties", () {
      const matchIsWordFound = false;
      const matchDirection = Direction.unassigned;
      const matchLength = 4;
      const matchWord = "that";
      const matchAreEachLetterNotFound = true;

      final hiddenWord = HiddenWord(word: "that");
      final actualIsWordFound = hiddenWord.isWordFound;
      final actualDirection = hiddenWord.direction;
      final actualLength = hiddenWord.length;
      final actualWord = hiddenWord.word;
      final actualMatchAreEachLetterNotFound =
          hiddenWord.areLettersFound.every((isLetterFound) => isLetterFound == false);

      expect(actualMatchAreEachLetterNotFound, matchAreEachLetterNotFound);
      expect(actualWord, actualWord);
      expect(actualLength, matchLength);
      expect(actualIsWordFound, matchIsWordFound);
      expect(actualDirection, matchDirection);
    });
  });

  group("Direction enum tests", () {
    test("Direction.isVertical returns true on a vertical direction", () {
      const direction = Direction.vertical;
      const matchIsVertical = true;
      final actualIsVertical = direction.isVertical;

      expect(actualIsVertical, matchIsVertical);
    });

    test("Direction.isUnassigned returns false on a vertical direction", () {
      const direction = Direction.vertical;
      const matchIsUnassigned = false;
      final actualIsUnassigned = direction.isUnassigned;

      expect(actualIsUnassigned, matchIsUnassigned);
    });
  });
}
