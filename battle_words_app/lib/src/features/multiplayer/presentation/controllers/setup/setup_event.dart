part of 'setup_bloc.dart';

abstract class SetupEvent extends Equatable {
  const SetupEvent();

  @override
  List<Object> get props => [];
}

class InitializeSetup extends SetupEvent {}

class SelectTile extends SetupEvent {
  const SelectTile({required this.row, required this.col});
  final int row;
  final int col;
}

class RetrySetup extends SetupEvent {}

class StartSetup extends SetupEvent {}

class ReleaseTile extends SetupEvent {
  const ReleaseTile(this.col, this.row, {required this.dragDirection});
  final int col;
  final int row;
  final DragDirection dragDirection;
}

class PressedPauseButton extends SetupEvent {}

class PressedRefreshButton extends SetupEvent {}

class PressedUndoButton extends SetupEvent {}

class PressedConfirmButton extends SetupEvent {}

class SelectWordToPlace extends SetupEvent {
  const SelectWordToPlace({required this.word});
  final HiddenWord word;
}

class AttemptToPlaceWord extends SetupEvent {
  const AttemptToPlaceWord(this.col, this.row, {required this.direction});
  final DragDirection direction;
  final int col;
  final int row;
}
