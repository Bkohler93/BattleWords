import 'dart:convert';
import "dart:io";
import 'package:path/path.dart' as p;

import '../common/constants.dart';
import '../common/values..dart';

void main(List<String> arguments) async {
  // 1. read in arguments for txt file name
  final fileName = arguments[0];
  var filePath = p.join(Directory.current.path, 'input_lists', fileName);

  // 2. read in txt file,
  File myFile = File(filePath);
  final allWords = await myFile.readAsLines();

  // filter out three letter words, four letter words, and five letter words
  allWords.retainWhere((word) =>
      word.length == WORD_LENGTH_SM ||
      word.length == WORD_LENGTH_MED ||
      word.length == WORD_LENGTH_LG);

  // filter out words with no vowel
  allWords.retainWhere((word) => word.contains(RegExp('a|e|i|o|u')) || word.contains(RegExp('y')));

  // filter out roman numerals
  allWords.retainWhere((word) =>
      word == 'div' ||
      word == 'dix' ||
      word == 'mix' ||
      !word.contains(RegExp("^[ivxlcdm]{3,5}\$")));

  // filter out words with three or more letters in a row.. this word list isnt looking so good
  allWords.retainWhere((word) => !word.contains(RegExp("^([a-z])\\1\\1\$")));

  // filter out words from word_filter list
  allWords.retainWhere((word) => words.any((item) => item != word));

  // 6. Create map of words with their lengths
  final wordMap = {
    for (var word in allWords) word: word.length,
  };

  // 7. encode wordmap to JSON
  final jsonWords = jsonEncode(wordMap);

  // 8. Open output file
  filePath = p.join(Directory.current.path, 'output_lists', fileName);
  File outFile = await File(filePath).create();

  // 9. write json to file
  outFile.writeAsString(jsonWords);

  print("=== wrote to /output_lists");
}
