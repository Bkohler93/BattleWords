import 'package:objectbox/objectbox.dart';

@Entity()
class Word {
  @Id()
  int id;

  String text;
  int length;

  Word({
    this.id = 0,
    required this.text,
    required this.length,
  });

  @override
  toString() => 'Word{id: $id, text: $text, length: $length}';

  // Json is a Map<String, dynamic>
  static fromJson(model) => Word(length: model.value, text: model.key);
}
