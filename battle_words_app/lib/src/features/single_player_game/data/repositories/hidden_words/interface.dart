import 'package:battle_words/src/api/object_box/models/word.dart';
import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';

part 'object_box.dart';
part 'mock.dart';

abstract class IHiddenWordsRepository {
  List<HiddenWord> fetchHiddenWords();
  bool checkIfValidWord(String word);
  void closeStore();
}
