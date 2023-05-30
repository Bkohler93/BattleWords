import 'package:battle_words/src/features/multiplayer/domain/setup_gameboard_tile.dart';
import 'package:battle_words/src/features/multiplayer/presentation/controllers/setup/setup_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

enum DragDirection { right, down, invalid }

extension DragDirectionX on DragDirection {
  bool get isRight => this == DragDirection.right;
  bool get isDown => this == DragDirection.down;
  bool get isInvalid => this == DragDirection.invalid;
}

class GameBoardSetupTileWidget extends ConsumerStatefulWidget {
  const GameBoardSetupTileWidget({Key? key, required this.col, required this.row})
      : super(key: key);

  final int col;
  final int row;

  @override
  GameBoardSetupTileWidgetState createState() => GameBoardSetupTileWidgetState();
}

class GameBoardSetupTileWidgetState extends ConsumerState<GameBoardSetupTileWidget> {
  int tileSize = 5;
  double tileOpacity = 1;
  DragDirection lastDragDirection = DragDirection.invalid;

  void selectTile() {
    setState(() {
      tileOpacity = 0.8;
    });
    ref.read(setupStateProvider.notifier).selectTile(row: widget.row, col: widget.col);
  }

  void deselectTile() {
    ref
        .read(setupStateProvider.notifier)
        .releaseTile(row: widget.row, col: widget.col, dragDirection: lastDragDirection);
    setState(() {
      tileOpacity = 1;
      lastDragDirection = DragDirection.invalid;
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
    SetupGameBoardTile tile =
        ref.watch(setupStateProvider.select((value) => value.gameBoard[widget.row][widget.col]));
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: GestureDetector(
        child: Opacity(
          opacity: tileOpacity,
          child: Container(
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
              tile.letter,
              style: TextStyle(
                color: tile.status.isFits
                    ? Colors.white
                    : tile.status.isError
                        ? Colors.red
                        : Colors.black,
              ),
            ),
          ),
        ),
        // onLongPressDown: (details) {
        //   selectTile();
        //   //TODO cause arrows to display to aid user in placement of word
        // },
        // onLongPressMoveUpdate: (details) {

        // onLongPressEnd: (details) {
        //   deselectTile();
        // },
        // onHorizontalDragDown: (details) {
        //   selectTile();
        // },
        // onHorizontalDragUpdate: (details) {
        //   if (ref.read(setupStateProvider.notifier).wordIsSelected()) {
        //     double dx = details.delta.dx;
        //     double dy = details.delta.dy;
        //     DragDirection currentDragDirection;

        //     if (dx < 0 && dy < 0) {
        //       currentDragDirection = DragDirection.invalid;
        //     } else {
        //       currentDragDirection = DragDirection.right;
        //     }

        //     if (currentDragDirection != lastDragDirection) {
        //       if (currentDragDirection != DragDirection.invalid) {
        //         print("trying to place word");
        //         ref.read(setupStateProvider.notifier).attemptToPlaceWord(
        //             col: widget.col, row: widget.row, dragDirection: currentDragDirection);
        //       }
        //       setState(() {
        //         lastDragDirection = currentDragDirection;
        //       });
        //     } else {
        //       //Do nothing
        //     }
        //   }
        //   // attemptToPlaceWord();
        // },
        // onHorizontalDragEnd: (details) {
        //   deselectTile();
        // },
        // onVerticalDragDown: (details) {
        //   selectTile();
        // },
        // onVerticalDragUpdate: (details) {
        //   if (ref.read(setupStateProvider.notifier).wordIsSelected()) {
        //     double dx = details.delta.dx;
        //     double dy = details.delta.dy;
        //     DragDirection currentDragDirection;

        //     if (dx < 0 && dy < 0) {
        //       currentDragDirection = DragDirection.invalid;
        //     } else if (dx > dy) {
        //       currentDragDirection = DragDirection.right;
        //     } else {
        //       currentDragDirection = DragDirection.down;
        //     }

        //     if (currentDragDirection != lastDragDirection) {
        //       if (currentDragDirection != DragDirection.invalid) {
        //         ref.read(setupStateProvider.notifier).attemptToPlaceWord(
        //             col: widget.col, row: widget.row, dragDirection: currentDragDirection);
        //       }
        //       setState(() {
        //         lastDragDirection = currentDragDirection;
        //       });
        //     } else {
        //       //Do nothing
        //     }
        //   }
        //   // attemptToPlaceWord();
        //   attemptToPlaceWord();
        // },
        // onVerticalDragEnd: (details) {
        //   deselectTile();
        // },
        onPanDown: (details) {
          selectTile();
        },
        onPanUpdate: (details) {
          // print("panUpdate dx=${details.delta.dx}\tdy=${details.delta.dy}");
          if (ref.read(setupStateProvider.notifier).wordIsSelected()) {
            double dx = details.delta.dx;
            double dy = details.delta.dy;
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
                ref.read(setupStateProvider.notifier).attemptToPlaceWord(
                    col: widget.col, row: widget.row, dragDirection: currentDragDirection);
              }
              setState(() {
                lastDragDirection = currentDragDirection;
              });
            } else {
              //Do nothing
            }
          }
        },
        onPanEnd: (details) {
          deselectTile();
        },
      ),
    );
  }
}
