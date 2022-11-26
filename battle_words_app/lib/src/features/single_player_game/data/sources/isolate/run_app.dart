import 'dart:isolate';

import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/game/interface.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/hidden_words/interface.dart';
import 'package:battle_words/src/features/single_player_game/data/sources/isolate/game_manager.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';

void runSinglePlayerGameManager(Map<String, dynamic> portData) async {
  final toRepositoryPort = portData['repository'];

  final ReceivePort fromRepositoryPort = ReceivePort();
  final IObjectBoxStore store = MockObjectBoxStore();
  final IHiddenWordsRepository hiddenWordsRepository = MockHiddenWordsRepository();
  final GameManager manager =
      GameManager(hiddenWordsRepository: hiddenWordsRepository, repositoryPort: toRepositoryPort);

  toRepositoryPort.send(fromRepositoryPort.sendPort);

  fromRepositoryPort.listen(
    (message) {
      switch (message.runtimeType) {
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
