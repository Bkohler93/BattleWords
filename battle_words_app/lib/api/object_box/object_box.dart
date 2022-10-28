import 'package:battle_words/api/object_box/models/word.dart';
import 'package:battle_words/api/object_box/objectbox.g.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final objectBoxProvider = FutureProvider<ObjectBox>((ref) => ObjectBox.create());

class ObjectBox {
  late final Store store;
  late final Box<Word> wordBox;
  ObjectBox._create(this.store) {
    // Add any additional setup code, e.g. build queries.
    wordBox = store.box<Word>();
  }

  /// Create an instance of ObjectBox to use throughout the app.
  static Future<ObjectBox> create() async {
    // Future<Store> openStore() {...} is defined in the generated objectbox.g.dart
    final store = await openStore();
    return ObjectBox._create(store);
  }
}
