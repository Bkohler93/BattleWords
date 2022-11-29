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
    return Expanded(
      flex: flex,
      child: Padding(
        padding: const EdgeInsets.all(1.0),
        child: Container(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.black45), borderRadius: BorderRadius.all(Radius.elliptical(5, 10))),
          child: Material(
            borderRadius: BorderRadius.all(Radius.elliptical(5, 10)),
            color: Colors.white,
            child: InkWell(
              onTap: () {
                onBackspace?.call();
              },
              child: Container(
                child: Center(
                  child: Icon(Icons.backspace, color: Colors.black87),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
