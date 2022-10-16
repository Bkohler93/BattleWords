import 'package:battle_words/single_player_game/domain/single_player_state.dart';
import 'package:battle_words/single_player_game/presentation/ui_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordStatusIndicatorRow extends ConsumerWidget {
  const WordStatusIndicatorRow({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<HiddenWord> hiddenWords = ref.read(singlePlayerGameControllerProvider).hiddenWords;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: List<Widget>.generate(
          hiddenWords.length,
          (index) => WordStatusIndicator(hiddenWord: hiddenWords[index]),
        ),
      ),
    );
  }
}

class WordStatusIndicator extends StatelessWidget {
  const WordStatusIndicator({Key? key, required this.hiddenWord}) : super(key: key);

  final HiddenWord hiddenWord;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: List<Widget>.generate(
          hiddenWord.word.length,
          (index) => Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomPaint(
              painter: CirclePainter(),
            ),
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var dotPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(Offset(0, 0), 5, dotPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
