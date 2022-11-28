import 'dart:io';
import 'package:valid_word_database/word_model.dart';
import 'package:valid_word_database/objectbox.g.dart';
import 'dart:convert';

Future<void> main(List<String> arguments) async {
  final store = openStore();
  final fileName = arguments[0];

  final wordBox = store.box<Word>();
  final numRemoved = wordBox.removeAll();

  print('=== Deleted $numRemoved while clearing database.');

  await fillDatabase(store, wordBox, fileName);

  store.close();
}

Future<void> fillDatabase(Store store, Box<Word> wordBox, String fileName) async {
  //get file
  String filePath = '${Directory.current.path}/wordlists/$fileName';
  final myFile = File(filePath);
  final wordString = await myFile.readAsString();
  final words = jsonDecode(wordString);
  final List<Word> modelWords = [];

  words.forEach((word, length) => modelWords.add(Word(text: word, length: length)));
  final ids = wordBox.putMany(modelWords);
}
