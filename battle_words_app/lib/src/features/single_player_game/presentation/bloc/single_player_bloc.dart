import 'package:battle_words/src/constants/game_details.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/game/interface.dart';
import 'package:battle_words/src/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/src/features/single_player_game/domain/tile_coords.dart';
import 'package:battle_words/src/helpers/data_types.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'single_player_event.dart';
part 'single_player_state.dart';

class SinglePlayerBloc extends Bloc<SinglePlayerEvent, SinglePlayerState> {
  final ISinglePlayerRepository repository;

  SinglePlayerBloc({required this.repository}) : super(const SinglePlayerState()) {
    // _handleGameStateStream();
    on<StateChangeEvent>(_updateUi);
    on<StartGameEvent>(_handleStartGameEvent);
    on<TapGameBoardTileEvent>(_handleTapGameBoardTileEvent);
    on<GuessWordEvent>(_handleGuessWordEvent);
  }

  void _listenForChanges() {
    repository.gameStateStream.listen((state) {
      add(StateChangeEvent(state: state));
    });
  }

  void _updateUi(StateChangeEvent event, Emitter<SinglePlayerState> emit) {
    emit(event.state);
  }

  Future<void> _handleStartGameEvent(StartGameEvent event, Emitter<SinglePlayerState> emit) async {
    //emit loading state
    emit(state.copyWith(gameStatus: GameStatus.loading));

    //init repository, connecting isolate
    await repository.init();

    _listenForChanges();

    //wait for isolate to complete connection
    final isolateConnected = await repository.isIsolateConnectedStream.first;

    //call getSinglePlayerGame for repository to initiate isolate communication
    repository.getSinglePlayerGame();
  }

  void _handleTapGameBoardTileEvent(
      TapGameBoardTileEvent event, Emitter<SinglePlayerState> emit) async {
    await repository.updateGameByTileTap(col: event.col, row: event.row);
  }

  void _handleGuessWordEvent(GuessWordEvent event, Emitter<SinglePlayerState> emit) async {
    await repository.updateGameByGuessingWord(word: event.word);
  }
}
