import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:battle_words/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/single_player_game.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/game_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class GameBoardTileWidget extends ConsumerWidget {
  const GameBoardTileWidget({Key? key, required this.singlePlayerGameTile}) : super(key: key);

  final SinglePlayerGameTile singlePlayerGameTile;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int row = singlePlayerGameTile.coordinates.row;
    int col = singlePlayerGameTile.coordinates.col;

    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        child: Container(
          child: singlePlayerGameTile.tileStatus == TileStatus.hidden
              ? Text("")
              : Text("${singlePlayerGameTile.letter.toUpperCase()}"),
          alignment: Alignment.center,
          width: 11.w,
          height: 7.h,
          decoration: BoxDecoration(
            border: Border.all(
              color: singlePlayerGameTile.tileStatus == TileStatus.hidden
                  ? Colors.black38
                  : singlePlayerGameTile.tileStatus == TileStatus.letterFound
                      ? Colors.green.shade100
                      : singlePlayerGameTile.tileStatus == TileStatus.wordFound
                          ? Colors.green.shade500
                          : Colors.black12,
              width: 3,
            ),
            borderRadius: const BorderRadius.all(
              Radius.circular(4.0),
            ),
          ),
        ),
        onTap: () {
          print('=== row: $row, col: $col');
          ref.read(singlePlayerGameControllerProvider.notifier).handleTileTap(row: row, col: col);
        },
      ),
    );
  }
}
