import 'package:battle_words/src/common/widgets/page_layout.dart';
import 'package:battle_words/src/features/multiplayer/data/matchmaking_repository.dart';
import 'package:battle_words/src/api/web_socket_channel/web_socket_manager.dart';
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
      child: BlocConsumer<MatchmakingBloc, MatchmakingState>(
        listener: (context, state) {
          if (state.isMatchmakingStartGame) {
            //wait for animations to complete before navigating
            Future.delayed(const Duration(seconds: 1), () {
              //TODO send to multiplayer game page
              context.go('/multiplayer/setup');
            });
          }
        },
        builder: (context, state) {
          final matchmakingBloc = BlocProvider.of<MatchmakingBloc>(context);
          if (state.isMatchmakingFindingGame) {
            return const Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text("Finding match"),
              ]),
            );
          } else if (state.isMatchmakingConnecting) {
            return const Center(
              child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                      matchmakingBloc.add(PressPlayButton());
                    },
                  )
                ],
              ),
            );
          } else if (state.isMatchmakingReady) {
            return const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Waiting for opponent"),
              ],
            ));
          } else if (state.isMatchmakingOpponentTimeout) {
            return const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Opponent failed to respond in time",
                )
              ],
            ));
          } else if (state.isMatchmakingStartGame) {
            return const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
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
          } else if (state.isMatchmakingAwaitingOpponentReady) {
            return const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Waiting for opponent"),
              ],
            ));
          } else {
            return const Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Text("Unknown Error")],
            ));
          }
        },
      ),
    );
  }
}
