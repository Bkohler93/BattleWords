import 'package:battle_words/src/common/widgets/keyboard/domain/letter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class KeyboardLettersController extends StateNotifier<Map<String, KeyboardLetterStatus>> {
  KeyboardLettersController()
      : super({
          "q": KeyboardLetterStatus.unchecked,
          "w": KeyboardLetterStatus.unchecked,
          "e": KeyboardLetterStatus.unchecked,
          "r": KeyboardLetterStatus.unchecked,
          "t": KeyboardLetterStatus.unchecked,
          "y": KeyboardLetterStatus.unchecked,
          "u": KeyboardLetterStatus.unchecked,
          "i": KeyboardLetterStatus.unchecked,
          "o": KeyboardLetterStatus.unchecked,
          "p": KeyboardLetterStatus.unchecked,
          "a": KeyboardLetterStatus.unchecked,
          "s": KeyboardLetterStatus.unchecked,
          "d": KeyboardLetterStatus.unchecked,
          "f": KeyboardLetterStatus.unchecked,
          "g": KeyboardLetterStatus.unchecked,
          "h": KeyboardLetterStatus.unchecked,
          "j": KeyboardLetterStatus.unchecked,
          "k": KeyboardLetterStatus.unchecked,
          "l": KeyboardLetterStatus.unchecked,
          "z": KeyboardLetterStatus.unchecked,
          "x": KeyboardLetterStatus.unchecked,
          "c": KeyboardLetterStatus.unchecked,
          "v": KeyboardLetterStatus.unchecked,
          "b": KeyboardLetterStatus.unchecked,
          "n": KeyboardLetterStatus.unchecked,
          "m": KeyboardLetterStatus.unchecked,
        });

  void uncoverLetters(String word) {
    var map = _copy(state);

    //

    for (var i = 0; i < word.length; i++) {
      map[word[i]] = KeyboardLetterStatus.complete;
    }

    state = map;
  }

  Map<String, KeyboardLetterStatus> _copy(Map<String, KeyboardLetterStatus> map) => {
        "q": map["q"]!,
        "w": map["w"]!,
        "e": map["e"]!,
        "r": map["r"]!,
        "t": map["t"]!,
        "y": map["y"]!,
        "u": map["u"]!,
        "i": map["i"]!,
        "o": map["o"]!,
        "p": map["p"]!,
        "a": map["a"]!,
        "s": map["s"]!,
        "d": map["d"]!,
        "f": map["f"]!,
        "g": map["g"]!,
        "h": map["h"]!,
        "j": map["j"]!,
        "k": map["k"]!,
        "l": map["l"]!,
        "z": map["z"]!,
        "x": map["x"]!,
        "c": map["c"]!,
        "v": map["v"]!,
        "b": map["b"]!,
        "n": map["n"]!,
        "m": map["m"]!,
      };
}
