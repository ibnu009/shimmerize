import 'package:flutter/material.dart';

abstract class PaintingEffect {
  final double startingValue;
  final double endingValue;
  final bool reverse;
  final Duration duration;

  const PaintingEffect({
    this.reverse = false,
    this.startingValue = 0.0,
    this.endingValue = 1.0,
    required this.duration,
  });

  Paint createPaint(double t, Rect rect, TextDirection? textDirection);
  PaintingEffect lerp(PaintingEffect? other, double t);
}
