import 'package:battle_words/src/constants/game_details.dart';
import 'package:battle_words/src/features/multiplayer/presentation/widgets/game_board_setup_tile.dart';
import 'package:flutter/material.dart';

class GameBoardSetupView extends StatelessWidget {
  const GameBoardSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> gameBoard = List<Widget>.generate(
      GAME_BOARD_SIZE,
      (row) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          GAME_BOARD_SIZE,
          (col) => GameBoardSetupTileWidget(
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
