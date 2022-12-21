import 'dart:async';
import 'dart:convert';

import 'package:battle_words/src/api/object_box/models/single_player_game.dart';
import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:flutter/foundation.dart';

class IsolateObjectBoxRepository {
  IsolateObjectBoxRepository({required ObjectBoxStore store}) : _store = store;

  final ObjectBoxStore _store;

  //update state in db
  FutureOr<bool> updateSinglePlayerState(SinglePlayerState singlePlayerGame) {
    try {
      final jsonString = jsonEncode(singlePlayerGame.toJson());

      final updatedState = SinglePlayerGameModel(jsonStringState: jsonString);

      _store.updateSinglePlayerGame(updatedState);
      return true;
    } catch (e) {
      if (kDebugMode) {
        print("=== SinglePlayerWatchRepository: Failed to update state. $e");
      }
      return false;
    }
  }

  //retrieve a state from db

  //delete states
}
