import 'package:flutter/material.dart';

class EnterKey extends StatelessWidget {
  const EnterKey({
    Key? key,
    this.onEnter,
    this.flex = 1,
  }) : super(key: key);

  final VoidCallback? onEnter;
  final int flex;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black45),
              borderRadius: BorderRadius.all(Radius.elliptical(5, 10))),
          child: Material(
            borderRadius: BorderRadius.all(Radius.elliptical(5, 10)),
            child: InkWell(
              onTap: () {
                onEnter?.call();
              },
              child: Container(
                child: Center(child: Text("ENTER")),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
