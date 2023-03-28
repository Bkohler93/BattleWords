import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GameBoardSetupTileWidget extends StatelessWidget {
  const GameBoardSetupTileWidget({Key? key, required this.col, required this.row})
      : super(key: key);

  final int col;
  final int row;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

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
            child: Text("")),
        onTap: () {
          throw UnimplementedError("Tapping on tile not implemented");
        },
      ),
    );
  }
}
