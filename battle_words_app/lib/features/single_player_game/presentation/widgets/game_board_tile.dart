import 'package:battle_words/features/single_player_game/bloc/single_player_bloc.dart';
import 'package:battle_words/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/single_player_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

//TODO This class will require two parameters, int col and int row. These will be used when communicating with SinglePlayerBloc to identify which tile this is
class GameBoardTileWidget extends StatelessWidget {
  const GameBoardTileWidget(
      {Key? key,
      // required this.singlePlayerGameTile,
      required this.row,
      required this.col})
      : super(key: key);

  // final SinglePlayerGameTile singlePlayerGameTile;
  final int col;
  final int row;

  @override
  Widget build(BuildContext context) {
    // int row = singlePlayerGameTile.coordinates.row;
    // int col = singlePlayerGameTile.coordinates.col;

    //TODO Add BlocBuilder, maybe BlocConsumer with fucntion down there
    return BlocSelector<SinglePlayerBloc, SinglePlayerState, SinglePlayerGameTile>(
      selector: (state) {
        return state.gameBoard[col][row];
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
              //TODO Bloc TileTapEvent
              print('=== row: , col: ');
              // ref.read(singlePlayerGameControllerProvider.notifier).handleTileTap(row: row, col: col);
            },
          ),
        );
      },
    );
  }
}
