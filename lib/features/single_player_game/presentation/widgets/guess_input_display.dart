import 'package:battle_words/features/single_player_game/presentation/controllers/guess_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class GuessInputDisplay extends ConsumerWidget {
  const GuessInputDisplay({super.key});

  List<Widget> buildDisplay(String guessInput) {
    List<Widget> widgetList = [];

    // create a new text widget for each letter of guessInput
    for (int i = 0; i < guessInput.length; i++) {
      widgetList.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            guessInput[i],
            style: const TextStyle(
              decoration: TextDecoration.underline,
              fontSize: 30,
            ),
          ),
        ),
      );
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final guessInput = ref.watch(guessWordInputControllerProvider);
    return Container(
      padding: const EdgeInsets.only(bottom: 10),
      alignment: Alignment.center,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "",
            style: TextStyle(
              fontSize: 30,
            ),
          ),
          ...buildDisplay(guessInput)
        ],
      ),
    );
  }
}
