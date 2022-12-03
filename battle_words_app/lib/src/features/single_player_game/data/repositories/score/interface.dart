import 'dart:async';
import 'dart:typed_data';

import 'package:battle_words/src/api/object_box/models/single_player_score.dart';
import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:battle_words/src/features/single_player_game/presentation/controllers/score/score_cubit.dart';
import 'package:objectbox/objectbox.dart';
part 'object_box.dart';

abstract class ISinglePlayerScoreRepository {
  SinglePlayerScoreState getScoreState();
  void setScoreState(SinglePlayerScoreState state);
  SinglePlayerScoreState updateScoreFromGameEnd({required GameStatus status});
  FutureOr<void> init();
}
