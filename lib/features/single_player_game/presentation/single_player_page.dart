import 'package:battle_words/features/single_player_game/presentation/widgets/game_board_view.dart';
import 'package:battle_words/features/single_player_game/presentation/widgets/word_status_indicator.dart';
import 'package:flutter/material.dart';

class SinglePlayerPage extends StatelessWidget {
  const SinglePlayerPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            GameBoardView(),
            WordStatusIndicatorRow(),
          ],
        ),
        backgroundColor: Colors.white,
      ),
    );
  }
}
