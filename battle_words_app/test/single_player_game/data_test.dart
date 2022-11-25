import 'package:battle_words/constants/game_details.dart';
import 'package:battle_words/features/single_player_game/bloc/single_player_bloc.dart';
import 'package:battle_words/features/single_player_game/data/repositories/game.dart';
import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Test trivial single player repository with no external data sources', () {
    final MockSinglePlayerRepository gameRepository = MockSinglePlayerRepository();

    test('Retrieve a newly generated game', () async {
      final SinglePlayerState game = await gameRepository.getSinglePlayerGame();

      expect(game.hiddenWords[0].word, HARD_CODED_WORDS[0]);
    });
  });
}
