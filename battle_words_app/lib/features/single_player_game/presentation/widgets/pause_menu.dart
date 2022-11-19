import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class SinglePlayerPauseMenu extends StatefulWidget {
  SinglePlayerPauseMenu({Key? key}) : super(key: key);

  @override
  State<SinglePlayerPauseMenu> createState() => SinglePlayerPauseMenuState();
}

class SinglePlayerPauseMenuState extends State<SinglePlayerPauseMenu>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade400,
      height: 40.h,
      width: 80.w,
      child: Column(
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
            child: Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(left: 30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24.0),
                      child: Text("Continue"),
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
      ),
    );
  }
}
