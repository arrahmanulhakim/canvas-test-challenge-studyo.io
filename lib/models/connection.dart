import 'package:flutter/material.dart';

class Connection {
  final int left;
  final int right;
  final AnimationController controller;
  late final Animation<double> animation;

  Connection({
    required this.left,
    required this.right,
    required TickerProvider vsync,
  }) : controller = AnimationController(
          duration: const Duration(milliseconds: 800),
          vsync: vsync,
        ) {
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    );
    controller.forward();
  }

  void dispose() {
    controller.dispose();
  }
}
