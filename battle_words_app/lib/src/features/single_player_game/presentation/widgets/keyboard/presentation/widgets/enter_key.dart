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
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: colorScheme.background),
              borderRadius: const BorderRadius.all(Radius.elliptical(5, 10))),
          // using Material and InkWell acts like GestureDetector but also
          // includes the visual droplet effect.
          child: Material(
            color: colorScheme.primary,
            borderRadius: const BorderRadius.all(Radius.elliptical(5, 10)),
            child: InkWell(
              onTap: () {
                onEnter?.call();
              },
              child: const Center(
                  child: Text(
                "GUESS",
                style: TextStyle(
                  fontSize: 12,
                ),
              )),
            ),
          ),
        ),
      ),
    );
  }
}
