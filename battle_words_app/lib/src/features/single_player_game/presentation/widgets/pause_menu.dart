import 'package:battle_words/src/common/controllers/show_pause.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SinglePlayerPauseMenu extends StatefulWidget {
  const SinglePlayerPauseMenu(
      {Key? key, required this.isPauseMenuShowing, required this.showOrHidePauseMenu})
      : super(key: key);
  final bool isPauseMenuShowing;
  final Function showOrHidePauseMenu;

  @override
  State<SinglePlayerPauseMenu> createState() => SinglePlayerPauseMenuState();
}

class SinglePlayerPauseMenuState extends State<SinglePlayerPauseMenu> {
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
                                widget.showOrHidePauseMenu();
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
