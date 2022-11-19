import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum PauseStatus { selected, unselected }

class PauseButton extends StatefulWidget {
  const PauseButton({super.key});

  @override
  State<PauseButton> createState() => _PauseButtonState();
}

class _PauseButtonState extends State<PauseButton> with SingleTickerProviderStateMixin {
  late PauseStatus _status;

  @override
  void initState() {
    _status = PauseStatus.unselected;

    super.initState();
  }

  void togglePauseStatus() {
    if (_status == PauseStatus.selected) {
      setState(() {
        _status = PauseStatus.unselected;
      });
    } else {
      setState(() {
        _status = PauseStatus.selected;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: GestureDetector(
        onTap: () {
          togglePauseStatus();
        },
        child: PausePainterAnimation(status: _status),
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

class PausePainterAnimationState extends State<PausePainterAnimation>
    with SingleTickerProviderStateMixin {
  late Animation _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
    );

    _animation = _controller.drive(
      Tween<double>(begin: 0, end: 5.0),
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void didUpdateWidget(covariant PausePainterAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    _controller.reset();

    _animation = _controller.drive(widget.status == PauseStatus.selected
        ? Tween<double>(begin: 0, end: 5)
        : Tween<double>(begin: 5, end: 0))
      ..addListener(() {
        setState(() {});
      });

    _controller.forward();
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
      child: SizedBox(
        width: 15,
        height: 15,
      ),
    );
  }
}

class PausePainter extends CustomPainter {
  PausePainter({required this.changeAmount});
  final double changeAmount;

  @override
  void paint(Canvas canvas, Size size) {
    print(size.width);
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
