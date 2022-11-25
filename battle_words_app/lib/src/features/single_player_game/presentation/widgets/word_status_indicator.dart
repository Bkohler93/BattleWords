import 'package:battle_words/src/features/single_player_game/domain/game.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class WordStatusIndicatorRow extends StatelessWidget {
  const WordStatusIndicatorRow({super.key, required this.singlePlayerGame});
  final SinglePlayerGame singlePlayerGame;
  //TODO BlocBuilder instead of passing SinglePlayerGame as parameter
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          singlePlayerGame.hiddenWords.length,
          (index) => WordStatusIndicator(hiddenWord: singlePlayerGame.hiddenWords[index]),
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
              painter: CirclePainter(
                isLetterFound: hiddenWord.areLettersFound[index],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class CirclePainter extends CustomPainter {
  CirclePainter({required this.isLetterFound});
  final bool isLetterFound;

  @override
  void paint(Canvas canvas, Size size) {
    var dotPaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    canvas.drawCircle(const Offset(0, 0), 5, dotPaint);

    if (isLetterFound) {
      dotPaint
        ..style = PaintingStyle.fill
        ..color = Colors.green;

      canvas.drawCircle(const Offset(0, 0), 5, dotPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
