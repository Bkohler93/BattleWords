import 'package:battle_words/src/features/multiplayer/data/setup_repository.dart';
import 'package:battle_words/src/features/multiplayer/domain/setup.dart';
import 'package:battle_words/src/features/multiplayer/domain/setup_gameboard.dart';
import 'package:battle_words/src/features/multiplayer/domain/setup_gameboard_tile.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/hidden_words/interface.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/src/helpers/data_types.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'setup_event.dart';
part 'setup_state.dart';

class SetupBloc extends Bloc<SetupEvent, SetupState> {
  final SetupRepository setupRepo;
  final HiddenWordsRepository hiddenWordsRepo;
  late final List<HiddenWord> hiddenWords;

  SetupBloc({required this.setupRepo, required this.hiddenWordsRepo})
      : super(SetupState.initial()) {
    on<StartSetup>(
      (event, emit) async {
        await emit.forEach(
          setupRepo.stateStream,
          onData: (serverState) {
            if (serverState.runtimeType == ServerSetupState) {
              switch (serverState.setupStep) {
                case SetupStep.connectionError:
                  return state.copyWith(); //TODO
                case SetupStep.endSetup:
                  setupRepo.stopListening();
                  return state.copyWith(); //TODO
                case SetupStep.serverSaysHi:
                  return state.copyWith(); //TODO
                default:
                  return state.copyWith(); //TODO
              }
            } else {
              return state.copyWith(); //TODO
            }
          },
          onError: (error, stackTrace) {
            return state.copyWith(); //TODO on error
          },
        );
      },
    );
    on<InitializeSetup>((event, emit) async {
      hiddenWords = hiddenWordsRepo.fetchHiddenWords();
      await setupRepo.connect();
      add(StartSetup());
    });
    on<PressButton>((event, emit) async {
      await setupRepo.sayHelloToServer();
    });
  }
}
