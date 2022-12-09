import 'package:objectbox/objectbox.dart';

@Entity()
class SinglePlayerGameModel {
  @Id()
  int id;

  String? jsonStringState;

  SinglePlayerGameModel({required this.jsonStringState, this.id = 0});
}
