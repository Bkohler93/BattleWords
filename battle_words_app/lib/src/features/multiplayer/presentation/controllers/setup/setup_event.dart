part of 'setup_bloc.dart';

abstract class SetupEvent extends Equatable {
  const SetupEvent();

  @override
  List<Object> get props => [];
}

class InitializeSetup extends SetupEvent {}

class PressButton extends SetupEvent {}

class RetrySetup extends SetupEvent {}

class StartSetup extends SetupEvent {}

class PressedPauseButton extends SetupEvent {}

class PressedRefreshButton extends SetupEvent {}

class PressedUndoButton extends SetupEvent {}

class PressedConfirmButton extends SetupEvent {}