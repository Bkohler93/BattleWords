import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:battle_words/src/api/object_box/models/single_player_score.dart';
import 'package:battle_words/src/api/object_box/models/word.dart';
import 'package:battle_words/src/api/object_box/objectbox.g.dart';
import 'package:battle_words/src/constants/api.dart';
import 'package:battle_words/src/constants/hidden_word_exceptions.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

part 'package:battle_words/src/features/single_player_game/data/sources/object_box/word.dart';
part 'package:battle_words/src/features/single_player_game/data/sources/object_box/single_player_score.dart';

abstract class IObjectBoxStore {
  Future<void> _initialize(/* {ByteData? storeReference} */ String? directory);
  // ByteData get reference;
  void closeStore();
}

class ObjectBoxStore implements IObjectBoxStore {
  ObjectBoxStore();
  late final Store store;

  /// Two Boxes: box of words to be used as hidden words/guess words, and a Box containing the user's score history.
  late final Box<Word> wordBox;
  late final Box<SinglePlayerScore> singlePlayerScoreBox;

  /// Reset to be used when db changes have been made
  bool reset = RESET_DATABASE;

  /// directory used mainly for testing, may not be needed?
  // String? directory;

  // @override
  // ByteData get reference => store!.reference;

  static Future<ObjectBoxStore> create({String? directory}) async {
    final objectBoxStore = ObjectBoxStore();

    await objectBoxStore._initialize(directory);

    return objectBoxStore;
  }

  /// Ensures database has been filled with valid words. If not filled, reads the
  /// chosen word list from [assets/wordlists/HIDDEN_WORDS_SOURCE] where HIDDEN_WORDS_SOURCE is a
  /// txt file name.
  @override
  Future<void> _initialize(/* {ByteData? storeReference} */ String? directory) async {
    late String objectBoxPath;
    if (directory != null) {
      objectBoxPath = directory;
    } else {
      Directory appDir = await getApplicationDocumentsDirectory();
      objectBoxPath = '${appDir.path}/objectbox/';
    }

    if (reset) {
      Directory(objectBoxPath)
          .delete(recursive: true)
          .then((FileSystemEntity value) => print("DB Deleted: ${value.existsSync()}"));
      reset = false;
    }

    if (!Directory(objectBoxPath).existsSync()) {
      await Directory(objectBoxPath).create(recursive: true);
    }

    if (Store.isOpen(objectBoxPath)) {
      store = Store.attach(getObjectBoxModel(), directory);
    } else {
      store = await openStore(directory: directory);
    }
    wordBox = store.box<Word>();
    singlePlayerScoreBox = store.box<SinglePlayerScore>();

    /// On initial launch will create a database for words as well as initialize player score data to all zeros.
    if (wordBox.isEmpty()) {
      final wordString = await rootBundle.loadString("assets/wordlists/$HIDDEN_WORDS_SOURCE");
      final Map<String, dynamic> words = jsonDecode(wordString);
      final List<Word> modelWords =
          List<Word>.from(words.entries.map((model) => Word.fromJson(model)).toList());

      wordBox.putMany(modelWords);

      singlePlayerScoreBox.put(
        SinglePlayerScore(currentWinStreak: 0, highestScoreStreak: 0, totalGamesWon: 0),
      );
    }

    print('=== (ObjectBoxStore): database initialized');
  }

  @override
  void closeStore() {
    store.close();
  }

  void clearAndCloseStore() {
    singlePlayerScoreBox.removeAll();
    wordBox.removeAll();
    store.close();
  }
}

class MockObjectBoxStore implements IObjectBoxStore {
  MockObjectBoxStore(); //do not call initialize on mock store

  @override
  Future<void> _initialize(String? directlry, {ByteData? storeReference}) {
    throw UnimplementedError();
  }

  @override
  // TODO: implement reference
  ByteData get reference => throw UnimplementedError();

  @override
  void closeStore() {
    // TODO: implement closeStore
  }
}
