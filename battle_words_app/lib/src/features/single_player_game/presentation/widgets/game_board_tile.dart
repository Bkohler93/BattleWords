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
    final colorScheme = Theme.of(context).colorScheme;
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
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: state.tileStatus == TileStatus.letterFound
                        ? [colorScheme.inverseSurface, colorScheme.surfaceVariant]
                        : state.tileStatus == TileStatus.hidden
                            ? [colorScheme.primaryContainer, colorScheme.primary]
                            : state.tileStatus == TileStatus.empty
                                ? [
                                    colorScheme.background,
                                    colorScheme.onBackground,
                                  ]
                                : state.tileStatus == TileStatus.wordFound
                                    ? [
                                        colorScheme.onSecondary,
                                        colorScheme.secondary,
                                      ]
                                    : []),
                color: state.tileStatus == TileStatus.letterFound
                    ? colorScheme.inverseSurface
                    : state.tileStatus == TileStatus.wordFound
                        ? colorScheme.secondary
                        : state.tileStatus == TileStatus.empty
                            ? colorScheme.background
                            : colorScheme.primary,
                border: Border.all(
                  color: state.tileStatus == TileStatus.letterFound
                      ? colorScheme.inverseSurface
                      : state.tileStatus == TileStatus.wordFound
                          ? colorScheme.secondary
                          : colorScheme.primaryContainer,
                  width: 3,
                ),
                borderRadius: const BorderRadius.all(
                  Radius.circular(4.0),
                ),
              ),
              child: state.tileStatus == TileStatus.hidden
                  ? const Text("")
                  : Text(
                      state.letter.toUpperCase(),
                      style: TextStyle(
                        color: state.tileStatus == TileStatus.wordFound
                            ? colorScheme.inverseSurface
                            : colorScheme.surface,
                      ),
                    ),
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
