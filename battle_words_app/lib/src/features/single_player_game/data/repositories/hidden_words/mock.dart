part of 'interface.dart';

class MockHiddenWordsRepository implements IHiddenWordsRepository {
  MockHiddenWordsRepository();

  @override
  List<HiddenWord> fetchHiddenWords() {
    final List<Word> words = [
      Word(length: 3, text: 'you'),
      Word(length: 4, text: "ball"),
      Word(length: 5, text: "sauce")
    ];
    return words.map((word) => HiddenWord(word: word.text)).toList();
  }

  @override
  bool checkIfValidWord(String word) {
    return true;
  }

  @override
  void closeStore() {
    // TODO: implement closeStore
  }
}
