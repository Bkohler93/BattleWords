import 'package:battle_words/api/object_box/models/word.dart';
import 'package:battle_words/features/single_player_game/data/sources/hidden_words.dart';
import 'package:battle_words/features/single_player_game/domain/hidden_word.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hiddenWordsRepositoryProvider = Provider<HiddenWordsRepository>(
    (ref) => HiddenWordsRepository(hiddenWordsObjectBox: ref.watch(hiddenWordsObjectBoxProvider)));

abstract class IHiddenWordsRepository {
  Future<List<HiddenWord>> fetchHiddenWords();
}

class HiddenWordsRepository implements IHiddenWordsRepository {
  HiddenWordsRepository({required this.hiddenWordsObjectBox});
  final HiddenWordsObjectBox hiddenWordsObjectBox;

  @override
  Future<List<HiddenWord>> fetchHiddenWords() async {
    final List<Word> words = await hiddenWordsObjectBox.getRandomWords();
    for (var word in words) print(word.text);
    return words.map((word) => HiddenWord(word: word.text)).toList();
  }
}

class MockHiddenWordsRepository implements IHiddenWordsRepository {
  @override
  Future<List<HiddenWord>> fetchHiddenWords() {
    final List<Word> words = [
      Word(length: 3, text: 'you'),
      Word(length: 4, text: "ball"),
      Word(length: 5, text: "sauce")
    ];
    return Future.value(words.map((word) => HiddenWord(word: word.text)).toList());
  }
}
