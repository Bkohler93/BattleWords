part of 'matchmaking_bloc.dart';

abstract class MatchmakingState extends Equatable {
  const MatchmakingState();

  @override
  List<Object> get props => [];
}

// First the app needs to connect to the server via websocket. MatchmakingSearching will be the state of the screen during this initializing. After the server is conneceted to and a game has been found, the state will change to MatchmakingFoundGame. After the user hits "Ready" after the button appear when swtiching t..
class MatchmakingSearching extends MatchmakingState {}

class MatchmakingFoundGame extends MatchmakingState {}

class MatchmakingReady extends MatchmakingState {}

class MatchmakingConnectionError extends MatchmakingState {}

class MatchmakingOpponentTimeout extends MatchmakingState {}
