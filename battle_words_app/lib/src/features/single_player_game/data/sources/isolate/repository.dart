import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';

class SinglePlayerWriteRepository {
  SinglePlayerWriteRepository({required ObjectBoxStore store}) : _store = store;

  final ObjectBoxStore _store;

  //update state in db
  void updateSinglePlayerState(SinglePlayerState singlePlayerGame) {}

  //retrieve a state from db

  //delete states
}
