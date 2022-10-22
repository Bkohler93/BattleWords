import 'package:battle_words/constants/game_details.dart';
import 'package:battle_words/features/single_player_game/data/game_repository.dart';
import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/game_state.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/game_board_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GameBoardView extends ConsumerWidget {
  const GameBoardView({super.key, required this.singlePlayerGame});
  final SinglePlayerGame singlePlayerGame;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    List<Widget> gameBoard = List<Widget>.generate(
      GAME_BOARD_SIZE,
      (row) => Row(
        children: List<Widget>.generate(
          GAME_BOARD_SIZE,
          (col) => GameBoardTileWidget(
            singlePlayerGameTile: singlePlayerGame.gameBoard[row][col],
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