import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:battle_words/src/api/object_box/models/word.dart';
import 'package:battle_words/src/api/object_box/objectbox.g.dart';
import 'package:battle_words/src/constants/api.dart';
import 'package:battle_words/src/constants/hidden_word_exceptions.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

class ObjectBoxStore {
  ObjectBoxStore() {
    _populateDatabase();
  }
  Store? store;
  late final Box<Word> wordBox;
  bool reset = RESET_DATABASE;

  Future<void> _ensureDbOpen() async {
    if (reset) {
      Directory dir = await getApplicationDocumentsDirectory();
      Directory('${dir.path}/objectbox/')
          .delete(recursive: true)
          .then((FileSystemEntity value) => print("DB Deleted: ${value.existsSync()}"));
      reset = false;
    }

    if (store == null) {
      store = await openStore();
      wordBox = store!.box<Word>();
    }
  }

  /// Ensures database has been filled with valid words. If not filled, reads the
  /// chosen word list from [assets/wordlists/HIDDEN_WORDS_SOURCE] where HIDDEN_WORDS_SOURCE is a
  /// txt file name.
  Future<void> _populateDatabase() async {
    await _ensureDbOpen();

    if (wordBox.isEmpty()) {
      final wordString = await rootBundle.loadString("assets/wordlists/$HIDDEN_WORDS_SOURCE");
      final words = jsonDecode(wordString);
      final List<Word> modelWords = [];

      words.forEach((word, length) => modelWords.add(Word(text: word, length: length)));
      print('=== populated database. first word: ${modelWords[0]}');
      final ids = wordBox.putMany(modelWords);
    } else {
      print("=== database already populated");
    }
  }

  Word _getRandomWordOfLength(final int length) {
    final query = (wordBox.query(
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

    return word;
  }

  List<Word> getRandomWords() {
    return [for (var length = 5; length > 2; length--) _getRandomWordOfLength(length)];
  }

  bool isWordInDatabase(String word) {
    final query = (wordBox.query(
      Word_.text.equals(word),
    )).build();
    final results = query.find().isNotEmpty;

    return results;
  }
}
