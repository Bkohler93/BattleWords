import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:battle_words/src/api/object_box/models/single_player_score.dart';
import 'package:battle_words/src/api/object_box/models/word.dart';
import 'package:battle_words/src/api/object_box/objectbox.g.dart';
import 'package:battle_words/src/constants/api.dart';
import 'package:battle_words/src/constants/hidden_word_exceptions.dart';
import 'package:flutter/services.dart';
import 'package:objectbox/objectbox.dart';
import 'package:path_provider/path_provider.dart';

part 'package:battle_words/src/features/single_player_game/data/sources/object_box/word.dart';
part 'package:battle_words/src/features/single_player_game/data/sources/object_box/single_player_score.dart';

abstract class IObjectBoxStore {
  Future<void> _initialize({ByteData? storeReference});
  ByteData get reference;
}

class ObjectBoxStore implements IObjectBoxStore {
  ObjectBoxStore({ByteData? storeReference}) {
    _initialize(storeReference: storeReference);
  }
  Store? store;

  late final Box<Word> wordBox;
  late final Box<SinglePlayerScore> singlePlayerScoreBox;
  bool reset = RESET_DATABASE;

  @override
  ByteData get reference => store!.reference;

  /// Ensures database has been filled with valid words. If not filled, reads the
  /// chosen word list from [assets/wordlists/HIDDEN_WORDS_SOURCE] where HIDDEN_WORDS_SOURCE is a
  /// txt file name.
  @override
  Future<void> _initialize({ByteData? storeReference}) async {
    if (reset) {
      Directory dir = await getApplicationDocumentsDirectory();
      Directory('${dir.path}/objectbox/')
          .delete(recursive: true)
          .then((FileSystemEntity value) => print("DB Deleted: ${value.existsSync()}"));
      reset = false;
    }

    if (storeReference != null) {
      store = Store.fromReference(getObjectBoxModel(), storeReference);
      wordBox = store!.box<Word>();
      singlePlayerScoreBox = store!.box<SinglePlayerScore>();
    } else if (store == null) {
      store = await openStore();
      wordBox = store!.box<Word>();
      singlePlayerScoreBox = store!.box<SinglePlayerScore>();
    }

    //initial launch, initialize score data to all zeros
    if (wordBox.isEmpty()) {
      final wordString = await rootBundle.loadString("assets/wordlists/$HIDDEN_WORDS_SOURCE");
      final words = jsonDecode(wordString);
      final List<Word> modelWords = [];

      words.forEach((word, length) => modelWords.add(Word(text: word, length: length)));
      print('=== populated database. first word: ${modelWords[0]}');
      final ids = wordBox.putMany(modelWords);

      singlePlayerScoreBox.put(
        SinglePlayerScore(currentWinStreak: 0, highestScoreStreak: 0, totalGamesWon: 0),
      );
    }

    print('=== database opened');
  }
}

class MockObjectBoxStore implements IObjectBoxStore {
  @override
  Word _getRandomWordOfLength(int length) {
    return Word(
      length: length,
      text: length == 3
          ? 'hut'
          : length == 4
              ? 'that'
              : 'there',
    );
  }

  @override
  Future<void> _populateDatabase() {
    throw UnimplementedError();
  }

  @override
  List<Word> getRandomWords() {
    return [
      Word(length: 3, text: 'bye'),
      Word(length: 4, text: 'that'),
      Word(length: 5, text: 'there')
    ];
  }

  @override
  bool isWordInDatabase(String word) {
    return true;
  }

  @override
  // TODO: implement reference
  ByteData get reference => throw UnimplementedError();

  @override
  Future<void> _initialize({ByteData? storeReference}) {
    // TODO: implement _initialize
    throw UnimplementedError();
  }

  @override
  Box<SinglePlayerScore> getSinglePlayerScoreBox() {
    // TODO: implement getSinglePlayerScoreBox
    throw UnimplementedError();
  }
}
