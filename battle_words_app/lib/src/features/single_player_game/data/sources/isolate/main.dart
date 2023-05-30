import 'dart:isolate';

import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/hidden_words/interface.dart';
import 'package:battle_words/src/features/single_player_game/data/sources/isolate/game_manager.dart';
import 'package:battle_words/src/features/single_player_game/data/sources/isolate/object_box_repository.dart';
import 'package:flutter/foundation.dart';

void printIsolate(String message) {
  if (kDebugMode) {
    print('(manager isolate): $message');
  }
}

void runSinglePlayerGameManager(Map<String, dynamic> data) async {
  try {
    //extract port and ObjectBox store reference from main isolate
    final toRepositoryPort = data['gameManagerToRepositoryPort'];
    final objectBoxReference = data['objectBoxReference'];

    final ReceivePort fromRepositoryPort = ReceivePort();

    final objectBoxStore = ObjectBoxStore();
    //create repository for GameManager to retrieve words from
    await objectBoxStore.initialize(storeReference: objectBoxReference);
    final IHiddenWordsRepository hiddenWordsRepository =
        HiddenWordsRepository(store: objectBoxStore);

    final objectBoxRepository = IsolateObjectBoxRepository(store: objectBoxStore);

    GameManager(
      toRepositoryPort: toRepositoryPort,
      hiddenWordsRepository: hiddenWordsRepository,
      fromRepositoryPort: fromRepositoryPort,
      objectBoxRepository: objectBoxRepository,
    );
  } catch (err) {
    printIsolate(err.toString());
  }
}
