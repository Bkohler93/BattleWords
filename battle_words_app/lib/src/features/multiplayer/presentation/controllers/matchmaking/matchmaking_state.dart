part of 'matchmaking_bloc.dart';

abstract class MatchmakingState extends Equatable {
  const MatchmakingState();

  @override
  List<Object> get props => [];
}

extension MachmakingStateX on MatchmakingState {
  bool get isMatchmakingFindingGame => runtimeType == MatchmakingFindingGame;
  bool get isMatchmakingFoundGame => runtimeType == MatchmakingFoundGame;
  bool get isMatchmakingReady => runtimeType == MatchmakingReady;
  bool get isMatchmakingConnectionError => runtimeType == MatchmakingConnectionError;
  bool get isMatchmakingOpponentTimeout => runtimeType == MatchmakingOpponentTimeout;
  bool get isMatchmakingAwaitingOpponentReady => runtimeType == MatchmakingAwaitingOpponentReady;
  bool get isMatchmakingStartGame => runtimeType == MatchmakingStartGame;
  bool get isMatchmakingConnecting => runtimeType == MatchmakingConnecting;
}

// First the app needs to connect to the server via websocket. MatchmakingSearching will be the state of the screen during this initializing. After the server is conneceted to and a game has been found, the state will change to MatchmakingFoundGame. After the user hits "Ready" after the button appear when swtiching t..
class MatchmakingFindingGame extends MatchmakingState {}

class MatchmakingFoundGame extends MatchmakingState {}

class MatchmakingAwaitingOpponentReady extends MatchmakingState {}

class MatchmakingReady extends MatchmakingState {}

class MatchmakingConnectionError extends MatchmakingState {}

class MatchmakingOpponentTimeout extends MatchmakingState {}

class MatchmakingStartGame extends MatchmakingState {}

class MatchmakingConnecting extends MatchmakingState {}
