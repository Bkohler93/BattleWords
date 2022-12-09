import 'dart:async';
import 'dart:convert';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:battle_words/src/api/object_box/models/single_player_game.dart';
import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/game/interface.dart';
import 'package:battle_words/src/features/single_player_game/data/sources/isolate/isolate.dart';
import 'package:battle_words/src/features/single_player_game/data/sources/isolate/request_object.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';

class SinglePlayerWatchRepository implements ISinglePlayerRepository {
  SinglePlayerWatchRepository({required ObjectBoxStore store, ByteData? storeReference})
      : _store = store,
        _storeReference = storeReference;

  final ObjectBoxStore _store;
  final ByteData? _storeReference;
  late final SendPort toGameManagerPort;

  @override
  void dispose() {
    // TODO: implement dispose
  }

  @override
  //listens for updates from the database for whenever the game state updates.
  Stream<SinglePlayerState> get gameStateStream => _store
      .listenForGameChanges()
      .map((event) => SinglePlayerState.fromJson(jsonDecode(event.jsonStringState!)));

  @override
  void getSinglePlayerGame() {
    // TODO: implement getSinglePlayerGame
  }

  @override
  //starts up isolate to handle all game events from UI and update state in db accordingly
  Future<void> init() async {
    final ReceivePort fromGameManagerPort = ReceivePort();

    final gameManagerData = {
      'gameManagerToRepositoryPort': fromGameManagerPort.sendPort,
      'objectBoxReference': _storeReference
    };

    await Isolate.spawn(runSinglePlayerGameManager, gameManagerData);

    toGameManagerPort = await fromGameManagerPort.first;

    print("=== (SinglePlayerGameRepository): received response from GameManager");
  }

  @override
  // TODO: implement isIsolateConnectedStream
  Stream<bool> get isIsolateConnectedStream => throw UnimplementedError();

  @override
  //called form isolate to update state in db
  FutureOr<bool> setSinglePlayerGame(SinglePlayerState singlePlayerGame) {
    try {
      final jsonString = jsonEncode(singlePlayerGame.toJson());

      final updatedState = SinglePlayerGameModel(jsonStringState: jsonString);

      _store.updateSinglePlayerGame(updatedState);
      return true;
    } catch (e) {
      print("=== SinglePlayerWatchRepository: Failed to update state. $e");
      return false;
    }
  }

  @override
  FutureOr<void> updateGameByGuessingWord({required String word}) {
    final request = UpdateGameByGuessingWord(word: word);
    toGameManagerPort.send(request);
  }

  @override
  FutureOr<void> updateGameByTileTap({required int col, required int row}) {
    final request = UpdateGameByTileTap(col: col, row: row);

    toGameManagerPort.send(request);
  }
}
