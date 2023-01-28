import 'package:battle_words/src/features/multiplayer/data/repository.dart';
import 'package:battle_words/src/features/multiplayer/domain/matchmaking.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'matchmaking_event.dart';
part 'matchmaking_state.dart';

class MatchmakingBloc extends Bloc<MatchmakingEvent, MatchmakingState> {
  final MatchmakingRepository matchmakingRepo;

  MatchmakingBloc({required this.matchmakingRepo}) : super(MatchmakingSearching()) {
    on<FindMatch>(
      (event, emit) async {
        await emit.forEach(
          matchmakingRepo.stateStream,
          onData: (state) {
            switch (state.status) {
              case MatchmakingServerStatus.gameFound:
                return MatchmakingFoundGame();
              case MatchmakingServerStatus.ready:
                return MatchmakingReady();
              case MatchmakingServerStatus.connectionError:
                return MatchmakingConnectionError();
              case MatchmakingServerStatus.opponentDeclined:
                return MatchmakingOpponentTimeout();
              case MatchmakingServerStatus.startingGame:
                matchmakingRepo.stopListening();
                return MatchmakingStartGame();
              default:
                return MatchmakingConnectionError();
            }
          },
          onError: (error, stackTrace) => MatchmakingConnectionError(),
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

      //emit MatchmakingReady
    });

    //! RetryMatchmaking needs to be implemented
    // on<RetryMatchmaking>((event, emit) async {
    //   emit(MatchmakingConnecting());
    //   await matchmakingRepo.reconnect();
    //   add(FindMatch());
    // });
  }
}
