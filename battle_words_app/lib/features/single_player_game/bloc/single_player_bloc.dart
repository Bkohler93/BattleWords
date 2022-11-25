import 'package:battle_words/constants/game_details.dart';
import 'package:battle_words/features/single_player_game/data/repositories/game.dart';
import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:battle_words/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/features/single_player_game/domain/tile_coords.dart';
import 'package:battle_words/helpers/data_types.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'single_player_event.dart';
part 'single_player_state.dart';

class SinglePlayerBloc extends Bloc<SinglePlayerEvent, SinglePlayerState> {
  final SinglePlayerRepository repository;

  SinglePlayerBloc({required this.repository}) : super(const SinglePlayerState()) {
    on<StartGameEvent>(_handleStartGameEvent);
    on<TapGameBoardTileEvent>(_handleTapGameBoardTileEvent);
  }

  void _handleStartGameEvent(StartGameEvent event, Emitter<SinglePlayerState> emit) async {
    var newState = await repository.getSinglePlayerGame();

    emit(newState);
  }

  void _handleTapGameBoardTileEvent(
      TapGameBoardTileEvent event, Emitter<SinglePlayerState> emit) async {
    var newState = await repository.updateGameByTileTap(col: event.col, row: event.row);

    emit(newState);
  }
}
