import 'dart:math';

import 'package:flutter/material.dart';

import '../models/connection.dart';

class ConnectorLine extends CustomPainter {
  final List<Connection> connections;
  final double containerSize;
  final double spacing;
  final double screenWidth;
  final double screenHeight;

  ConnectorLine({
    required this.connections,
    required this.containerSize,
    required this.spacing,
    required this.screenWidth,
    required this.screenHeight,
  }) : super(
            repaint: Listenable.merge(
          connections.map((c) => c.animation).toList(),
        ));

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = Colors.purpleAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round;

    double leftColumnX = screenWidth * 0.25 - containerSize / 2;
    double rightColumnX = screenWidth * 0.75 - containerSize / 2;
    double containerSpacing = (screenHeight - 4 * containerSize) / 5;

    for (var connection in connections) {
      final start = Offset(
        leftColumnX + containerSize,
        (connection.left + 1) * containerSpacing +
            connection.left * containerSize +
            containerSize / 2,
      );

      final end = Offset(
        rightColumnX,
        (connection.right + 1) * containerSpacing +
            connection.right * containerSize +
            containerSize / 2,
      );

      var path = Path();
      path.moveTo(start.dx, start.dy);

      double animationValue = connection.animation.value;

      Offset controlPoint1 = Offset(start.dx + (end.dx - start.dx) * 0.4,
          start.dy - (50 * sin(animationValue * 2 * pi)));

      Offset controlPoint2 = Offset(start.dx + (end.dx - start.dx) * 0.6,
          end.dy + (50 * sin(animationValue * 2 * pi + pi)));

      Offset currentEnd = Offset.lerp(start, end, animationValue)!;

      path.cubicTo(
        controlPoint1.dx,
        controlPoint1.dy,
        controlPoint2.dx,
        controlPoint2.dy,
        currentEnd.dx,
        currentEnd.dy,
      );

      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
