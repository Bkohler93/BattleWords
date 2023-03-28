import 'package:battle_words/src/api/shared_preferences/cubit/settings_cubit.dart';
import 'package:battle_words/src/features/single_player_game/domain/game_tile.dart';
import 'package:battle_words/src/features/single_player_game/domain/tile_coords.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/game_board_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SinglePlayerTutorial extends StatelessWidget {
  const SinglePlayerTutorial({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 200,
              child: Column(children: [
                Text(
                    "Your goal is to find three words hidden on a game grid. Each tile looks like the one below. In order to find the words you can either tap on a tile to uncover it, hopefully finding a letter, or you can guess a word using the keyboard and entering 'guess'. After guessing a word, any letters that match the position of a hidden word will be uncovered, with an exact match completely uncovering the word. You have 10 total moves to find all words. If you guess a word exactly right it will not count as a move."),
              ]),
            ),
            TextButton(
              child: const Text('dismiss'),
              onPressed: () {
                BlocProvider.of<SettingsCubit>(context).updateSettings(isFirstLaunch: false);
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  Navigator.pop(context);
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
