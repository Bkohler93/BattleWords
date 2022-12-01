import 'package:battle_words/src/api/object_box/models/single_player_score.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/score/interface.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'score_state.dart';

class SinglePlayerScoreCubit extends Cubit<SinglePlayerScoreState> {
  SinglePlayerScoreCubit({required this.repository}) : super(SinglePlayerScoreState()) {
    _loadScoreData();
  }
  final ISinglePlayerScoreRepository repository;

  void reloadScoreData() {
    final state = repository.getScoreState();
    emit(state);
  }

  void updateScoreData() {
    repository.setScoreState(state);
    emit(state);
  }

  void handleGameEnd({required GameStatus status}) {
    final state = repository.updateScoreFromGameEnd(status: status);
    emit(state);
  }

  void _loadScoreData() {
    final state = repository.getScoreState();
    emit(state);
  }
}
