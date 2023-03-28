import 'package:battle_words/src/common/widgets/page_layout.dart';
import 'package:battle_words/src/features/multiplayer/data/setup_repository.dart';
import 'package:battle_words/src/api/web_socket_channel/web_socket_manager.dart';
import 'package:battle_words/src/features/multiplayer/presentation/controllers/setup/setup_bloc.dart';
import 'package:battle_words/src/features/multiplayer/presentation/widgets/game_board_setup_view.dart';
import 'package:battle_words/src/features/single_player_game/presentation/widgets/game_board_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class SetupScreen extends StatelessWidget {
  const SetupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => SetupRepository(webSocketManager: WebSocketManager()),
      child: BlocProvider<SetupBloc>(
        create: (context) => SetupBloc(setupRepo: RepositoryProvider.of<SetupRepository>(context))
          ..add(InitializeSetup()),
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
          if (state.isServerSaidHi) {
            print("server said hi!");
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                Icon(Icons.person),
                Text(
                  style: TextStyle(
                    fontSize: 30,
                  ),
                  "Setup",
                ),
                Icon(Icons.pause),
              ],
            ),
            GameBoardSetupView(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Text(
                textAlign: TextAlign.center,
                "Select and place each word below on your opponent's game board",
              ),
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: TextButton(
                    onPressed: () => throw UnimplementedError("Implement button press"),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(70.w, 40),
                      ),
                    ),
                    child: const Text("Sauce"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextButton(
                    onPressed: () => throw UnimplementedError("Implement button press"),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(70.w, 40),
                      ),
                    ),
                    child: const Text("Sauce"),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: TextButton(
                    onPressed: () => throw UnimplementedError("Implement button press"),
                    style: ButtonStyle(
                      minimumSize: MaterialStateProperty.all<Size>(
                        Size(70.w, 40),
                      ),
                    ),
                    child: const Text("Sauce"),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Icon(Icons.refresh_rounded),
                TextButton(
                  onPressed: () => throw UnimplementedError("implement confirm button"),
                  child: Text("Confirm"),
                ),
                Icon(
                  Icons.undo_rounded,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
