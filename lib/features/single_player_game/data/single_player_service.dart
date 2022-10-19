// ignore_for_file: unused_local_variable

import 'package:battle_words/features/single_player_game/data/single_player_repository.dart';
import 'package:battle_words/features/single_player_game/domain/single_player_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SinglePlayerGameService {
  SinglePlayerGameService(this.ref);
  final Ref ref;

  // ignore: unused_element
  Future<SinglePlayerGame> _fetchSinglePlayerGameService() {
    return ref.read(singlePlayerGameRepositoryProvider).getSinglePlayerGame();
  }

  // ignore: unused_element
  Future<void> _setSinglePlayerGameService() {
    throw UnimplementedError("Implement _getSinglePlayerGameService");

    // ignore: dead_code
    final gameService = ref.read(singlePlayerGameRepositoryProvider).getSinglePlayerGame();
  }
}

final singlePlayerGameServiceProvider = Provider<SinglePlayerGameService>((ref) {
  return SinglePlayerGameService(ref);
});
