import 'package:flutter/material.dart';

extension PaintX on Paint {
  Paint copyWith({Color? color, Shader? shader}) {
    return Paint()
      ..color = color ?? (shader != null ? Colors.black : this.color)
      ..shader = shader ?? this.shader
      ..blendMode = blendMode
      ..colorFilter = colorFilter
      ..filterQuality = filterQuality
      ..imageFilter = imageFilter
      ..invertColors = invertColors
      ..isAntiAlias = isAntiAlias
      ..strokeCap = strokeCap
      ..strokeJoin = strokeJoin
      ..maskFilter = maskFilter
      ..strokeWidth = strokeWidth
      ..style = style;
  }
}

extension OffsetsSet on Set<Offset> {
  bool containsFuzzy(Offset offset, {double tolerance = 0.1}) {
    for (final o in this) {
      if ((o.dx - offset.dx).abs() < tolerance &&
          (o.dy - offset.dy).abs() < tolerance) {
        return true;
      }
    }
    return false;
  }
}
