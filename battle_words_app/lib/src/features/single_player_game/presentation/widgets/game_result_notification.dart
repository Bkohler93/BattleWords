import 'package:battle_words/src/features/single_player_game/domain/game.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

//* take out the required parameters, access them using BlocBuilder
class GameResultNotification extends StatelessWidget {
  const GameResultNotification({super.key, required this.result});
  final GameStatus result;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40.h,
      width: 70.w,
      color: Colors.black87,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: (8.h).toDouble()),
        child: BlocSelector<SinglePlayerBloc, SinglePlayerState, List<HiddenWord>>(
          selector: (state) => state.hiddenWords,
          builder: (context, state) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  result == GameResult.win ? "Winner" : "Loser",
                  style: const TextStyle(color: Colors.white),
                ),
                (state.any((hiddenWord) => !hiddenWord.isWordFound))
                    ? Column(children: [
                        Text("Words you missed",
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: List.generate(
                            state.length,
                            (index) => state[index].isWordFound
                                ? SizedBox(
                                    height: 1,
                                    width: 1,
                                  )
                                : Text('${state[index].word}',
                                    style: TextStyle(
                                      color: Colors.white,
                                    )),
                          ),
                        )
                      ])
                    : SizedBox(),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: FloatingActionButton.extended(
                    onPressed: () {
                      //send ResetGameEvent to SinglePlayerBloc
                      // ref.invalidate(singlePlayerGameControllerProvider);
                      // ref.invalidate(guessWordInputControllerProvider);
                      Navigator.of(context).pop();
                    },
                    label: const Text("Main Menu"),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
