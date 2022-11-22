import 'package:battle_words/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/guess_input.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/single_player_game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class GameResultNotification extends ConsumerWidget {
  const GameResultNotification({super.key, required this.result, required this.hiddenWords});
  final String result;
  final List<HiddenWord> hiddenWords;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      height: 40.h,
      width: 70.w,
      color: Colors.black87,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: (8.h).toDouble()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              result,
              style: const TextStyle(color: Colors.white),
            ),
            (hiddenWords.any((hiddenWord) => !hiddenWord.isWordFound))
                ? Column(children: [
                    Text("Words you missed",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: List.generate(
                        hiddenWords.length,
                        (index) => hiddenWords[index].isWordFound
                            ? SizedBox(
                                height: 1,
                                width: 1,
                              )
                            : Text('${hiddenWords[index].word}',
                                style: TextStyle(
                                  color: Colors.white,
                                )),
                      ),
                    )
                  ])
                : SizedBox(),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: FloatingActionButton.extended(
                onPressed: () {
                  ref.invalidate(singlePlayerGameControllerProvider);
                  ref.invalidate(guessWordInputControllerProvider);
                  Navigator.of(context).pop();
                },
                label: const Text("Main Menu"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
