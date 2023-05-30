import 'package:battle_words/src/common/widgets/page_layout.dart';
import 'package:battle_words/src/features/multiplayer/presentation/controllers/setup/setup_provider.dart';
import 'package:battle_words/src/features/multiplayer/presentation/widgets/game_board_setup_view.dart';
import 'package:battle_words/src/features/multiplayer/presentation/widgets/word_select_button.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  @override
  void initState() {
    super.initState();
    ref.read(setupStateProvider.notifier).startSetup();
  }

  @override
  Widget build(BuildContext context) {
    List<HiddenWord> hiddenWords =
        ref.watch(setupStateProvider.select((value) => value.hiddenWords));
    return ScreenLayout(
      menuPage: false,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              const Stack(
                alignment: Alignment.center,
                children: [
                  Icon(Icons.pending),
                  Icon(Icons.person),
                ],
              ),
              const Text(
                style: TextStyle(
                  fontSize: 30,
                ),
                "Setup",
              ),
              IconButton(
                icon: const Icon(Icons.pause),
                onPressed: () {
                  //unimp
                },
              ),
            ],
          ),
          const GameBoardSetupView(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 50),
            child: Text(
              textAlign: TextAlign.center,
              "Select and place each word below on your opponent's game board",
            ),
          ),
          Column(
            children: List<Widget>.generate(
              hiddenWords.length,
              (i) => WordSelectButton(word: hiddenWords[i]),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: () {
                    //TODO reset game board to place words again
                  }),
              TextButton(
                onPressed: () {
                  //TODO lock in
                },
                child: const Text("Confirm"),
              ),
              IconButton(
                icon: const Icon(Icons.undo_rounded),
                onPressed: () {
                  //TODO undo last word placement
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
