import 'dart:isolate';

import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/game/interface.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/hidden_words/interface.dart';
import 'package:battle_words/src/features/single_player_game/data/sources/isolate/game_manager.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:flutter/material.dart';

void printIsolate(String message) {
  print('(manager isolate): $message');
}

void runSinglePlayerGameManager(Map<String, dynamic> data) async {
  //extract port and ObjectBox store reference from main isolate
  final toRepositoryPort = data['gameManagerToRepositoryPort'];
  final objectBoxReference = data['objectBoxReference'];

  final ReceivePort fromRepositoryPort = ReceivePort();

  //create repository for GameManager to retrieve words from
  final objectBoxStore = ObjectBoxStore(storeReference: objectBoxReference);
  final IHiddenWordsRepository hiddenWordsRepository = HiddenWordsRepository(store: objectBoxStore);

  GameManager(
    toRepositoryPort: toRepositoryPort,
    hiddenWordsRepository: hiddenWordsRepository,
    fromRepositoryPort: fromRepositoryPort,
  );
}
