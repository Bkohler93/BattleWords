import 'package:battle_words/src/constants/game_details.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/game/interface.dart';
import 'package:battle_words/src/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/src/features/single_player_game/domain/tile_coords.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/keyboard/domain/letter.dart';
import 'package:battle_words/src/helpers/data_types.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:json_annotation/json_annotation.dart';

part 'single_player_event.dart';
part 'single_player_state.dart';
part 'single_player_bloc.g.dart';

class SinglePlayerBloc extends Bloc<SinglePlayerEvent, SinglePlayerState> {
  final ISinglePlayerRepository singlePlayerRepository;
  late final Stream<SinglePlayerState> incomingStateStream;

  SinglePlayerBloc({required this.singlePlayerRepository}) : super(const SinglePlayerState()) {
    // _handleGameStateStream();
    incomingStateStream = singlePlayerRepository.gameStateStream;
    on<StateChangeEvent>(_updateUi);
    on<StartGameEvent>(_handleStartGameEvent);
    on<TapGameBoardTileEvent>(_handleTapGameBoardTileEvent);
    on<GuessWordEvent>(_handleGuessWordEvent);
    on<GameOverEvent>(_handleGameOverEvent);
  }

  void _handleGameOverEvent(GameOverEvent event, Emitter<SinglePlayerState> emit) {
    // TODO maybe do something here. Should implement with StreamController to allow closing of stream.
    // incomingStateStreamController.close();
  }

  void _listenForChanges() {
    incomingStateStream.listen((state) {
      if (!isClosed) {
        add(StateChangeEvent(state: state));
      }
    });
  }

  void _updateUi(StateChangeEvent event, Emitter<SinglePlayerState> emit) {
    emit(event.state);
  }

  Future<void> _handleStartGameEvent(StartGameEvent event, Emitter<SinglePlayerState> emit) async {
    //emit loading state
    emit(state.copyWith(gameStatus: GameStatus.loading));

    //init repository, connecting isolate
    await singlePlayerRepository.init();

    _listenForChanges();

    //wait for isolate to complete connection
    // final isolateConnected = await repository.isIsolateConnectedStream.first;

    //call getSinglePlayerGame for repository to initiate isolate communication
    // repository.getSinglePlayerGame();
  }

  void _handleTapGameBoardTileEvent(
      TapGameBoardTileEvent event, Emitter<SinglePlayerState> emit) async {
    await singlePlayerRepository.updateGameByTileTap(col: event.col, row: event.row);
  }

  void _handleGuessWordEvent(GuessWordEvent event, Emitter<SinglePlayerState> emit) async {
    await singlePlayerRepository.updateGameByGuessingWord(word: event.word);
  }
}
