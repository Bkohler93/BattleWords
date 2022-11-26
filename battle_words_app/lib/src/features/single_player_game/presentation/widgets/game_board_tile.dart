import 'package:battle_words/src/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class GameBoardTileWidget extends StatelessWidget {
  const GameBoardTileWidget({Key? key, required this.col, required this.row}) : super(key: key);

  final int col;
  final int row;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SinglePlayerBloc, SinglePlayerState, SinglePlayerGameTile>(
      selector: (state) {
        return state.gameBoard[row][col];
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(3.0),
          child: GestureDetector(
            child: Container(
              alignment: Alignment.center,
              width: 5.h,
              height: 5.h,
              decoration: BoxDecoration(
                border: Border.all(
                  color: state.tileStatus == TileStatus.hidden
                      ? Colors.black38
                      : state.tileStatus == TileStatus.letterFound
                          ? Colors.green.shade100
                          : state.tileStatus == TileStatus.wordFound
                              ? Colors.green.shade500
                              : Colors.black12,
                  width: 3,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(4.0),
                ),
              ),
              child: state.tileStatus == TileStatus.hidden
                  ? Text("")
                  : Text("${state.letter.toUpperCase()}"),
            ),
            onTap: () {
              BlocProvider.of<SinglePlayerBloc>(context)
                  .add(TapGameBoardTileEvent(col: col, row: row));
            },
          ),
        );
      },
    );
  }
}
