import 'dart:io';
import 'package:valid_word_database/word_model.dart';
import 'package:valid_word_database/objectbox.g.dart';
import 'dart:convert';

Future<void> main(List<String> arguments) async {
  final store = openStore();

  final wordBox = store.box<Word>();

  await fillDatabase(store, wordBox);

  store.close();
}

Future<void> fillDatabase(Store store, Box<Word> wordBox) async {
  //get file
  String filePath = '${Directory.current.path}/words_alpha.txt';
  final myFile = File(filePath);
  final wordString = await myFile.readAsString();
  final words = jsonDecode(wordString);
  print(words);
  final List<Word> modelWords = [];

  words.forEach((word, length) => modelWords.add(Word(text: word, length: length)));

  final ids = wordBox.putMany(modelWords);
}
