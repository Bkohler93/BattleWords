import 'dart:async';
import 'dart:isolate';
import 'dart:typed_data';

import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/data/dao/game_manager.dart';
import 'package:battle_words/src/features/single_player_game/data/sources/isolate/isolate.dart';
import 'package:battle_words/src/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/src/features/single_player_game/domain/tile_coords.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';

part 'isolate_repository.dart';
part 'mock.dart';

/* 
  This is an interface for the single player game repository
  Future expansions on this project may have to retrieve game states from external API calls. Implement a new repository in this case.
  */
abstract class ISinglePlayerRepository {
  FutureOr<SinglePlayerState> getSinglePlayerGame();
  FutureOr<bool> setSinglePlayerGame(SinglePlayerState singlePlayerGame);
  FutureOr<void> updateGameByTileTap({required int col, required int row});
  FutureOr<void> updateGameByGuessingWord({required String word});
  Stream<SinglePlayerState> get gameStateStream;
}
