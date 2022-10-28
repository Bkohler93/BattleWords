import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:valid_word_database/word_model.dart';
import 'package:valid_word_database/objectbox.g.dart';
import 'dart:convert';

Future<void> main(List<String> arguments) async {
  final store = openStore();

  final wordBox = store.box<Word>();

  store.close();
}

void fillDatabase(Store store, Box<Word> wordBox) async {
  //get file
  String filePath = path.join(Directory.current.path, 'words_alpha.txt');
  final myFile = File(filePath);
  final wordString = await myFile.readAsString();
  final words = jsonDecode(wordString);

  final List<Word> modelWords = [];

  words.forEach((word, length) => modelWords.add(Word(text: word, length: length)));

  final ids = wordBox.putMany(modelWords);
}
