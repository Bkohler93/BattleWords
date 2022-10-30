import 'dart:math';

import 'package:battle_words/api/object_box/models/word.dart';
import 'package:battle_words/api/object_box/object_box.dart';
import 'package:battle_words/api/object_box/objectbox.g.dart';
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

    //grab random word from results
    return results[Random().nextInt(results.length - 1)];
  }

  Future<List<Word>> getRandomWords() async {
    return [for (var length = 5; length > 2; length--) _getRandomWordOfLength(length)];
  }
}
