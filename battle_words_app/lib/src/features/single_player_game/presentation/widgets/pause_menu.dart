import 'package:battle_words/src/features/single_player_game/data/repositories/game/interface.dart';
import 'package:battle_words/src/features/single_player_game/presentation/screens/game.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sizer/sizer.dart';

class SinglePlayerPauseMenu extends StatefulWidget {
  const SinglePlayerPauseMenu({
    Key? key,
    required this.isPauseMenuShowing,
    required this.showOrHidePauseMenu,
    required this.resetGame,
  }) : super(key: key);
  final bool isPauseMenuShowing;
  final Function showOrHidePauseMenu;
  final VoidCallback resetGame;

  @override
  State<SinglePlayerPauseMenu> createState() => SinglePlayerPauseMenuState();
}

class SinglePlayerPauseMenuState extends State<SinglePlayerPauseMenu> {
  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: colorScheme.surface.withAlpha(230),
        boxShadow: [
          BoxShadow(
            blurStyle: BlurStyle.outer,
            blurRadius: 10.0,
            // spreadRadius: 10.0,
            color: colorScheme.surface,
            // offset: Offset.fromDirection(pi * 1 / 4, 5.0),
          )
        ],
      ),
      curve: Curves.linear,
      duration: const Duration(milliseconds: 300),
      height: widget.isPauseMenuShowing ? 40.h : 0.h,
      width: widget.isPauseMenuShowing ? 80.w : 0.w,
      child: widget.isPauseMenuShowing
          ? Column(
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.center,
                    child: Text(
                      "Pause",
                      style: TextStyle(
                          fontSize: 32, fontWeight: FontWeight.w400, color: colorScheme.background),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 30.0),
                      child: ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: GestureDetector(
                              child: Text(
                                "Continue",
                                style: TextStyle(
                                  color: colorScheme.background,
                                ),
                              ),
                              onTap: () {
                                widget.showOrHidePauseMenu();
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: GestureDetector(
                              onTap: () {
                                RepositoryProvider.of<ISinglePlayerRepository>(context).dispose();
                                // widget.resetGame();
                                Navigator.of(context).pop(true);
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => const SinglePlayerPage(),
                                  ),
                                );
                              },
                              child: Text(
                                "New Game",
                                style: TextStyle(
                                  color: colorScheme.background,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: GestureDetector(
                              onTap: () {
                                RepositoryProvider.of<ISinglePlayerRepository>(context).dispose();
                                Navigator.of(context).pop(true);
                              },
                              child: Text(
                                "Quit",
                                style: TextStyle(
                                  color: colorScheme.background,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          : const Text(""),
    );
  }
}
