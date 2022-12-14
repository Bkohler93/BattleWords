import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/data/sources/isolate/request_object.dart';
import 'package:battle_words/src/features/single_player_game/data/sources/isolate/main.dart';
import 'package:battle_words/src/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/src/features/single_player_game/domain/tile_coords.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:flutter/foundation.dart';

part 'mock.dart';
part 'object_box.dart';

///  This is an interface for the single player game repository
///  Future expansions on this project may have to retrieve game states from external API calls. Implement a new repository in this case.
///
/// calls do not return new states. each "getXxx/setXxx/updateXxx" sends a
/// request object to the isolate/server and then the gameStateStream receives the response
/// from the isolate/server depending on which repository implementation is being used
abstract class ISinglePlayerRepository {
  // FutureOr<bool> setSinglePlayerGame(SinglePlayerState singlePlayerGame);
  FutureOr<void> updateGameByTileTap({required int col, required int row});
  FutureOr<void> updateGameByGuessingWord({required String word});
  Stream<SinglePlayerState> get gameStateStream;
  void dispose();
  // Stream<bool> get isIsolateConnectedStream;
  Future<void> init();
}
