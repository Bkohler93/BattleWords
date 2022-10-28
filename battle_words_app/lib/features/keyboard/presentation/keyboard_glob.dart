import 'package:battle_words/features/keyboard/domain/letter.dart';
import 'package:battle_words/features/keyboard/presentation/widgets/backspace.dart';
import 'package:battle_words/features/keyboard/presentation/widgets/enter_key.dart';
import 'package:battle_words/features/keyboard/presentation/widgets/text_key.dart';
import 'package:flutter/material.dart';

/// Custom Keyboard
///
/// Adapted from [suragch's custom keyboard](https://gist.github.com/suragch/47149f1083fb7a405cdfd18084054c39).
/// This implementation adds a 'guess' button, updates the UI, and refactors, separating
/// the keyboard into multiple widgets in the ./widgets directory
class CustomKeyboard extends StatelessWidget {
  CustomKeyboard({
    Key? key,
    this.onTextInput,
    this.onBackspace,
    this.onGuess,
  }) : super(key: key);

  final ValueSetter<String>? onTextInput; //used to set outside variable with letter on key tapped
  final VoidCallback? onBackspace;
  final VoidCallback? onGuess;

  //* may have to create a state provider for this to update when strStatus gets updated. Create enum for strStatus as well.. and change strStatus name.
  final letterMap = {
    "q": Letter(strStatus: "unchecked", text: "q"),
    "w": Letter(strStatus: "unchecked", text: "w"),
    "e": Letter(strStatus: "unchecked", text: "e"),
    "r": Letter(strStatus: "unchecked", text: "r"),
    "t": Letter(strStatus: "unchecked", text: "t"),
    "y": Letter(strStatus: "unchecked", text: "y"),
    "u": Letter(strStatus: "unchecked", text: "u"),
    "i": Letter(strStatus: "unchecked", text: "i"),
    "o": Letter(strStatus: "unchecked", text: "o"),
    "p": Letter(strStatus: "unchecked", text: "p"),
    "a": Letter(strStatus: "unchecked", text: "a"),
    "s": Letter(strStatus: "unchecked", text: "s"),
    "d": Letter(strStatus: "unchecked", text: "d"),
    "f": Letter(strStatus: "unchecked", text: "f"),
    "g": Letter(strStatus: "unchecked", text: "g"),
    "h": Letter(strStatus: "unchecked", text: "h"),
    "j": Letter(strStatus: "unchecked", text: "j"),
    "k": Letter(strStatus: "unchecked", text: "k"),
    "l": Letter(strStatus: "unchecked", text: "l"),
    "z": Letter(strStatus: "unchecked", text: "z"),
    "x": Letter(strStatus: "unchecked", text: "x"),
    "c": Letter(strStatus: "unchecked", text: "c"),
    "v": Letter(strStatus: "unchecked", text: "v"),
    "b": Letter(strStatus: "unchecked", text: "b"),
    "n": Letter(strStatus: "unchecked", text: "n"),
    "m": Letter(strStatus: "unchecked", text: "m"),
  };

  void _textInputHandler(String text) => onTextInput?.call(text);
  void _backspaceHandler() => onBackspace?.call();
  void _enterHandler() => onGuess?.call();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 4,
      child: Column(
        children: [
          //build each row of keyboard
          buildRowOne(),
          buildRowTwo(),
          buildRowThree(_enterHandler),
          // buildRowFour(),
        ],
      ),
    );
  }

  Expanded buildRowOne() {
    return Expanded(
      child: Row(
        children: [
          TextKey(
            letter: letterMap['q']!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: letterMap['w']!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: letterMap['e']!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: letterMap['r']!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: letterMap['t']!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: letterMap['y']!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: letterMap['u']!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: letterMap['i']!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: letterMap['o']!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: letterMap['p']!,
            onTextInput: _textInputHandler,
          ),
        ],
      ),
    );
  }

  Expanded buildRowTwo() {
    return Expanded(
      child: Row(
        children: [
          SizedBox(width: 15),
          TextKey(
            letter: letterMap['a']!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: letterMap['s']!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: letterMap['d']!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: letterMap['f']!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: letterMap['g']!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: letterMap['h']!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: letterMap['j']!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: letterMap['k']!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: letterMap['l']!,
            onTextInput: _textInputHandler,
          ),
          SizedBox(width: 15),
        ],
      ),
    );
  }

  Expanded buildRowThree(onEnter) {
    return Expanded(
      child: Row(children: [
        EnterKey(flex: 5, onEnter: onEnter),
        TextKey(
          letter: letterMap['z']!,
          flex: 4,
          onTextInput: _textInputHandler,
        ),
        TextKey(
          letter: letterMap['x']!,
          flex: 4,
          onTextInput: _textInputHandler,
        ),
        TextKey(
          letter: letterMap['c']!,
          flex: 4,
          onTextInput: _textInputHandler,
        ),
        TextKey(
          letter: letterMap['v']!,
          flex: 4,
          onTextInput: _textInputHandler,
        ),
        TextKey(
          letter: letterMap['b']!,
          flex: 4,
          onTextInput: _textInputHandler,
        ),
        TextKey(
          letter: letterMap['n']!,
          flex: 4,
          onTextInput: _textInputHandler,
        ),
        TextKey(
          letter: letterMap['m']!,
          flex: 4,
          onTextInput: _textInputHandler,
        ),
        BackspaceKey(
          onBackspace: _backspaceHandler,
          flex: 5,
        ),
      ]),
    );
  }
}
