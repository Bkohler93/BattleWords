import 'package:battle_words/src/features/multiplayer/presentation/controllers/setup/setup_provider.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/src/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class WordSelectButton extends ConsumerWidget {
  const WordSelectButton({super.key, required this.word});
  final HiddenWord word;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    HiddenWord selectedWord = ref.watch(setupStateProvider.select((value) => value.selectedWord));
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: IgnorePointer(
          ignoring: selectedWord.word == word.word
              ? true
              : !word.direction.isUnassigned
                  ? true
                  : false,
          child: TextButton(
            onPressed: () => ref.read(setupStateProvider.notifier).selectWordToPlace(word),
            style: ButtonStyle(
              minimumSize: MaterialStateProperty.all<Size>(
                Size(70.w, 40),
              ),
              backgroundColor: !word.direction.isUnassigned
                  ? MaterialStateProperty.all<Color>(colorScheme.onSurface)
                  : selectedWord.word == word.word
                      ? MaterialStateProperty.all<Color>(
                          colorScheme.onSecondary,
                        )
                      : MaterialStateProperty.all<Color>(colorScheme.secondary),
            ),
            child: Text(word.word),
          ),
        ));
  }
}
