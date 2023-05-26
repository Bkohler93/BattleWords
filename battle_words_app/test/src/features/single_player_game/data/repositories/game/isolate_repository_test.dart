import 'dart:io';

import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/game/interface.dart';
import 'package:battle_words/src/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel("plugins.flutter.io/path_provider_macos");
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    return ".";
  });

  group("SinglePlayerIsolateRepository", () {
    late ObjectBoxStore store;
    late ByteData storeReference;
    late Directory dir;

    setUp(() async {
      return Future(() async {
        Directory appDir = await getApplicationDocumentsDirectory();
        dir = Directory('${appDir.path}/objectbox');
        if (!dir.existsSync()) {
          dir.create(recursive: true);
        }
        store = await ObjectBoxStore.createAsync();
        storeReference = store.reference;
      });
    });

    tearDown(() async {
      return Future(
        () async {
          store.clearAndCloseStore();
          if (dir.existsSync()) {
            final entity = await dir.delete(recursive: true);
            if (kDebugMode) {
              print("=== (isolate repository test) DB deleted: ${!entity.existsSync()}");
            }
          }
          // dir.delete(recursive: true).then(
          //       (value) =>
          //           print("=== (isolate repository test) DB deleted: ${!value.existsSync()}"),
          //     );
        },
      );
    });

    test("getSinglePlayerGame results in gameStateStream sending back a new SinglePlayerGame state",
        () async {
      final SinglePlayerObjectBoxRepository repository =
          SinglePlayerObjectBoxRepository(store: store);

      await repository.init();
      await repository.isIsolateConnectedStream.first;

      // repository.getSinglePlayerGame();

      expect(repository.gameStateStream, emits(predicate((value) {
        expect(value.runtimeType, SinglePlayerState);
        return true;
      })));
    });

    ///TODO setSinglePlayerGame is not implemented yet, as all new states are set based on GameManagerRequestObjects
    // test("setSinglePlayerGame returns true if a state was successfully set by the game manager",
    //     () async {
    //   final SinglePlayerIsolateRepository repository =
    //       SinglePlayerIsolateRepository(objectBoxStoreReference: storeReference!);

    //   final newSinglePlayerState = SinglePlayerState.generate();

    //   await Future.delayed(Duration(milliseconds: 100)).then((value) {
    //     expect(repository.setSinglePlayerGame(newSinglePlayerState), true);
    //   });
    // });

    test("updateGameByTileTap returns a state with the correct tile set to uncovered", () async {
      final SinglePlayerObjectBoxRepository repository =
          SinglePlayerObjectBoxRepository(store: store);

      await repository.init();
      await repository.isIsolateConnectedStream.first; //wait for isolate connection to complete

      const updateCol = 2;
      const updateRow = 4;

      repository.updateGameByTileTap(col: updateCol, row: updateRow);

      expect(
          repository.gameStateStream,
          emitsInOrder([
            //initial game state, not being tested
            predicate((value) {
              expect(value.runtimeType, SinglePlayerState);
              return true;
            }),

            //state that is being tested for updated TileStatus
            predicate<SinglePlayerState>((state) {
              if (kDebugMode) {
                print(state.gameBoard[updateRow][updateCol].tileStatus);
              }
              final isTileUncovered =
                  state.gameBoard[updateRow][updateCol].tileStatus != TileStatus.hidden;
              expect(isTileUncovered, true);
              return true;
            }),
          ]));
    });

    test("updateGameByGuessingWord updates the gamestate based on guessing the word", () async {
      final SinglePlayerObjectBoxRepository repository =
          SinglePlayerObjectBoxRepository(store: store);

      await repository.init();
      final connected = await repository.isIsolateConnectedStream.first;
      if (kDebugMode) {
        print(connected);
      }
      late final String guessWord; //will be determined by first incoming state

      expect(
          repository.gameStateStream,
          emitsInOrder([
            //first state, used to assign guessWord a value
            predicate<SinglePlayerState>((state) {
              expect(state.runtimeType, SinglePlayerState);
              guessWord = "fart";

              repository.updateGameByGuessingWord(word: guessWord);
              return true;
            }),
            predicate<SinglePlayerState>((state) {
              final matchWord = state.wordsGuessed[0];
              expect(matchWord, guessWord);
              return true;
            }),
          ]));
    });
  });
}
