import 'package:battle_words/src/features/multiplayer/presentation/controllers/setup/setup_provider.dart';
import 'package:battle_words/src/features/multiplayer/presentation/controllers/setup/setup_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TileAnimation extends ConsumerWidget {
  const TileAnimation({super.key, required this.constraints});

  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    SelectedGameCoords selectedCoords =
        ref.watch(setupStateProvider.select((value) => value.selectedCoords));
    return SizedBox(
      width: constraints.maxWidth,
      height: constraints.maxHeight,
      child: IgnorePointer(
        child: CustomPaint(
          painter: selectedCoords.isSelected
              ? ArrowPainter(col: selectedCoords.col!, row: selectedCoords.row!)
              : null,
        ),
      ),
    );
  }
}

class ArrowPainter extends CustomPainter {
  final int col;
  final int row;

  ArrowPainter({required this.col, required this.row});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.fill;

    final rect = Rect.fromLTWH(
      col * size.width / 6,
      row * size.height / 6,
      size.width / 6,
      size.height / 6,
    );

    canvas.drawOval(rect, paint);
  }

  @override
  bool shouldRepaint(ArrowPainter oldDelegate) => col != oldDelegate.col || row != oldDelegate.row;
}
