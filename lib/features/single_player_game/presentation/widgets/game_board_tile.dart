import 'package:battle_words/features/single_player_game/domain/single_player_state.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/ui_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class GameBoardTileWidget extends ConsumerWidget {
  const GameBoardTileWidget({Key? key, required this.row, required this.col}) : super(key: key);

  final int row;
  final int col;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final singlePlayerGame = ref.watch(singlePlayerGameControllerProvider);
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
          child: Container(
            alignment: Alignment.center,
            width: 10.w,
            height: 6.h,
            decoration: BoxDecoration(
              border: Border.all(
                color: singlePlayerGame.gameBoard[row][col].isCovered ? Colors.black38 : Colors.red,
                width: 3,
              ),
              borderRadius: const BorderRadius.all(
                Radius.circular(4.0),
              ),
            ),
          ),
          onTap: () {
            ref
                .read(singlePlayerGameControllerProvider.notifier)
                .flipGameBoardTile(row: row, col: col);
          }),
    );
  }
}
