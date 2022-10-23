import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:battle_words/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/game_state.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/game_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class GameBoardTileWidget extends ConsumerWidget {
  const GameBoardTileWidget({Key? key, required this.singlePlayerGameTile}) : super(key: key);

  final SinglePlayerGameTile singlePlayerGameTile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int row = singlePlayerGameTile.row;
    int col = singlePlayerGameTile.col;

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        child: Container(
          child: singlePlayerGameTile.isCovered ? Text("") : Text("${singlePlayerGameTile.letter}"),
          alignment: Alignment.center,
          width: 10.w,
          height: 6.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: singlePlayerGameTile.isCovered ? Colors.black38 : Colors.red,
              width: 3,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
        ),
        onTap: () {
          ref.read(singlePlayerGameControllerProvider.notifier).handleTileTap(row: row, col: col);
        },
      ),
    );
  }
}
