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
class Keyboard extends StatelessWidget {
  Keyboard({
    Key? key,
    required this.onTextInput,
    required this.onBackspace,
    required this.onGuess,
    required this.letterMap,
  }) : super(key: key);

  final ValueSetter<String> onTextInput; //used to set outside variable with letter on key tapped
  final VoidCallback onBackspace;
  final VoidCallback onGuess;
  final Map<String, KeyboardLetterStatus> letterMap;

  //* may have to create a state provider for this to update when strStatus gets updated. Create enum for strStatus as well.. and change strStatus name.
  // final letterMap = {
  //   "q": Letter(strStatus: "unchecked", text: "q"),
  //   "w": Letter(strStatus: "unchecked", text: "w"),
  //   "e": Letter(strStatus: "unchecked", text: "e"),
  //   "r": Letter(strStatus: "unchecked", text: "r"),
  //   "t": Letter(strStatus: "unchecked", text: "t"),
  //   "y": Letter(strStatus: "unchecked", text: "y"),
  //   "u": Letter(strStatus: "unchecked", text: "u"),
  //   "i": Letter(strStatus: "unchecked", text: "i"),
  //   "o": Letter(strStatus: "unchecked", text: "o"),
  //   "p": Letter(strStatus: "unchecked", text: "p"),
  //   "a": Letter(strStatus: "unchecked", text: "a"),
  //   "s": Letter(strStatus: "unchecked", text: "s"),
  //   "d": Letter(strStatus: "unchecked", text: "d"),
  //   "f": Letter(strStatus: "unchecked", text: "f"),
  //   "g": Letter(strStatus: "unchecked", text: "g"),
  //   "h": Letter(strStatus: "unchecked", text: "h"),
  //   "j": Letter(strStatus: "unchecked", text: "j"),
  //   "k": Letter(strStatus: "unchecked", text: "k"),
  //   "l": Letter(strStatus: "unchecked", text: "l"),
  //   "z": Letter(strStatus: "unchecked", text: "z"),
  //   "x": Letter(strStatus: "unchecked", text: "x"),
  //   "c": Letter(strStatus: "unchecked", text: "c"),
  //   "v": Letter(strStatus: "unchecked", text: "v"),
  //   "b": Letter(strStatus: "unchecked", text: "b"),
  //   "n": Letter(strStatus: "unchecked", text: "n"),
  //   "m": Letter(strStatus: "unchecked", text: "m"),
  // };

  void _textInputHandler(String text) => onTextInput.call(text);
  void _backspaceHandler() => onBackspace.call();
  void _enterHandler() => onGuess.call();

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
            status: letterMap["q"]!,
            letter: "q",
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: "w",
            status: letterMap["w"]!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: "e",
            status: letterMap["e"]!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: "r",
            status: letterMap["r"]!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: "t",
            status: letterMap["t"]!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: "y",
            status: letterMap["y"]!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            status: letterMap["u"]!,
            letter: "u",
            onTextInput: _textInputHandler,
          ),
          TextKey(
            status: letterMap["i"]!,
            letter: "i",
            onTextInput: _textInputHandler,
          ),
          TextKey(
            status: letterMap["o"]!,
            letter: "o",
            onTextInput: _textInputHandler,
          ),
          TextKey(
            status: letterMap["p"]!,
            letter: "p",
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
            letter: 'a',
            status: letterMap["a"]!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: "s",
            status: letterMap["s"]!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            status: letterMap["d"]!,
            letter: "d",
            onTextInput: _textInputHandler,
          ),
          TextKey(
            status: letterMap["f"]!,
            letter: "f",
            onTextInput: _textInputHandler,
          ),
          TextKey(
            status: letterMap["g"]!,
            letter: "g",
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: "h",
            status: letterMap["h"]!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            status: letterMap["j"]!,
            letter: "j",
            onTextInput: _textInputHandler,
          ),
          TextKey(
            letter: "k",
            status: letterMap["k"]!,
            onTextInput: _textInputHandler,
          ),
          TextKey(
            status: letterMap["l"]!,
            letter: "l",
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
          letter: 'z',
          status: letterMap['z']!,
          flex: 4,
          onTextInput: _textInputHandler,
        ),
        TextKey(
          status: letterMap["x"]!,
          letter: "x",
          flex: 4,
          onTextInput: _textInputHandler,
        ),
        TextKey(
          letter: "c",
          status: letterMap["c"]!,
          flex: 4,
          onTextInput: _textInputHandler,
        ),
        TextKey(
          status: letterMap["v"]!,
          letter: "v",
          flex: 4,
          onTextInput: _textInputHandler,
        ),
        TextKey(
          status: letterMap["b"]!,
          letter: "b",
          flex: 4,
          onTextInput: _textInputHandler,
        ),
        TextKey(
          status: letterMap["n"]!,
          letter: "n",
          flex: 4,
          onTextInput: _textInputHandler,
        ),
        TextKey(
          status: letterMap["m"]!,
          letter: "m",
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
