import 'package:battle_words/constants/game_details.dart';
import 'package:battle_words/single_player_game/domain/single_player_state.dart';
import 'package:battle_words/single_player_game/presentation/ui_state.dart';
import 'package:battle_words/single_player_game/presentation/widgets/game_board_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameBoardView extends ConsumerWidget {
  const GameBoardView({Key? key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final SinglePlayerGame gameState = ref.read(singlePlayerGameControllerProvider);

    List<Widget> gameBoard = List<Widget>.generate(
      GAME_BOARD_SIZE,
      (row) => Row(
          children: List<Widget>.generate(
        GAME_BOARD_SIZE,
        (col) => GameBoardTileWidget(
          singlePlayerGameTile: SinglePlayerGameTile.from(gameState.gameBoard[row][col]),
        ),
      )),
      growable: false,
    );

    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(children: gameBoard),
    );
  }
}
