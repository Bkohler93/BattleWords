part of 'interface.dart';

class HiddenWordsRepository implements IHiddenWordsRepository {
  HiddenWordsRepository();
  late final ObjectBoxStore store;

  @override
  FutureOr<void> init() async {
    store = await ObjectBoxStore.create();
  }

  @override
  List<HiddenWord> fetchHiddenWords() {
    final List<Word> words = store.getRandomWords();
    for (var word in words) print(word.text);
    return words.map((word) => HiddenWord(word: word.text, letterCoords: {})).toList();
  }

  @override
  bool checkIfValidWord(String word) {
    return store.isWordInDatabase(word);
  }

  void closeStore() {
    store.store.close();
  }
}
