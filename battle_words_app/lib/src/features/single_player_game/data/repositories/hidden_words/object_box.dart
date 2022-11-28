part of 'interface.dart';

class HiddenWordsRepository implements IHiddenWordsRepository {
  HiddenWordsRepository({required this.store});
  final ObjectBoxStore store;

  @override
  List<HiddenWord> fetchHiddenWords() {
    final List<Word> words = store.getRandomWords();
    for (var word in words) print(word.text);
    return words.map((word) => HiddenWord(word: word.text)).toList();
  }

  @override
  bool checkIfValidWord(String word) {
    return store.isWordInDatabase(word);
  }

  void closeStore() {
    store.store!.close();
  }
}
