import 'package:battle_words/src/features/home_screen/home.dart';
import 'package:battle_words/src/features/multiplayer/presentation/screens/matchmaking.dart';
import 'package:battle_words/src/features/multiplayer/presentation/screens/home.dart';
import 'package:battle_words/src/features/multiplayer/presentation/screens/profile.dart';
import 'package:battle_words/src/features/multiplayer/presentation/screens/setup.dart';
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
            builder: (context, state) => const MultiplayerProfileScreen(),
          ),
          GoRoute(
            path: 'matchmaking',
            builder: (context, state) => const MatchmakingScreen(),
          ),
          GoRoute(
            path: 'setup',
            builder: (context, state) => const SetupScreen(),
          ),
          GoRoute(
            path: 'play',
            builder: (context, state) => throw UnimplementedError(
                "implement MultiplayerGameScreen"), /* MultiplayerGameScreen */
          ),
        ])
  ])
]);
