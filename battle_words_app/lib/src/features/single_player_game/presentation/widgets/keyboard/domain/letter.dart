enum KeyboardLetterStatus { unchecked, complete, incomplete, empty, error }

class KeyboardLetter {
  KeyboardLetter({required this.text, required this.letterStatus});
  final String text;
  final KeyboardLetterStatus letterStatus;
}
