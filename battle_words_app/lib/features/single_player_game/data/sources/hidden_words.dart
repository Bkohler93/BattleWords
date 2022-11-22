import 'dart:math';

import 'package:battle_words/api/object_box/models/word.dart';
import 'package:battle_words/api/object_box/object_box.dart';
import 'package:battle_words/api/object_box/objectbox.g.dart';
import 'package:battle_words/constants/hidden_word_exceptions.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final hiddenWordsObjectBoxProvider = Provider<HiddenWordsObjectBox>(
  (ref) => HiddenWordsObjectBox(objectBox: ref.watch(objectBoxProvider)),
);

class HiddenWordsObjectBox {
  HiddenWordsObjectBox({required this.objectBox});
  final ObjectBox objectBox;

  Word _getRandomWordOfLength(final int length) {
    //query for words of length 'length'
    final query = (objectBox.wordBox.query(
      Word_.length.equals(length),
    )).build();
    final results = query.find();

    var word;

    while (true) {
      word = results[Random().nextInt(results.length - 1)];
      if (!HIDDEN_WORDS_EXCEPTIONS.contains(word)) {
        break;
      }
    }

    //grab random word from results
    return word;
  }

  List<Word> getRandomWords() {
    return [for (var length = 5; length > 2; length--) _getRandomWordOfLength(length)];
  }

  bool isWordInDatabase(String word) {
    final query = (objectBox.wordBox.query(
      Word_.text.equals(word),
    )).build();
    final result = query.find().isNotEmpty;

    return result;
  }
}
