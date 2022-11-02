import 'package:battle_words/features/single_player_game/presentation/controllers/guess_input.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/keyboard_letters.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/single_player_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class GameResultNotification extends ConsumerWidget {
  const GameResultNotification({super.key, required this.result});
  final String result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 30.h,
      width: 50.w,
      color: Colors.black87,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: (8.h).toDouble()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              result,
              style: TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  ref.invalidate(singlePlayerGameControllerProvider);
                  ref.invalidate(keyboardLettersControllerProvider);
                  ref.invalidate(guessWordInputControllerProvider);
                  Navigator.of(context).pop();
                },
                label: Text("Main Menu"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
