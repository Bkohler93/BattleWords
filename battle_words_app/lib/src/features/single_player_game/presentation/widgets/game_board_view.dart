import 'package:battle_words/src/constants/game_details.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/game_board_tile.dart';
import 'package:flutter/material.dart';

class GameBoardView extends StatelessWidget {
  const GameBoardView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> gameBoard = List<Widget>.generate(
      GAME_BOARD_SIZE,
      (row) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          GAME_BOARD_SIZE,
          (col) => GameBoardTileWidget(
            col: col,
            row: row,
          ),
        ),
      ),
      growable: false,
    );

    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          verticalDirection: VerticalDirection.down,
          children: gameBoard,
        ),
      ),
    );
  }
}
