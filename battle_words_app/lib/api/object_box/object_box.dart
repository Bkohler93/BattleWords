import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:battle_words/api/object_box/models/word.dart';
import 'package:battle_words/api/object_box/objectbox.g.dart';
import 'package:battle_words/features/single_player_game/domain/hidden_word.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:objectbox/objectbox.dart';

final objectBoxRepositoryProvider = Provider<ObjectBoxRepository>((ref) => ObjectBoxRepository());

abstract class IObjectBoxRepository {
  Future<void> _ensureDbOpen();
  Word _getRandomWordOfLength(final int length);
  Future<List<HiddenWord>> getRandomWords();
  Future<void> populateDatabase();
}

class ObjectBoxRepository implements IObjectBoxRepository {
  ObjectBoxRepository();
  Store? store;
  late final Box<Word> wordBox;

  @override
  Future<void> _ensureDbOpen() async {
    if (store == null) {
      store = await openStore();
      wordBox = store!.box<Word>();
    }
  }

  @override
  Word _getRandomWordOfLength(final int length) {
    //query for words of length 'length'
    final query = (wordBox.query(
      Word_.length.equals(length),
    )).build();
    final results = query.find();

    //grab random word from results
    return results[Random().nextInt(results.length - 1)];
  }

  @override
  Future<List<HiddenWord>> getRandomWords() async {
    await _ensureDbOpen();

    final List<Word> words = [
      for (var length = 5; length > 2; length--) _getRandomWordOfLength(length)
    ];

    return words.map((word) => HiddenWord(word: word.text)).toList();
  }

  @override
  Future<void> populateDatabase() async {
    await _ensureDbOpen();

    if (wordBox.isEmpty()) {
      final wordString = await rootBundle.loadString("assets/wordlists/google-10000-english.txt");
      //get file
      // String filePath = '${Directory.current.path}resources/google-10000-english.txt';
      // final myFile = File(filePath);
      // final wordString = await myFile.readAsString();
      final words = jsonDecode(wordString);
      final List<Word> modelWords = [];

      words.forEach((word, length) => modelWords.add(Word(text: word, length: length)));
      print('=== populated database. first word: ${modelWords[0]}');
      final ids = wordBox.putMany(modelWords);
    } else {
      print("=== database already populated");
    }
  }
}

class MockObjectBoxRepository implements IObjectBoxRepository {
  @override
  Future<void> _ensureDbOpen() {
    return Future.delayed(Duration(milliseconds: 50));
  }

  @override
  Word _getRandomWordOfLength(int length) {
    return length == 5
        ? Word(text: "sauce", length: 5)
        : length == 4
            ? Word(text: 'bear', length: 4)
            : Word(text: 'you', length: 3);
  }

  @override
  Future<List<HiddenWord>> getRandomWords() {
    return Future.value(
        [for (var i = 3; i > 0; i--) HiddenWord(word: _getRandomWordOfLength(i).text)]);
  }

  @override
  Future<void> populateDatabase() {
    // TODO: implement populateDatabase
    throw UnimplementedError();
  }
}
