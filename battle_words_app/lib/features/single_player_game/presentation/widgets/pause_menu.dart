import 'package:battle_words/common/controllers/show_pause.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sizer/sizer.dart';

class SinglePlayerPauseMenu extends ConsumerStatefulWidget {
  const SinglePlayerPauseMenu(
      {Key? key, required this.isPauseMenuShowing, required this.closePauseMenu})
      : super(key: key);
  final bool isPauseMenuShowing;
  final Function closePauseMenu;

  @override
  ConsumerState<SinglePlayerPauseMenu> createState() => SinglePlayerPauseMenuState();
}

class SinglePlayerPauseMenuState extends ConsumerState<SinglePlayerPauseMenu> {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      // constraints: BoxConstraints.loose(Size(40.h, 80.w)),
      curve: Curves.linear,
      duration: Duration(milliseconds: 300),
      color: Colors.grey.shade400,
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
                      style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
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
                              child: Text("Continue"),
                              onTap: () {
                                ref
                                    .read(isPauseMenuShowingProvider.notifier)
                                    .update((state) => !state);
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: Text("New Game"),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 24.0),
                            child: Text("Quit"),
                          ),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            )
          : Text(""),
    );
  }
}
