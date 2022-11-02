import 'package:battle_words/constants/game_details.dart';
import 'package:battle_words/features/single_player_game/data/repositories/game.dart';
import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/single_player_game.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/game_board_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class GameBoardView extends ConsumerWidget {
  GameBoardView({super.key, required this.singlePlayerGame});
  final SinglePlayerGame singlePlayerGame;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> gameBoard = List<Widget>.generate(
      GAME_BOARD_SIZE,
      (row) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          GAME_BOARD_SIZE,
          (col) => GameBoardTileWidget(
            singlePlayerGameTile: singlePlayerGame.gameBoard[row][col],
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
