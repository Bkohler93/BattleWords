import 'dart:io';

import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/api/object_box/objectbox.g.dart';
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
    final ObjectBoxStore objectBoxStore = ObjectBoxStore();
    late final Directory dir;

    test("ObjectBox() opens a store.", () {
      print(objectBoxStore.store.runtimeType);
      expect(objectBoxStore.store.runtimeType, Store);
    });

    tearDown(() async {
      dir.delete(recursive: true).then((value) => print("=== DB deleted: ${!value.existsSync()}"));
    });

    setUp(() async {
      return Future(
        () async {
          dir = await getApplicationDocumentsDirectory()
              .then((dir) => Directory('${dir.path}/objectbox').create(recursive: true));
        },
      );
    });
  });
}
