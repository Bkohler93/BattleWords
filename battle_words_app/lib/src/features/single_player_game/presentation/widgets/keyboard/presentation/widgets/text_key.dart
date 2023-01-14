import 'package:battle_words/src/features/single_player_game/presentation/widgets/keyboard/domain/letter.dart';
import 'package:flutter/material.dart';

class TextKey extends StatelessWidget {
  const TextKey({
    Key? key,
    required this.onTextInput,
    this.flex = 1,
    required this.letter,
    required this.status,
  }) : super(key: key);
  final String letter;
  final KeyboardLetterStatus status;
  // final String text;
  final ValueSetter<String> onTextInput;
  final int flex;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: colorScheme.background),
            borderRadius: BorderRadius.all(Radius.elliptical(5, 10)),
          ),
          child: Material(
            surfaceTintColor: colorScheme.tertiary,
            elevation: 5.0,
            borderRadius: BorderRadius.all(Radius.elliptical(5, 10)),
            color: status == KeyboardLetterStatus.unchecked
                ? colorScheme.primary
                : colorScheme.tertiary,
            child: InkWell(
              onTap: () {
                onTextInput.call(letter);
              },
              child: Center(
                child: Text(letter),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
