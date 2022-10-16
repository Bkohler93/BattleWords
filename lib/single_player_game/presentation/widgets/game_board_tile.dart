import 'package:battle_words/single_player_game/domain/single_player_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class GameBoardTileWidget extends ConsumerWidget {
  const GameBoardTileWidget({Key? key, required this.singlePlayerGameTile}) : super(key: key);

  final SinglePlayerGameTile singlePlayerGameTile;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: Container(
        alignment: Alignment.center,
        width: 10.w,
        height: 6.h,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black38, width: 3),
          borderRadius: BorderRadius.all(
            Radius.circular(4.0),
          ),
        ),
      ),
    );
  }
}
