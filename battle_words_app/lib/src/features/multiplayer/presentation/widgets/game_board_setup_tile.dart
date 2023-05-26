import 'package:battle_words/src/features/multiplayer/domain/setup_gameboard_tile.dart';
import 'package:battle_words/src/features/multiplayer/presentation/controllers/setup/setup_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

enum DragDirection { right, down, invalid }

extension DragDirectionX on DragDirection {
  bool get isRight => this == DragDirection.right;
  bool get isDown => this == DragDirection.down;
  bool get isInvalid => this == DragDirection.invalid;
}

class GameBoardSetupTileWidget extends StatefulWidget {
  const GameBoardSetupTileWidget({Key? key, required this.col, required this.row})
      : super(key: key);

  final int col;
  final int row;

  @override
  State<GameBoardSetupTileWidget> createState() => _GameBoardSetupTileWidgetState();
}

class _GameBoardSetupTileWidgetState extends State<GameBoardSetupTileWidget> {
  int tileSize = 5;
  double tileOpacity = 1;
  DragDirection? lastDragDirection;

  void selectTile() {
    setState(() {
      tileOpacity = 0.8;
    });
    BlocProvider.of<SetupBloc>(context).add(SelectTile(row: widget.row, col: widget.col));
  }

  void deselectTile() {
    BlocProvider.of<SetupBloc>(context).add(ReleaseTile(
      widget.col,
      widget.row,
      dragDirection: lastDragDirection!,
    ));
    setState(() {
      tileOpacity = 1;
      lastDragDirection = null;
    });
  }

  void attemptToPlaceWord() {
    //TODO check if to the right or below selected tile
    // try to place word
    // BlocProvider.of<SetupBloc>(context).add(AttemptToPlaceWord());
    // if placed
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    SetupBloc bloc = BlocProvider.of<SetupBloc>(context);
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        child: Opacity(
          opacity: tileOpacity,
          child: BlocSelector<SetupBloc, SetupState, SetupGameBoardTile>(
            selector: (state) {
              return state.gameBoard[widget.row][widget.col];
            },
            builder: (context, state) {
              print(state.letter);
              return Container(
                alignment: Alignment.center,
                width: tileSize.h,
                height: tileSize.h,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [colorScheme.primaryContainer, colorScheme.primary]),
                  color: colorScheme.primary,
                  border: Border.all(
                    color: colorScheme.primaryContainer,
                    width: 3,
                  ),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(4.0),
                  ),
                ),
                child: Text(
                  state.letter,
                  style: TextStyle(
                    color: state.status.isFits
                        ? Colors.white
                        : state.status.isError
                            ? Colors.red
                            : Colors.black,
                  ),
                ),
              );
            },
          ),
        ),
        onLongPressDown: (details) {
          selectTile();
          //TODO cause arrows to display to aid user in placement of word
        },
        onLongPressMoveUpdate: (details) {
          if (bloc.wordIsSelected()) {
            // attemptToPlaceWord();
            double dx = details.localOffsetFromOrigin.dx;
            double dy = details.localOffsetFromOrigin.dy;
            DragDirection currentDragDirection;

            if (dx < 0 && dy < 0) {
              currentDragDirection = DragDirection.invalid;
            } else if (dx > dy) {
              currentDragDirection = DragDirection.right;
            } else {
              currentDragDirection = DragDirection.down;
            }

            if (currentDragDirection != lastDragDirection) {
              if (currentDragDirection != DragDirection.invalid) {
                BlocProvider.of<SetupBloc>(context).add(
                    AttemptToPlaceWord(widget.col, widget.row, direction: currentDragDirection));
              }
              setState(() {
                lastDragDirection = currentDragDirection;
              });
            } else {
              //Do nothing
            }
          }
        },
        onLongPressEnd: (details) {
          deselectTile();
          //TODO cause arrows to disappear, try to place word.
        },
        onHorizontalDragDown: (details) {
          selectTile();
        },
        onHorizontalDragUpdate: (details) {
          attemptToPlaceWord();
        },
        onHorizontalDragEnd: (details) {
          deselectTile();
        },
        onVerticalDragDown: (details) {
          selectTile();
        },
        onVerticalDragUpdate: (details) {
          attemptToPlaceWord();
        },
        onVerticalDragEnd: (details) {
          deselectTile();
        },
      ),
    );
  }
}
