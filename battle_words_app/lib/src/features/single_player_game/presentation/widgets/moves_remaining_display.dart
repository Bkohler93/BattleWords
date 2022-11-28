import 'package:battle_words/src/features/single_player_game/presentation/bloc/single_player_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovesRemaining extends StatelessWidget {
  const MovesRemaining({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocSelector<SinglePlayerBloc, SinglePlayerState, int>(
      selector: ((state) => state.movesRemaining),
      builder: ((context, state) => Text('Moves remaining: $state')),
    );
  }
}
