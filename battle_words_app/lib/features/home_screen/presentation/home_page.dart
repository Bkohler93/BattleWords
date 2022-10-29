import 'package:battle_words/features/home_screen/presentation/controller.dart';
import 'package:battle_words/features/single_player_game/presentation/single_player_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(homePageControllerProvider);
    return Container(
        alignment: Alignment.center,
        child: state.isLoading
            ? const Text("Loading")
            : TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SinglePlayerPage(),
                    ),
                  );
                },
                child: const Text("Play Game"),
              ));
  }
}
