import 'package:battle_words/features/keyboard/domain/letter.dart';
import 'package:flutter/material.dart';

class TextKey extends StatelessWidget {
  const TextKey({
    Key? key,
    required this.letter,
    this.onTextInput,
    this.flex = 1,
  }) : super(key: key);
  final Letter letter;
  // final String text;
  final ValueSetter<String>? onTextInput;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.black45),
            borderRadius: BorderRadius.all(Radius.elliptical(5, 10)),
          ),
          child: Material(
            surfaceTintColor: Colors.black87,
            elevation: 5.0,
            borderRadius: BorderRadius.all(Radius.elliptical(5, 10)),
            color: letter.status == LetterStatus.unchecked
                ? Colors.white
                : letter.status == LetterStatus.complete
                    ? Colors.green.shade300
                    : letter.status == LetterStatus.incomplete
                        ? Colors.yellow.shade300
                        : Colors.red.shade300,
            child: InkWell(
              onTap: () {
                onTextInput?.call(letter.text);
              },
              child: Container(
                child: Center(child: Text(letter.text)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
