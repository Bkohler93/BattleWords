import 'package:flutter/material.dart';

class BackspaceKey extends StatelessWidget {
  const BackspaceKey({
    Key? key,
    this.onBackspace,
    this.flex = 1,
  }) : super(key: key);

  final VoidCallback? onBackspace;
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
          child: Material(
            borderRadius: const BorderRadius.all(Radius.elliptical(5, 10)),
            color: colorScheme.primary,
            child: InkWell(
              onTap: () {
                onBackspace?.call();
              },
              child: const Center(
                child: Icon(
                  Icons.backspace,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
