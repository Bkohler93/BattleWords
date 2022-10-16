import 'package:battle_words/single_player_game/data/single_player_repository.dart';
import 'package:battle_words/single_player_game/domain/single_player_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SinglePlayerGameController extends StateNotifier<SinglePlayerGame> {
  SinglePlayerGameController(super.state, {required this.singlePlayerGame});

  final SinglePlayerGame singlePlayerGame;

  void flipGameBoardTile() {}
}
