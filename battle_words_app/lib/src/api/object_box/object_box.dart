import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:battle_words/src/api/object_box/models/single_player_game.dart';
import 'package:battle_words/src/api/object_box/models/single_player_score.dart';
import 'package:battle_words/src/api/object_box/models/word.dart';
import 'package:battle_words/src/api/object_box/objectbox.g.dart';
import 'package:battle_words/src/constants/api.dart';
import 'package:battle_words/src/constants/hidden_word_exceptions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';

part 'package:battle_words/src/features/single_player_game/data/sources/object_box/word.dart';
part 'package:battle_words/src/features/single_player_game/data/sources/object_box/single_player_score.dart';
part 'package:battle_words/src/features/single_player_game/data/sources/object_box/single_player_game.dart';

abstract class IObjectBoxStore {
  // Future<void> _initialize({ByteData? storeReference});
  ByteData get reference;
  void closeStore();
}

class ObjectBoxStore implements IObjectBoxStore {
  /// This is used when RepositoryProvider provides this instance.
  /// This happens when the app starts so timing **should** not be an issue.
  Store? store;

  late final Box<Word> wordBox;
  late final Box<SinglePlayerScore> singlePlayerScoreBox;
  late final Box<SinglePlayerGameModel> singlePlayerGameBox;
  bool reset = RESET_DATABASE;
  String? directory;

  /// Can not create an instance of ObjectBoxStore with regular constructor
  ObjectBoxStore._();

  @override
  ByteData get reference => store!.reference;

  ObjectBoxStore.createSync({ByteData? storeReference, this.directory}) {
    _initialize(storeReference: storeReference);
  }

  /// Allows for asynchronous initialization. Useful for testing or
  /// creating a store in a separate isolate.
  static Future<ObjectBoxStore> createAsync({ByteData? storeReference}) async {
    final objectBoxStore = ObjectBoxStore._();

    await objectBoxStore._initialize(storeReference: storeReference);

    return objectBoxStore;
  }

  /// Ensures database has been filled with valid words. If not filled, reads the
  /// chosen word list from [assets/wordlists/HIDDEN_WORDS_SOURCE] where HIDDEN_WORDS_SOURCE is a
  /// txt file name.
  Future<void> _initialize({ByteData? storeReference}) async {
    if (reset) {
      Directory dir = await getApplicationDocumentsDirectory();
      Directory('${dir.path}/objectbox/').delete(recursive: true).then((FileSystemEntity value) {
        if (kDebugMode) {
          print("DB Deleted: ${value.existsSync()}");
        }
      });
      reset = false;
    }

    if (storeReference != null) {
      store = Store.fromReference(getObjectBoxModel(), storeReference);
      wordBox = store!.box<Word>();
      singlePlayerScoreBox = store!.box<SinglePlayerScore>();
      singlePlayerGameBox = store!.box<SinglePlayerGameModel>();
    } else if (store == null) {
      if (directory != null) {
        await Directory('$directory').create(recursive: true);
      }
      store = await openStore(directory: directory);
      wordBox = store!.box<Word>();
      singlePlayerScoreBox = store!.box<SinglePlayerScore>();
      singlePlayerGameBox = store!.box<SinglePlayerGameModel>();
    }

    //initial launch, initialize score data to all zeros
    if (wordBox.isEmpty()) {
      final wordString = await rootBundle.loadString("assets/wordlists/$HIDDEN_WORDS_SOURCE");
      final Map<String, dynamic> words = jsonDecode(wordString);
      final List<Word> modelWords =
          List<Word>.from(words.entries.map((model) => Word.fromJson(model)).toList());

      final ids = wordBox.putMany(modelWords);

      singlePlayerScoreBox.put(
        SinglePlayerScore(currentWinStreak: 0, highestScoreStreak: 0, totalGamesWon: 0),
      );
    }

    if (kDebugMode) {
      print('=== database accessed');
    }
  }

  @override
  void closeStore() {
    store!.close();
  }

  void clearAndCloseStore() {
    singlePlayerScoreBox.removeAll();
    wordBox.removeAll();
    singlePlayerGameBox.removeAll();
    store!.close();
  }
}

class MockObjectBoxStore implements IObjectBoxStore {
  MockObjectBoxStore(); //do not call initialize on mock store

  Future<void> _initialize({ByteData? storeReference}) {
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
