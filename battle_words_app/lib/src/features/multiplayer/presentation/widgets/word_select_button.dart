import 'package:battle_words/src/features/multiplayer/presentation/controllers/setup/setup_bloc.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/src/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class WordSelectButton extends StatelessWidget {
  const WordSelectButton({super.key, required this.word});
  final HiddenWord word;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: BlocSelector<SetupBloc, SetupState, HiddenWord>(
        selector: (state) => state.selectedWord,
        builder: (context, state) {
          return IgnorePointer(
            ignoring: state.word == word.word ? true : false,
            child: TextButton(
              onPressed: () =>
                  BlocProvider.of<SetupBloc>(context).add(SelectWordToPlace(word: word)),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all<Size>(
                  Size(70.w, 40),
                ),
                backgroundColor: state.word == word.word
                    ? MaterialStateProperty.all<Color>(
                        colorScheme.onSecondary,
                      )
                    : MaterialStateProperty.all<Color>(colorScheme.secondary),
              ),
              child: Text(word.word),
            ),
          );
        },
      ),
    );
  }
}
