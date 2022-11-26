import 'dart:math';

import 'package:battle_words/src/api/object_box/models/word.dart';
import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/api/object_box/objectbox.g.dart';
import 'package:battle_words/src/constants/hidden_word_exceptions.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';

class HiddenWordsRepository {
  HiddenWordsRepository({required this.store});
  final ObjectBoxStore store;

  List<HiddenWord> fetchHiddenWords() {
    final List<Word> words = store.getRandomWords();
    for (var word in words) print(word.text);
    return words.map((word) => HiddenWord(word: word.text)).toList();
  }

  bool checkIfValidWord(String word) {
    return store.isWordInDatabase(word);
  }
}

class MockHiddenWordsRepository implements HiddenWordsRepository {
  MockHiddenWordsRepository({required this.store});
  final ObjectBoxStore store;
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
