import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:battle_words/api/object_box/models/word.dart';
import 'package:battle_words/api/object_box/objectbox.g.dart';
import 'package:battle_words/constants/api.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

final objectBoxProvider = Provider<ObjectBox>((ref) => ObjectBox());

class ObjectBox {
  ObjectBox();
  Store? store;
  late final Box<Word> wordBox;
  bool reset = RESET_DATABASE;

  Future<void> _ensureDbOpen() async {
    if (reset) {
      Directory dir = await getApplicationDocumentsDirectory();
      Directory(dir.path + '/objectbox/')
          .delete(recursive: true)
          .then((FileSystemEntity value) => print("DB Deleted: ${value.existsSync()}"));
      reset = false;
    }

    if (store == null) {
      store = await openStore();
      wordBox = store!.box<Word>();
    }
  }

  @override
  Future<void> populateDatabase() async {
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
}
