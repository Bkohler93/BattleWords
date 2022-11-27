import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';

abstract class GameManagerRequestObject {}

class GetSinglePlayerGame extends GameManagerRequestObject {}

class SetSinglePlayerGame extends GameManagerRequestObject {
  SetSinglePlayerGame({required this.state});
  final SinglePlayerState state;
}

class UpdateGameByTileTap extends GameManagerRequestObject {
  UpdateGameByTileTap({required this.col, required this.row});
  final int col;
  final int row;
}

class UpdateGameByGuessingWord extends GameManagerRequestObject {
  UpdateGameByGuessingWord({required this.word});
  final String word;
}

class SendObjectBoxStore extends GameManagerRequestObject {
  SendObjectBoxStore({required this.store});
  final ObjectBoxStore store;
}

class GameOver extends GameManagerRequestObject {}
