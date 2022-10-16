import 'package:battle_words/single_player_game/presentation/widgets/game_board_view.dart';
import 'package:battle_words/single_player_game/presentation/widgets/word_status_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SinglePlayerPage extends ConsumerWidget {
  const SinglePlayerPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: Scaffold(
        body: SizedBox.expand(
          child: Column(
            children: [
              GameBoardView(),
              WordStatusIndicatorRow(),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
          ),
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
