import 'package:battle_words/src/features/multiplayer/data/repository.dart';
import 'package:battle_words/src/features/multiplayer/domain/matchmaking.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'matchmaking_event.dart';
part 'matchmaking_state.dart';

class MatchmakingBloc extends Bloc<MatchmakingEvent, MatchmakingState> {
  final MatchmakingRepository matchmakingRepo;

  MatchmakingBloc({required this.matchmakingRepo}) : super(MatchmakingSearching()) {
    on<InitializeMatchmaking>((event, emit) async {
      await emit.forEach(matchmakingRepo.connectAndListen(), onData: (status) {
        switch (status.status) {
          case MatchmakingStatus.gameFound:
            return MatchmakingFoundGame();
          case MatchmakingStatus.ready:
            return MatchmakingReady();
          case MatchmakingStatus.connectionError:
            return MatchmakingConnectionError();
          case MatchmakingStatus.opponentDeclined:
            return MatchmakingOpponentTimeout();
          default:
            return MatchmakingConnectionError();
        }
      });
    });

    on<PressPlayButton>((event, emit) {
      //send to server "ready"

      //emit MatchmakingReady
    });
    on<RetryMatchmaking>((event, emit) {
      //emit MatchmakingSearching state

      //disconnect websocket, reconnect to server
    });
  }
}
