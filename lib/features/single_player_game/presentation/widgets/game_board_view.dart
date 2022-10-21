import 'package:battle_words/constants/game_details.dart';
import 'package:battle_words/features/single_player_game/data/single_player_repository.dart';
import 'package:battle_words/features/single_player_game/domain/single_player_state.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/game_state.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/game_board_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameBoardView extends ConsumerWidget {
  const GameBoardView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gameBoardState = ref.read(singlePlayerGameRepositoryProvider).mockSinglePlayerGame();

    List<Widget> gameBoard = List<Widget>.generate(
      GAME_BOARD_SIZE,
      (row) => Row(
        children: List<Widget>.generate(
          GAME_BOARD_SIZE,
          (col) => GameBoardTileWidget(
            singlePlayerGameTile: gameBoardState.gameBoard[row][col],
          ),
        ),
      ),
      growable: false,
    );

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(children: gameBoard),
    );
  }
}
