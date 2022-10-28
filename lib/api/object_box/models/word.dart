import 'package:objectbox/objectbox.dart';

@Entity()
class Word {
  int id;

  String text;
  int length;

  Word({this.id = 0, required this.text}) : length = text.length;

  @override
  toString() => 'Word{id: $id, text: $text, length: $length}';
}
