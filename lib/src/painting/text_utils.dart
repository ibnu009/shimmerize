import 'dart:ui';

Rect lineToRect({
  required LineMetrics line,
  required Offset offset,
  required int numberOfLines,
  required bool justifyMultiLineText,
  required double paragraphWidth,
}) {
  /// approximating the font size
  final fontSize = line.ascent - line.descent;

  /// approximating the font descent
  final fontDescent = line.ascent >= line.height ? 0 : fontSize * .2;

  final lineStart = line.left.round();
  final lineEnd = (line.left + line.width).round();
  final isNotCentered = lineStart == 0 || lineEnd == paragraphWidth;
  final shouldJustify = justifyMultiLineText &&
      isNotCentered &&
      (numberOfLines > 1 && line.lineNumber < (numberOfLines - 1));
  final width = shouldJustify ? paragraphWidth : line.width;
  
  return Rect.fromLTWH(
    shouldJustify ? offset.dx : line.left + offset.dx,
    offset.dy + line.baseline - fontSize,
    width,
    fontSize + fontDescent,
  );
}
