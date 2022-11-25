import 'package:battle_words/features/single_player_game/presentation/controllers/guess_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//TODO This widget will most likely become a StatefulWidget after having to incoroporate the keyboard and the various controllers for that.
//TODO yes will defeinitely become a statefulWidget because the text has to be here.
class GuessInputDisplay extends StatelessWidget {
  const GuessInputDisplay({super.key});

  List<Widget> buildDisplay(String displayString, GuessWordStatus status) {
    List<Widget> widgetList = [];

    // create a new text widget for each letter of guessInput
    for (int i = 0; i < displayString.length; i++) {
      widgetList.add(
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            displayString[i],
            style: TextStyle(
                decoration: TextDecoration.underline,
                fontSize: 30,
                color: status == GuessWordStatus.validWord ? Colors.black : Colors.red),
          ),
        ),
      );
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    //TODO Use BlocBuilder to do this with SinglePlayerBloc
    // final guessInputState = ref.watch(guessWordInputControllerProvider);
    return Container(
      //TODO This should be Column( with Keyboard as well as ...buildDisplay)
      padding: const EdgeInsets.all(20),
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
          ...buildDisplay("guessWord", GuessWordStatus.noWord)
        ],
      ),
    );
  }
}
