part of 'matchmaking_bloc.dart';

abstract class MatchmakingState extends Equatable {
  const MatchmakingState();

  @override
  List<Object> get props => [];
}

class MatchmakingSearching extends MatchmakingState {}

class MatchmakingFoundGame extends MatchmakingState {}

class MatchmakingReady extends MatchmakingState {}

class MatchmakingConnectionError extends MatchmakingState {}

class MatchmakingOpponentTimeout extends MatchmakingState {}
