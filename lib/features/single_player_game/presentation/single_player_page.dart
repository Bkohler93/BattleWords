import 'package:battle_words/features/single_player_game/data/single_player_repository.dart';
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
    ref.read(singlePlayerGameRepositoryProvider).loadSinglePlayerGame();
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
