part of 'interface.dart';

class HiddenWordsRepository implements IHiddenWordsRepository {
  HiddenWordsRepository({required this.store});
  final ObjectBoxStore store;

  @override
  List<HiddenWord> fetchHiddenWords() {
    final List<Word> words = store.getRandomWords();
    for (var word in words) {
      if (kDebugMode) {
        print(word.text);
      }
    }
    return words.map((word) => HiddenWord(word: word.text, letterCoords: {})).toList();
  }

  @override
  bool checkIfValidWord(String word) {
    return store.isWordInDatabase(word);
  }

  @override
  void closeStore() {
    store.store!.close();
  }
}
