import 'dart:math';

import 'package:flutter/material.dart';

class QuarterSpinner extends StatefulWidget {
  const QuarterSpinner({
    super.key,
    this.size = 24,
    this.color,
    this.strokeWidth = 3,
  });

  final double size;
  final Color? color;
  final double strokeWidth;

  @override
  State<QuarterSpinner> createState() => _QuarterSpinnerState();
}

class _QuarterSpinnerState extends State<QuarterSpinner>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: _QuarterCirclePainter(
              color: widget.color ?? Theme.of(context).colorScheme.primary,
              strokeWidth: widget.strokeWidth,
              progress: _controller.value,
            ),
          );
        },
      ),
    );
  }
}

class _QuarterCirclePainter extends CustomPainter {
  _QuarterCirclePainter({
    required this.color,
    required this.strokeWidth,
    required this.progress,
  });

  final Color color;
  final double strokeWidth;
  final double progress;

  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = color
          ..strokeWidth = strokeWidth
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    final startAngle = -pi / 2 + (2 * pi * progress);
    const sweepAngle = pi / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(_QuarterCirclePainter oldDelegate) =>
      oldDelegate.progress != progress ||
      oldDelegate.color != color ||
      oldDelegate.strokeWidth != strokeWidth;
}
