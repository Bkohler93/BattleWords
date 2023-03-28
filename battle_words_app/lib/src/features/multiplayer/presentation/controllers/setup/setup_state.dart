part of 'setup_bloc.dart';

abstract class SetupState extends Equatable {
  const SetupState();

  @override
  List<Object> get props => [];
}

extension SetupStateX on SetupState {
  bool get isSetupConnectionError => runtimeType == SetupConnectionError;
  bool get isSetupInitial => runtimeType == SetupInitial;
  bool get isSetupEnd => runtimeType == SetupEnd;
  bool get isSetupError => runtimeType == SetupError;
  bool get isServerSaidHi => runtimeType == ServerSaidHi;
}

class SetupInitial extends SetupState {}

class SetupConnectionError extends SetupState {}

class SetupStartGame extends SetupState {}

class SetupEnd extends SetupState {}

class SetupError extends SetupState {}

class ServerSaidHi extends SetupState {}
