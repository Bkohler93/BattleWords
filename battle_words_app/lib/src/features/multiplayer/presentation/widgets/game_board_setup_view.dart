import 'package:battle_words/src/constants/game_details.dart';
import 'package:battle_words/src/features/multiplayer/presentation/controllers/setup/setup_bloc.dart';
import 'package:battle_words/src/features/multiplayer/presentation/widgets/arrow_painter.dart';
import 'package:battle_words/src/features/multiplayer/presentation/widgets/game_board_setup_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GameBoardSetupView extends StatelessWidget {
  const GameBoardSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    List<Widget> gameBoard = List<Widget>.generate(
      GAME_BOARD_SIZE,
      (row) => Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          GAME_BOARD_SIZE,
          (col) => GameBoardSetupTileWidget(
            col: col,
            row: row,
          ),
        ),
      ),
      growable: false,
    );

    return Container(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Column(
              verticalDirection: VerticalDirection.down,
              children: gameBoard,
            ),
            Positioned.fill(
              child: LayoutBuilder(
                builder: (BuildContext context, BoxConstraints constraints) {
                  return BlocSelector<SetupBloc, SetupState, SelectedGameCoords>(
                    selector: (state) {
                      return state.selectedCoords;
                    },
                    builder: (context, state) {
                      return SizedBox(
                        width: constraints.maxWidth,
                        height: constraints.maxHeight,
                        child: IgnorePointer(
                          child: CustomPaint(
                            painter: state.isSelected
                                ? ArrowPainter(col: state.col!, row: state.row!)
                                : null,
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
