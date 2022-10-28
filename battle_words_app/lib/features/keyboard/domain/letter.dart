enum LetterStatus { unchecked, complete, incomplete, dne }

class Letter {
  Letter({required this.text, required String strStatus}) {
    if (strStatus == "unchecked") {
      status = LetterStatus.unchecked;
    } else if (strStatus == "incomplete") {
      status = LetterStatus.incomplete;
    } else if (strStatus == "dne") {
      status = LetterStatus.dne;
    } else if (strStatus == "complete") {
      status = LetterStatus.complete;
    }
  }
  final String text;
  late LetterStatus status;
}
