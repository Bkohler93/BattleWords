import 'package:battle_words/src/features/multiplayer/data/setup_repository.dart';
import 'package:battle_words/src/features/multiplayer/domain/setup.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'setup_event.dart';
part 'setup_state.dart';

class SetupBloc extends Bloc<SetupEvent, SetupState> {
  final SetupRepository setupRepo;

  SetupBloc({required this.setupRepo}) : super(SetupInitial()) {
    on<StartSetup>(
      (event, emit) async {
        await emit.forEach(
          setupRepo.stateStream,
          onData: (state) {
            if (state.runtimeType == ServerSetupState) {
              switch (state.setupStep) {
                case SetupStep.connectionError:
                  return SetupConnectionError();
                case SetupStep.endSetup:
                  setupRepo.stopListening();
                  return SetupStartGame();
                case SetupStep.serverSaysHi:
                  return ServerSaidHi();
                default:
                  return SetupConnectionError();
              }
            } else {
              return SetupError();
            }
          },
          onError: (error, stackTrace) {
            return SetupConnectionError();
          },
        );
      },
    );
    on<InitializeSetup>((event, emit) async {
      emit(SetupInitial());
      await setupRepo.connect();
      add(StartSetup());
    });
    on<PressButton>((event, emit) async {
      await setupRepo.sayHelloToServer();
    });
  }
}
