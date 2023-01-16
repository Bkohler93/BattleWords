import 'package:battle_words/src/common/widgets/page_layout.dart';
import 'package:battle_words/src/features/multiplayer/data/repository.dart';
import 'package:battle_words/src/features/multiplayer/presentation/controllers/matchmaking/matchmaking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:web_socket_channel/status.dart' as status;

class MatchmakingScreen extends StatelessWidget {
  const MatchmakingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (context) => MatchmakingRepository(),
      child: BlocProvider<MatchmakingBloc>(
        create: (context) => MatchmakingBloc(matchmakingRepo: RepositoryProvider.of(context))
          ..add(InitializeMatchmaking()),
        child: MatchmakingView(),
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
          if (state.runtimeType == MatchmakingSearching) {
            return Center(
              child: Column(children: const [
                Text("Finding match"),
              ]),
            );
          } else if (state.runtimeType == MatchmakingFoundGame) {
            return Center(
                child: Column(children: [
              const Text("Found Game"),
              TextButton(
                child: const Text(
                  "Ready",
                ),
                onPressed: () => print("pressed reaady button"),
              )
            ]));
          } else if (state.runtimeType == MatchmakingReady) {
            return Center(
                child: Column(
              children: const [
                Text("Awaiting opponent to ready up"),
              ],
            ));
          } else if (state.runtimeType == MatchmakingOpponentTimeout) {
            return Center(
                child: Column(
              children: const [
                Text(
                  "Opponent failed to respond in time",
                )
              ],
            ));
          } else {
            return Center(
                child: Column(
              children: const [Text("Error")],
            ));
          }
        },
      ),
    );
  }
}
