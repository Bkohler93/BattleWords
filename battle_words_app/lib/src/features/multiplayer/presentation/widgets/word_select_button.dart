import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class WordSelectButton extends StatelessWidget {
  const WordSelectButton({super.key, required this.word});
  final HiddenWord word;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextButton(
        onPressed: () => throw UnimplementedError("Implement button press"),
        style: ButtonStyle(
          minimumSize: MaterialStateProperty.all<Size>(
            Size(70.w, 40),
          ),
        ),
        child: Text(word.word),
      ),
    );
  }
}
