import 'dart:convert';
import 'dart:io';

import 'package:battle_words/src/api/object_box/models/single_player_game.dart';
import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/game/interface.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  late final MethodChannel channel;
  if (Platform.isMacOS) {
    channel = const MethodChannel("plugins.flutter.io/path_provider_macos");
  } else {
    channel = const MethodChannel("plugins.flutter.io/path_provider");
  }
  TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    return ".";
  });

  group("SinglePlayerObjectBoxRepository", () {
    late ObjectBoxStore store;
    late ByteData storeReference;
    late Directory dir;

    //TODO write test for init() method

    test("gameStateStream returns a stream of SinglePlayerStates", () async {
      final repository =
          SinglePlayerObjectBoxRepository(store: store, storeReference: storeReference);

      await repository.init();

      //create new state
      final state = SinglePlayerState.generate();
      final jsonStringState = jsonEncode(state.toJson());

      expectLater(repository.gameStateStream, emits(predicate((value) {
        expect(value.runtimeType, SinglePlayerState);
        return true;
      })));

      //put object in store to trigger test
      store.singlePlayerGameBox.put(SinglePlayerGameModel(jsonStringState: jsonStringState));
    });

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
      return Future(() async {
        store.clearAndCloseStore();
        if (dir.existsSync()) {
          final entity = await dir.delete(recursive: true);
          if (kDebugMode) {
            print("=== (singlePlayerObjectBoxRepository) DB deleted: ${!entity.existsSync()}");
          }
        }
      });
    });
  });
}
