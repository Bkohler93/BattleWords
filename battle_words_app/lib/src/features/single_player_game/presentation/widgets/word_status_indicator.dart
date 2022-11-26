import 'package:battle_words/src/constants/game_details.dart';
import 'package:battle_words/src/features/single_player_game/domain/game.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class WordStatusIndicatorRow extends StatelessWidget {
  const WordStatusIndicatorRow({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          NUM_HIDDEN_WORDS,
          (index) => WordStatusIndicator(hiddenWordIndex: index),
        ),
      ),
    );
  }
}

class WordStatusIndicator extends StatelessWidget {
  const WordStatusIndicator({Key? key, required this.hiddenWordIndex}) : super(key: key);

  final int hiddenWordIndex;

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SinglePlayerBloc, SinglePlayerState, HiddenWord>(
      selector: (state) {
        return state.hiddenWords[hiddenWordIndex];
      },
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            children: List<Widget>.generate(
              state.word.length,
              (index) => Padding(
                padding: const EdgeInsets.all(8.0),
                child: CustomPaint(
                  painter: CirclePainter(
                    isLetterFound: state.areLettersFound[index],
                  ),
                ),
              ),
            ),
          ),
        );
      },
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
