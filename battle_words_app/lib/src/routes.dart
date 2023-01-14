import 'package:battle_words/src/features/home_screen/home.dart';
import 'package:battle_words/src/features/multiplayer/presentation/game.dart';
import 'package:battle_words/src/features/multiplayer/presentation/home.dart';
import 'package:battle_words/src/features/single_player_game/presentation/screens/game.dart';
import 'package:battle_words/src/features/single_player_game/presentation/screens/home.dart';
import 'package:go_router_flow/go_router_flow.dart';

final GoRouter router = GoRouter(routes: [
  GoRoute(path: '/', builder: (context, state) => const HomeScreen(), routes: <GoRoute>[
    GoRoute(
      path: 'single-player',
      builder: (context, state) => const SinglePlayerHomePage(),
      routes: <GoRoute>[
        GoRoute(
          path: 'play',
          builder: (context, state) => const SinglePlayerPage(),
        )
      ],
    ),
    GoRoute(
        path: 'multiplayer',
        builder: (context, state) => const MultiplayerHomeScreen(),
        routes: <GoRoute>[
          GoRoute(
            path: 'profile',
            builder: (context, state) => throw UnimplementedError(),
          ),
          GoRoute(
              path: 'matchmaking',
              builder: (context, state) => const MatchmakingScreen(),
              routes: <GoRoute>[
                GoRoute(
                    path: 'setup',
                    builder: (context, state) => throw UnimplementedError(),
                    routes: [
                      GoRoute(
                        path: 'gameloop',
                        builder: (context, state) => throw UnimplementedError(),
                      )
                    ])
              ])
        ])
  ])
]);
