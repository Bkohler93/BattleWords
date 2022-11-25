import 'package:battle_words/src/api/object_box/models/word.dart';
import 'package:battle_words/src/features/single_player_game/data/sources/hidden_words.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hiddenWordsRepositoryProvider = Provider<HiddenWordsRepository>(
    (ref) => HiddenWordsRepository(hiddenWordsObjectBox: ref.watch(hiddenWordsObjectBoxProvider)));

abstract class IHiddenWordsRepository {
  List<HiddenWord> fetchHiddenWords();
  bool checkIfValidWord(String word);
}

class HiddenWordsRepository implements IHiddenWordsRepository {
  HiddenWordsRepository({required this.hiddenWordsObjectBox});
  final HiddenWordsObjectBox hiddenWordsObjectBox;

  @override
  List<HiddenWord> fetchHiddenWords() {
    final List<Word> words = hiddenWordsObjectBox.getRandomWords();
    for (var word in words) print(word.text);
    return words.map((word) => HiddenWord(word: word.text)).toList();
  }

  @override
  bool checkIfValidWord(String word) {
    return hiddenWordsObjectBox.isWordInDatabase(word);
  }
}

class MockHiddenWordsRepository implements IHiddenWordsRepository {
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
}
