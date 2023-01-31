import 'package:battle_words/src/common/widgets/page_layout.dart';
import 'package:battle_words/src/features/multiplayer/data/matchmaking_repository.dart';
import 'package:battle_words/src/features/multiplayer/data/web_socket_manager.dart';
import 'package:battle_words/src/features/multiplayer/presentation/controllers/matchmaking/matchmaking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router_flow/go_router_flow.dart';

class MatchmakingScreen extends StatelessWidget {
  const MatchmakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MatchmakingRepository(webSocketManager: WebSocketManager()),
      child: BlocProvider<MatchmakingBloc>(
        create: (context) =>
            MatchmakingBloc(matchmakingRepo: RepositoryProvider.of<MatchmakingRepository>(context))
              ..add(InitializeMatchmaking()),
        child: const MatchmakingView(),
      ),
    );
  }
}

class MatchmakingView extends StatefulWidget {
  const MatchmakingView({super.key});

  @override
  State<MatchmakingView> createState() => _MatchmakingViewState();
}

class _MatchmakingViewState extends State<MatchmakingView> {
  final textController = TextEditingController();
  String message = "";

  @override
  Widget build(BuildContext context) {
    return ScreenLayout(
      menuPage: false,
      child: BlocBuilder<MatchmakingBloc, MatchmakingState>(
        builder: (context, state) {
          final matchmakingBloc = BlocProvider.of<MatchmakingBloc>(context);
          if (state.isMatchmakingFindingGame) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
                Text("Finding match"),
              ]),
            );
          } else if (state.isMatchmakingConnecting) {
            return Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: const [
                Text("Connecting"),
              ]),
            );
          } else if (state.isMatchmakingFoundGame) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Found Game"),
                  TextButton(
                    child: const Text(
                      "Ready",
                    ),
                    onPressed: () {
                      print("pressed reaady button");
                      matchmakingBloc.add(PressPlayButton());
                    },
                  )
                ],
              ),
            );
          } else if (state.isMatchmakingReady) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Awaiting opponent to ready up"),
              ],
            ));
          } else if (state.isMatchmakingOpponentTimeout) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  "Opponent failed to respond in time",
                )
              ],
            ));
          } else if (state.isMatchmakingStartGame) {
            //wait for animations to complete on starting game
            Future.delayed(const Duration(seconds: 1), () {
              //TODO send to multiplayer game page
              //context.go('multiplayer-game')
            });
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text("Starting Game"),
              ],
            ));
          } else if (state.isMatchmakingConnectionError) {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Could not connect to server"),
                Column(
                  children: [
                    IconButton(
                      onPressed: () {
                        matchmakingBloc.add(RetryMatchmaking());
                      },
                      icon: const Icon(Icons.refresh),
                    ),
                    const Text("Retry")
                  ],
                ),
                TextButton(
                  onPressed: () {
                    context.go('/multiplayer');
                  },
                  child: const Text("Return to Multiplayer Home"),
                )
              ],
            ));
          } else {
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [Text("Unknown Error")],
            ));
          }
        },
      ),
    );
  }
}
