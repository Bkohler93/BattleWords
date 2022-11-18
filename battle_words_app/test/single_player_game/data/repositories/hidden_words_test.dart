import 'package:battle_words/api/object_box/object_box.dart';
import 'package:battle_words/api/object_box/models/word.dart';
import 'package:battle_words/features/single_player_game/data/repositories/hidden_words.dart';
import 'package:battle_words/features/single_player_game/data/sources/hidden_words.dart';
import 'package:battle_words/features/single_player_game/domain/hidden_word.dart';
import 'package:flutter_test/flutter_test.dart';

class MockHiddenWordsObjectBox implements HiddenWordsObjectBox {
  @override
  Future<List<Word>> getRandomWords() {
    return Future.value([
      Word(length: 3, text: "you"),
      Word(length: 4, text: "bear"),
      Word(length: 5, text: "sauce")
    ]);
  }

  @override
  // TODO: implement objectBox
  ObjectBox get objectBox => throw UnimplementedError();
}

void main() {
  group("Testing hiddenWordsRepository.", () {
    test('fetchHiddenWords returns a list of hidden words', () async {
      final hiddenWordsRepository =
          HiddenWordsRepository(hiddenWordsObjectBox: MockHiddenWordsObjectBox());
      final List<HiddenWord> hiddenWords = await hiddenWordsRepository.fetchHiddenWords();

      expect(hiddenWords[0].word, "you");
      expect(hiddenWords[1].word, "bear");
      expect(hiddenWords[2].word, "sauce");
    });
  });
}