import 'package:battle_words/src/api/object_box/object_box.dart';
import 'package:battle_words/src/common/widgets/page_layout.dart';
import 'package:battle_words/src/features/multiplayer/data/setup_repository.dart';
import 'package:battle_words/src/features/multiplayer/presentation/controllers/setup/setup_bloc.dart';
import 'package:battle_words/src/features/multiplayer/presentation/widgets/game_board_setup_view.dart';
import 'package:battle_words/src/features/multiplayer/presentation/widgets/word_select_button.dart';
import 'package:battle_words/src/features/single_player_game/data/repositories/hidden_words/interface.dart';
import 'package:battle_words/src/features/single_player_game/domain/hidden_word.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SetupRepository(),
      child: BlocProvider<SetupBloc>(
        create: (context) => SetupBloc(
          setupRepo: RepositoryProvider.of<SetupRepository>(context),
          hiddenWordsRepo: HiddenWordsRepository(
            store: RepositoryProvider.of<ObjectBoxStore>(context),
          ),
        )..add(InitializeSetup()),
        child: const SetupView(),
      ),
    );
  }
}

class SetupView extends StatelessWidget {
  const SetupView({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      menuPage: false,
      child: BlocListener<SetupBloc, SetupState>(
        listener: (context, state) {
          if (state.status.isStartSetup) {
            print("start setup!");
          }
        },
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
                  onPressed: () => BlocProvider.of<SetupBloc>(context).add(PressedPauseButton()),
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
            BlocSelector<SetupBloc, SetupState, List<HiddenWord>>(
              selector: (state) => state.hiddenWords,
              builder: (context, state) {
                return Column(
                  children:
                      List<Widget>.generate(state.length, (i) => WordSelectButton(word: state[i])),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: const Icon(Icons.refresh_rounded),
                  onPressed: () => BlocProvider.of<SetupBloc>(context).add(PressedRefreshButton()),
                ),
                TextButton(
                  onPressed: () => BlocProvider.of<SetupBloc>(context).add(PressedConfirmButton()),
                  child: const Text("Confirm"),
                ),
                IconButton(
                  icon: const Icon(Icons.undo_rounded),
                  onPressed: () => BlocProvider.of<SetupBloc>(context).add(PressedUndoButton()),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
