import 'package:battle_words/features/single_player_game/domain/game.dart';
import 'package:battle_words/features/single_player_game/presentation/controllers/game_state.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/game_board_view.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/game_result_notification.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/word_status_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

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
        extendBody: true,
        body: state.isLoading
            ? const CircularProgressIndicator()
            : state.hasError
                ? const Text("UH OH")
                : Stack(
                    alignment: Alignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Moves remaining: ${state.value!.movesRemaining}"),
                          GameBoardView(singlePlayerGame: state.value!),
                          WordStatusIndicatorRow(singlePlayerGame: state.value!),
                        ],
                      ),
                      Positioned(
                        top: 30.h,
                        child: state.value!.gameResult == GameResult.loss
                            ? GameResultNotification(result: "Loser!")
                            : state.value!.gameResult == GameResult.win
                                ? GameResultNotification(result: "Winner!")
                                : Text(""),
                      )
                    ],
                  ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
