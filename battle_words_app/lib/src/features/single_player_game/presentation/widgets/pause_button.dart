import 'package:flutter/material.dart';

enum PauseStatus { selected, unselected }

class PauseButton extends StatefulWidget {
  const PauseButton(
      {super.key, required this.showOrHidePauseMenu, required this.isPauseMenuShowing});
  final void Function() showOrHidePauseMenu;
  final bool isPauseMenuShowing;

  @override
  State<PauseButton> createState() => _PauseButtonState();
}

/// controls current state of pause button (selected vs unselected)
/// selected - pause menu is open, button is an X
/// unselected - pause menu is closed, button is pause icon ||
class _PauseButtonState extends State<PauseButton> with SingleTickerProviderStateMixin {
  _PauseButtonState();

  @override
  Widget build(BuildContext context) {
    // sizedBox controls the size of the area users can tap on the gesture detector
    return SizedBox(
      width: 50,
      height: 50,
      child: GestureDetector(
        onTap: widget.showOrHidePauseMenu,
        child: PausePainterAnimation(
            status: widget.isPauseMenuShowing ? PauseStatus.selected : PauseStatus.unselected),
      ),
    );
  }
}

class PausePainterAnimation extends StatefulWidget {
  const PausePainterAnimation({super.key, required this.status});
  final PauseStatus status;

  @override
  State<PausePainterAnimation> createState() => PausePainterAnimationState();
}

/// maintains state of animation.
/// _controller uses a ticker to control and move to next frames
/// _animation holds the Tween (inbetween two values) to control current displacement to control icon manipulation
class PausePainterAnimationState extends State<PausePainterAnimation>
    with SingleTickerProviderStateMixin {
  late Animation _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _animation = _controller.drive(
      Tween<double>(begin: 0, end: 0),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(covariant PausePainterAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.status != widget.status) {
      _controller.reset();
      _animation = _controller.drive(widget.status == PauseStatus.selected
          ? Tween<double>(begin: 0, end: 5)
          : Tween<double>(begin: 5, end: 0))
        ..addListener(() {
          setState(() {});
        });

      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: PausePainter(changeAmount: _animation.value),
      child: const SizedBox(
        width: 15,
        height: 15,
      ),
    );
  }
}

///paints the button with current displacement amount to the canvas.
class PausePainter extends CustomPainter {
  PausePainter({required this.changeAmount});
  final double changeAmount;

  @override
  void paint(Canvas canvas, Size size) {
    //* change amount causes the bottom points of the pause icon to swap sides
    final rightP1 = Offset(size.width / 2, size.height / 2);
    final rightP2 = Offset(size.width / 2 - (changeAmount * 3), size.height / 2 + 15);
    final leftP1 = Offset(size.width / 2 - 10 - changeAmount, size.height / 2);
    final leftP2 = Offset(size.width / 2 - 10 + (changeAmount * 2), size.height / 2 + 15);

    final paint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3;
    canvas.drawLine(rightP1, rightP2, paint);
    canvas.drawLine(leftP1, leftP2, paint);
  }

  @override
  bool shouldRepaint(covariant PausePainter oldDelegate) => true;
}
