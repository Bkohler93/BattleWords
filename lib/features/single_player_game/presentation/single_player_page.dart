import 'package:battle_words/features/single_player_game/data/game_repository.dart';
import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/game_state.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/game_board_view.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/word_status_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SinglePlayerPage extends ConsumerWidget {
  const SinglePlayerPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //watch and rebuild when state changes
    final state = ref.watch(singlePlayerGameControllerProvider);
    //display loading here as well using async methods when required
    return SafeArea(
      child: Scaffold(
        body: state.isLoading
            ? const CircularProgressIndicator()
            : state.hasError
                ? const Text("UH OH")
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GameBoardView(singlePlayerGame: state.value!),
                      WordStatusIndicatorRow(singlePlayerGame: state.value!),
                    ],
                  ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
