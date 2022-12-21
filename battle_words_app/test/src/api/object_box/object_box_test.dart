import 'dart:io';

import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/api/object_box/objectbox.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider/path_provider.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const MethodChannel channel = MethodChannel('plugins.flutter.io/path_provider_macos');
  TestDefaultBinaryMessengerBinding.instance?.defaultBinaryMessenger
      .setMockMethodCallHandler(channel, (MethodCall methodCall) async {
    return ".";
  });

  group("Test ObjectBoxStore constructor and _initialize() method", () {
    final ObjectBoxStore objectBoxStore = ObjectBoxStore.createSync();
    // late final Directory dir;

    test("ObjectBox() opens a store.", () {
      if (kDebugMode) {
        print(objectBoxStore.store.runtimeType);
      }
      expect(objectBoxStore.store.runtimeType, Store);
    });

    // tearDown(() async {
    //   return Future(
    //     () async {
    //       await dir
    //           .delete(recursive: true)
    //           .then((value) => print("=== DB deleted: ${!value.existsSync()}"));
    //     },
    //   );
    // });

    // setUp(() async {
    //   return Future(
    //     () async {
    //       final appsDir = await getApplicationDocumentsDirectory();
    //       dir = await Directory('${appsDir.path}/objectbox').create(recursive: true);
    //     },
    //   );
    // });
  });
}
