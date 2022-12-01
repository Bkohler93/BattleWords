import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/src/features/single_player_game/domain/tile_coords.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("HiddenWords tests", () {
    test("HiddenWord(word, letterCoords) creates a HiddenWord with default properties", () {
      final matchIsWordFound = false;
      final matchDirection = Direction.unassigned;
      final matchLength = 4;
      final matchWord = "that";
      final matchAreEachLetterNotFound = true;

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
      final direction = Direction.vertical;
      final matchIsVertical = true;
      final actualIsVertical = direction.isVertical;

      expect(actualIsVertical, matchIsVertical);
    });

    test("Direction.isUnassigned returns false on a vertical direction", () {
      final direction = Direction.vertical;
      final matchIsUnassigned = false;
      final actualIsUnassigned = direction.isUnassigned;

      expect(actualIsUnassigned, matchIsUnassigned);
    });
  });
}
