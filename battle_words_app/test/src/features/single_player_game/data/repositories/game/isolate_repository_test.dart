import 'dart:io';
import 'dart:isolate';

import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/game/interface.dart';
import 'package:battle_words/src/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel("plugins.flutter.io/path_provider_macos");
  TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    return ".";
  });

  group("SinglePlayerIsolateRepository", () {
    ObjectBoxStore? store;
    late ByteData? storeReference;
    late Directory dir;

    setUp(() async {
      return Future(() async {
        dir = await getApplicationDocumentsDirectory()
            .then((dir) => Directory('${dir.path}/objectbox').create(recursive: true));
        store = ObjectBoxStore();
        await Future.delayed(Duration(milliseconds: 100))
            .then((_) => storeReference = store!.reference);
      });
    });

    test("getSinglePlayerGame results in gameStateStream sending back a new SinglePlayerGame state",
        () async {
      final SinglePlayerIsolateRepository repository =
          SinglePlayerIsolateRepository(objectBoxStoreReference: storeReference!);

      await Future.delayed(Duration(milliseconds: 100)).then((value) {
        repository.getSinglePlayerGame();

        expect(repository.gameStateStream, emits(predicate((value) {
          expect(value.runtimeType, SinglePlayerState);
          return true;
        })));
      });
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
      final SinglePlayerIsolateRepository repository =
          SinglePlayerIsolateRepository(objectBoxStoreReference: storeReference!);

      await Future.delayed(Duration(milliseconds: 100)).then((_) async {
        final updateCol = 2;
        final updateRow = 4;

        repository.updateGameByTileTap(col: updateCol, row: updateRow);

        await Future.delayed(Duration(milliseconds: 100)).then(
          (value) {
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
                    print(state.gameBoard[updateRow][updateCol].tileStatus);
                    final isTileUncovered =
                        state.gameBoard[updateRow][updateCol].tileStatus != TileStatus.hidden;
                    expect(isTileUncovered, true);
                    return true;
                  }),
                ]));
          },
        );
      });
    });

    test("updateGameByGuessingWord updates the gamestate based on guessing the word", () async {
      final SinglePlayerIsolateRepository repository =
          SinglePlayerIsolateRepository(objectBoxStoreReference: storeReference!);
      late final guessWord; //will be determined by first incoming state

      await Future.delayed(Duration(milliseconds: 100)).then((_) {
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

    tearDown(() async {
      return Future(
        () async {
          store!.clearAndCloseStore();
          dir.delete(recursive: true).then(
                (value) =>
                    print("=== (isolate repository test) DB deleted: ${!value.existsSync()}"),
              );
        },
      );
    });
  });
}
