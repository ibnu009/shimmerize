import 'package:flutter/material.dart';
import 'package:shimmerize/src/effects/painting_effect.dart';

class PulseEffect extends PaintingEffect {
  final Color from;
  final Color to;

  const PulseEffect({
    this.from = const Color(0xFFf4f4f4),
    this.to = const Color(0xFFe5e5e5),
    super.startingValue,
    super.endingValue,
    super.duration = const Duration(milliseconds: 1000),
  }) : super(reverse: true);

  @override
  Paint createPaint(double t, Rect rect, TextDirection? textDirection) {
    final color = Color.lerp(from, to, t)!;
    return Paint()
      ..shader = LinearGradient(
        colors: [color, color],
      ).createShader(rect);
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PulseEffect &&
          runtimeType == other.runtimeType &&
          from == other.from &&
          to == other.to &&
          duration == other.duration;

  @override
  int get hashCode => from.hashCode ^ to.hashCode ^ duration.hashCode;

  @override
  PaintingEffect lerp(PaintingEffect? other, double t) {
    if (other is PulseEffect) {
      return PulseEffect(
        from: Color.lerp(from, other.from, t)!,
        to: Color.lerp(to, other.to, t)!,
        duration: duration,
      );
    }
    return this;
  }
}
