class HiddenWord {
  const HiddenWord({required this.word, this.found = false}) : length = word.length;

  final String word;
  final int length;
  final bool found;
}
