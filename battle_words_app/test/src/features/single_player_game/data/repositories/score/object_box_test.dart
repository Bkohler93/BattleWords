import 'dart:io';
import 'dart:typed_data';

import 'package:battle_words/src/api/object_box/models/single_player_score.dart';
import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/score/interface.dart';
import 'package:battle_words/src/features/single_player_game/presentation/controllers/score/score_cubit.dart';
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

  group("SinglePlayerScoreObjectBoxRepository", () {
    ObjectBoxStore? store;
    late ByteData? storeReference;
    late Directory dir;

    setUpAll(() async {
      return Future(
        () async {
          dir = await getApplicationDocumentsDirectory()
              .then((dir) => Directory('${dir.path}/objectbox').create(recursive: true));
          store = ObjectBoxStore();
          storeReference = store!.reference;
        },
      );
    });

    test("setScoreState(state) sets a new state in  the store", () {
      final scoreRepository = SinglePlayerScoreObjectBoxRepository(storeReference: storeReference!);

      final newState =
          SinglePlayerScoreState(currentWinStreak: 2, highestWinStreak: 3, totalGamesWon: 5);

      scoreRepository.setScoreState(newState);

      final testState = scoreRepository.getScoreState();

      expect(testState.currentWinStreak, 2);
      expect(testState.highestWinStreak, 3);
      expect(testState.totalGamesWon, 5);
    });

    test("getScoreState returns a newly initialized SinglePlayerScoreState", () {
      final scoreRepository = SinglePlayerScoreObjectBoxRepository(storeReference: storeReference!);

      final scoreState = scoreRepository.getScoreState();

      expect(scoreState.currentWinStreak, 0);
      expect(scoreState.highestWinStreak, 0);
      expect(scoreState.totalGamesWon, 0);
    });

    tearDownAll(() async {
      return Future(() async {
        store!.clearAndCloseStore();
        dir.delete(recursive: true).then(
            (value) => print("=== (score repository test) DB deleted: ${!value.existsSync()}"));
      });
    });
  });
}
