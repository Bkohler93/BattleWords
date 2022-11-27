import 'dart:async';
import 'dart:isolate';

import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/data/sources/isolate/run_app.dart';
import 'package:battle_words/src/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/src/features/single_player_game/domain/tile_coords.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';

part 'isolate_repository.dart';
part 'mock.dart';

abstract class GameManagerRequestObject {}

class GetSinglePlayerGame extends GameManagerRequestObject {}

class SetSinglePlayerGame extends GameManagerRequestObject {
  SetSinglePlayerGame({required this.state});
  final SinglePlayerState state;
}

class UpdateGameByTileTap extends GameManagerRequestObject {
  UpdateGameByTileTap({required this.col, required this.row});
  final int col;
  final int row;
}

class UpdateGameByGuessingWord extends GameManagerRequestObject {
  UpdateGameByGuessingWord({required this.word});
  final String word;
}

class SendObjectBoxStore extends GameManagerRequestObject {
  SendObjectBoxStore({required this.store});
  final ObjectBoxStore store;
}

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
