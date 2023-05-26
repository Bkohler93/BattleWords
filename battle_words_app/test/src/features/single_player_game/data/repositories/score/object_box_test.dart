import 'dart:io';

import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/score/interface.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:battle_words/src/features/single_player_game/presentation/controllers/score/score_cubit.dart';
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

  group("SinglePlayerScoreObjectBoxRepository", () {
    late ObjectBoxStore store;
    late ByteData storeReference;
    late Directory dir;

    setUp(() async {
      return Future(
        () async {
          dir = await getApplicationDocumentsDirectory()
              .then((dir) => Directory('${dir.path}/objectbox').create(recursive: true));
          store = await ObjectBoxStore.createAsync();
          storeReference = store.reference;
        },
      );
    });

    test("setScoreState(state) sets a new state in  the store", () {
      final scoreRepository = SinglePlayerScoreObjectBoxRepository(storeReference: storeReference);

      const newState =
          SinglePlayerScoreState(currentWinStreak: 2, highestWinStreak: 3, totalGamesWon: 5);

      scoreRepository.setScoreState(newState);

      final testState = scoreRepository.getScoreState();

      expect(testState.currentWinStreak, 2);
      expect(testState.highestWinStreak, 3);
      expect(testState.totalGamesWon, 5);
    });

    test("getScoreState returns a newly initialized SinglePlayerScoreState", () {
      final scoreRepository = SinglePlayerScoreObjectBoxRepository(storeReference: storeReference);

      final scoreState = scoreRepository.getScoreState();

      expect(scoreState.currentWinStreak, 0);
      expect(scoreState.highestWinStreak, 0);
      expect(scoreState.totalGamesWon, 0);
    });

    test(
        "updateScoreFromGameEnd(status.win) returns a SinglePlayerScoreState with all properties incremented by 1 (increase win streak, # games won, current win streak)",
        () {
      final scoreRepository = SinglePlayerScoreObjectBoxRepository(storeReference: storeReference);

      final scoreState = scoreRepository.updateScoreFromGameEnd(status: GameStatus.win);

      expect(scoreState.currentWinStreak, 1);
      expect(scoreState.totalGamesWon, 1);
      expect(scoreState.highestWinStreak, 1);
    });

    test(
        "updateScoreFromGameEnd(status.loss) returns a SinglePlayerScoreState with currentWinStreak set to 0 and other properties unadjusted",
        () {
      final scoreRepository = SinglePlayerScoreObjectBoxRepository(storeReference: storeReference);

      final scoreState = scoreRepository.updateScoreFromGameEnd(status: GameStatus.loss);

      expect(scoreState.currentWinStreak, 0);
      expect(scoreState.totalGamesWon, 0);
      expect(scoreState.highestWinStreak, 0);
    });

    test("updateScoreFromGameEnd(status.playing) returns throws an error", () {
      final scoreRepository = SinglePlayerScoreObjectBoxRepository(storeReference: storeReference);

      expect(() => scoreRepository.updateScoreFromGameEnd(status: GameStatus.playing),
          throwsException);
    });

    tearDown(() async {
      return Future(() async {
        store.clearAndCloseStore();
        dir.delete(recursive: true).then(
              (value) => print("=== (score repository test) DB deleted: ${!value.existsSync()}"),
            );
      });
    });
  });
}
