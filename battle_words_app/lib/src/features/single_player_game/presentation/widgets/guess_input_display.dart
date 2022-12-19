import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/hidden_words/interface.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:battle_words/src/features/single_player_game/presentation/controllers/guess_display/display_string_cubit.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/keyboard/presentation/keyboard.dart';
import 'package:battle_words/src/helpers/data_types.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GuessInputDisplay extends StatelessWidget {
  const GuessInputDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) =>
          HiddenWordsRepository(store: RepositoryProvider.of<ObjectBoxStore>(context)),
      child: BlocProvider(
        create: (context) =>
            DisplayStringCubit(repository: RepositoryProvider.of<HiddenWordsRepository>(context)),
        child: GuessInputDisplayView(),
      ),
    );
  }
}

//TODO
//* 5 States, also need access to these fields: String displayString, GuessInputState displayState

//* 1 - Normal State: regular black text, will be the state as new characters are added/removed

//* 2 - Abnormal State: regular black text, shake at start, notify that word is too short/long/nonexistent
//* 3 - Invalid State: red text, word is not real
//* 4 - Previously Guessed State: yellow-similar text, already guessed (FUNCTIONALITY NOT IMPLEMENTED)
//* 5 - Guessing State: maybe animate the text away, this means the guessed word has been sent to the GameManager to create the next game state.
class GuessInputDisplayView extends StatelessWidget {
  const GuessInputDisplayView({super.key});

  List<Widget> buildDisplay(String displayString, DisplayStringStatus status) {
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
                color: status.isInvalid
                    ? Colors.red
                    : status.isPreviouslyGuessed
                        ? Colors.amber
                        : status.isGuessing
                            ? Colors.green
                            : status.isIncorrectLength
                                ? Colors.purple
                                : Colors.black),
          ),
        ),
      );
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    /// BlocBuilder provides the keyboardLetterMap for the Keyboard widget.
    return BlocBuilder<DisplayStringCubit, DisplayStringState>(
      builder: (context, state) {
        return Column(
          children: [
            Container(
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
                  ...buildDisplay(
                    state.displayString,
                    state.displayStringStatus,
                  )
                ],
              ),
            ),
            BlocListener<DisplayStringCubit, DisplayStringState>(
              listener: (context, state) {
                if (state.displayStringStatus.isGuessing) {
                  BlocProvider.of<SinglePlayerBloc>(context).add(
                    GuessWordEvent(
                      word: state.displayString,
                    ),
                  );
                  BlocProvider.of<DisplayStringCubit>(context).resetDisplay();
                }
              },
              child: Container(),
            ),
            BlocSelector<SinglePlayerBloc, SinglePlayerState, KeyboardLetterMap>(
              selector: (state) {
                return state.keyboardLetterMap;
              },
              builder: (context, state) {
                return Keyboard(
                  onBackspace: () {
                    BlocProvider.of<DisplayStringCubit>(context).handleTapBackspace();
                  },
                  onGuess: () {
                    BlocProvider.of<DisplayStringCubit>(context).handleTapGuess();
                  },
                  onTextInput: (text) {
                    BlocProvider.of<DisplayStringCubit>(context).handleTextInput(text);
                  },
                  letterMap: state,
                );
              },
            ),
          ],
        );
      },
    );
  }
}
