part of 'package:battle_words/src/api/object_box/object_box.dart';

extension WordAccessor on ObjectBoxStore {
  Word _getRandomWordOfLength(final int length) {
    final query = (wordBox.query(
      Word_.length.equals(length),
    )).build();

    final results = query.find();

    Word word;

    while (true) {
      word = results[Random().nextInt(results.length - 1)];
      if (!HIDDEN_WORDS_EXCEPTIONS.contains(word)) {
        break;
      }
    }

    return word;
  }

  List<Word> getRandomWords() {
    return [for (var length = 5; length > 2; length--) _getRandomWordOfLength(length)];
  }

  bool isWordInDatabase(String word) {
    final query = (wordBox.query(
      Word_.text.equals(word),
    )).build();
    final results = query.find().isNotEmpty;

    return results;
  }
}
