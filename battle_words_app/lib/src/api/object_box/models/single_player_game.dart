import 'package:objectbox/objectbox.dart';

@Entity()
class SinglePlayerGameModel {
  @Id()
  int id;

  //List<List<SinglePlayergameTile>> = List<String>
  //List<String> wordsGuessed = List<String>;
  //List<HiddenWord> = List<String>;
  //int movesRemaining;
  //TODO GameStatus enum
  //Map<String, KeyboardLetterStatus> = String

  String text;
  int length;

  SinglePlayerGameModel({
    this.id = 0,
    required this.text,
    required this.length,
  });

  @override
  toString() => 'Word{id: $id, text: $text, length: $length}';

  // Json is a Map<String, dynamic>
  static fromJson(model) => SinglePlayerGameModel(length: model.value, text: model.key);
}
