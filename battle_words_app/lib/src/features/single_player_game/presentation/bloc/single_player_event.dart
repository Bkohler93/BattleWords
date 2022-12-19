part of 'single_player_bloc.dart';

@immutable
abstract class SinglePlayerEvent {}

class StartGameEvent implements SinglePlayerEvent {}

/// This event only requires knowing the col/row of the tile that was tapped on.
class TapGameBoardTileEvent implements SinglePlayerEvent {
  TapGameBoardTileEvent({required this.col, required this.row});

  final int col;
  final int row;
}

class GuessWordEvent implements SinglePlayerEvent {
  GuessWordEvent({required this.word});
  final String word;
}

class StateChangeEvent implements SinglePlayerEvent {
  StateChangeEvent({required this.state});
  final SinglePlayerState state;
}

class GameOverEvent implements SinglePlayerEvent {
  GameOverEvent();
}
