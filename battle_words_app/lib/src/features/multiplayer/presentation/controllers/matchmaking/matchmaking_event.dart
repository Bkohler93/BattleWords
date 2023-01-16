part of 'matchmaking_bloc.dart';

abstract class MatchmakingEvent extends Equatable {
  const MatchmakingEvent();

  @override
  List<Object> get props => [];
}

class InitializeMatchmaking extends MatchmakingEvent {}

class PressPlayButton extends MatchmakingEvent {}

class RetryMatchmaking extends MatchmakingEvent {}
