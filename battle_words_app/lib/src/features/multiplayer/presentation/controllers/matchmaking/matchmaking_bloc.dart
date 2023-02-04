import 'package:battle_words/src/features/multiplayer/data/matchmaking_repository.dart';
import 'package:battle_words/src/features/multiplayer/domain/matchmaking.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'matchmaking_event.dart';
part 'matchmaking_state.dart';

class MatchmakingBloc extends Bloc<MatchmakingEvent, MatchmakingState> {
  final MatchmakingRepository matchmakingRepo;

  MatchmakingBloc({required this.matchmakingRepo}) : super(MatchmakingConnecting()) {
    on<FindMatch>(
      (event, emit) async {
        await emit.forEach(
          matchmakingRepo.stateStream,
          onData: (state) {
            if (state.runtimeType == ServerMatchmakingState) {
              switch (state.status) {
                case ServerMatchmakingStatus.connectionError:
                  return MatchmakingConnectionError();
                case ServerMatchmakingStatus.findingGame:
                  return MatchmakingFindingGame();
                case ServerMatchmakingStatus.gameFound:
                  return MatchmakingFoundGame();
                case ServerMatchmakingStatus.opponentDeclined:
                  return MatchmakingOpponentTimeout();
                case ServerMatchmakingStatus.ready:
                  return MatchmakingReady();
                case ServerMatchmakingStatus.endMatchmaking:
                  matchmakingRepo.stopListening();
                  return MatchmakingStartGame();
                default:
                  return MatchmakingConnectionError();
              }
            } else {
              return MatchmakingConnecting();
            }
          },
          onError: (error, stackTrace) {
            return MatchmakingConnectionError();
          },
        );
      },
    );
    on<InitializeMatchmaking>((event, emit) async {
      emit(MatchmakingConnecting());
      await matchmakingRepo.connect();
      add(FindMatch());
    });

    on<PressPlayButton>((event, emit) async {
      //send to server "ready"
      await matchmakingRepo.sendReady();
    });

    //! RetryMatchmaking needs to be implemented
    on<RetryMatchmaking>((event, emit) async {
      emit(MatchmakingConnecting());
      await matchmakingRepo.reconnect();
    });
  }
}
