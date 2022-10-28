import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class GameResultNotification extends StatefulWidget {
  const GameResultNotification({super.key, required this.result});
  final String result;

  @override
  State<GameResultNotification> createState() => _GameResultNotificationState();
}

class _GameResultNotificationState extends State<GameResultNotification> {
  @override
  Widget build(BuildContext context) {
    print("Building gameresult notification");
    return Container(
      height: 30.h,
      width: 50.w,
      color: Colors.black87,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: (8.h).toDouble()),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              widget.result,
              style: TextStyle(color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: FloatingActionButton.extended(
                onPressed: () => Navigator.of(context).push,
                label: Text("Main Menu"),
              ),
            )
          ],
        ),
      ),
    );
  }
}
