import 'dart:isolate';

import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/game/interface.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/hidden_words/interface.dart';
import 'package:battle_words/src/features/single_player_game/data/sources/isolate/game_manager.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:flutter/material.dart';

void runSinglePlayerGameManager(Map<String, dynamic> data) async {
  final toRepositoryPort = data['toRepositoryPort'];

  final ReceivePort fromRepositoryPort = ReceivePort();
  // final IHiddenWordsRepository hiddenWordsRepository = HiddenWordsRepository(store: store);
  final GameManager manager = GameManager(repositoryPort: toRepositoryPort);

  toRepositoryPort.send(fromRepositoryPort.sendPort);

  fromRepositoryPort.listen(
    (message) {
      //ask to send Store until repository is not null
      if (manager.hiddenWordsRepository == null) {
        toRepositoryPort.send();
      }
      switch (message.runtimeType) {
        case SendObjectBoxStore:
          {
            manager.receiveStore(store: message.store);
            break;
          }
        case GetSinglePlayerGame:
          {
            manager.startSinglePlayerGame();
            break;
          }
        case UpdateGameByTileTap:
          {
            manager.updateGameByTileTap(col: message.col, row: message.row);
            break;
          }
        case UpdateGameByGuessingWord:
          {
            manager.updateGameByGuessingWord(word: message.word);
            break;
          }
        case SetSinglePlayerGame:
          {
            toRepositoryPort.send('set single player game');
            break;
          }
      }
    },
  );
}
