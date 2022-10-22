import 'package:battle_words/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class WordStatusIndicatorRow extends ConsumerWidget {
  const WordStatusIndicatorRow({super.key, required this.singlePlayerGame});
  final SinglePlayerGame singlePlayerGame;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
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

    canvas.drawCircle(const Offset(0, 0), 5, dotPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
