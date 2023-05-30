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
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';

part 'package:battle_words/src/features/single_player_game/data/sources/object_box/word.dart';
part 'package:battle_words/src/features/single_player_game/data/sources/object_box/single_player_score.dart';
part 'package:battle_words/src/features/single_player_game/data/sources/object_box/single_player_game.dart';

abstract class IObjectBoxStore {
  // Future<void> _initialize({ByteData? storeReference});
  ByteData get reference;
  void closeStore();
}
// var storeProvider = Provider<ObjectBoxStore>((ref) => )

class ObjectBoxStore implements IObjectBoxStore {
  /// This is used when RepositoryProvider provides this instance.
  /// This happens when the app starts so timing **should** not be an issue.
  Store? _store;

  late final Box<Word> wordBox;
  late final Box<SinglePlayerScore> singlePlayerScoreBox;
  late final Box<SinglePlayerGameModel> singlePlayerGameBox;
  bool reset = RESET_DATABASE;
  String? directory;

  @override
  ByteData get reference => _store!.reference;

  /// Ensures database has been filled with valid words. If not filled, reads the
  /// chosen word list from [assets/wordlists/HIDDEN_WORDS_SOURCE] where HIDDEN_WORDS_SOURCE is a
  /// txt file name.
  Future<void> initialize({ByteData? storeReference}) async {
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
      _store = Store.fromReference(getObjectBoxModel(), storeReference);
      wordBox = _store!.box<Word>();
      singlePlayerScoreBox = _store!.box<SinglePlayerScore>();
      singlePlayerGameBox = _store!.box<SinglePlayerGameModel>();
    } else if (_store != null) {
      print("store already open");
    } else {
      if (directory != null) {
        await Directory('$directory').create(recursive: true);
      }
      _store = await openStore(directory: directory);
      wordBox = _store!.box<Word>();
      singlePlayerScoreBox = _store!.box<SinglePlayerScore>();
      singlePlayerGameBox = _store!.box<SinglePlayerGameModel>();
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
    _store!.close();
  }

  void clearAndCloseStore() {
    singlePlayerScoreBox.removeAll();
    wordBox.removeAll();
    singlePlayerGameBox.removeAll();
    _store!.close();
  }
}

class MockObjectBoxStore implements IObjectBoxStore {
  MockObjectBoxStore(); //do not call initialize on mock _store

  Future<void> _initialize() {
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

final objectBoxStoreProvider = Provider<ObjectBoxStore>((ref) {
  final objectBoxStore = ObjectBoxStore();
  ref.onDispose(
      () => objectBoxStore.closeStore()); // Dispose the store when the provider is disposed
  return objectBoxStore;
});
