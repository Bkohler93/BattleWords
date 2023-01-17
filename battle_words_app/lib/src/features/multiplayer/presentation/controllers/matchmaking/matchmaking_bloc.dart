import 'package:battle_words/src/features/multiplayer/data/repository.dart';
import 'package:battle_words/src/features/multiplayer/domain/matchmaking.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'matchmaking_event.dart';
part 'matchmaking_state.dart';

class MatchmakingBloc extends Bloc<MatchmakingEvent, MatchmakingState> {
  final MatchmakingRepository matchmakingRepo;

  MatchmakingBloc({required this.matchmakingRepo}) : super(MatchmakingSearching()) {
    on<InitializeMatchmaking>((event, emit) async {
      await emit.forEach(matchmakingRepo.onNewState, onData: (status) {
        switch (status.status) {
          case MatchmakingStatus.gameFound:
            return MatchmakingFoundGame();
          case MatchmakingStatus.ready:
            return MatchmakingReady();
          case MatchmakingStatus.connectionError:
            return MatchmakingConnectionError();
          case MatchmakingStatus.opponentDeclined:
            return MatchmakingOpponentTimeout();
          case MatchmakingStatus.startingGame:
            return MatchmakingStartGame();
          default:
            return MatchmakingConnectionError();
        }
      });
    }, transformer: restartable()); //restart process if new data is received

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
