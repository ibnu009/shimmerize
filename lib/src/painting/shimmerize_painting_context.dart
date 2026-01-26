import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmerize/shimmerize.dart';
import 'package:shimmerize/src/painting/text_utils.dart';
import 'package:shimmerize/src/utils/utils.dart';

class ShimmerizePaintingContext extends PaintingContext {
  ShimmerizePaintingContext({
    required this.layer,
    required Rect estimatedBounds,
    required this.shaderPaint,
    required this.config,
    required this.isCustom,
    required this.animationValue,
  }) : super(layer, estimatedBounds);

  final ShimmerizeConfigData config;
  final double animationValue;

  /// Whether the painting is custom
  bool isCustom;

  final ContainerLayer layer;

  /// The [Paint] that is used to draw the placeholder
  final Paint shaderPaint;

  late final _treatedAsOverride = <Offset>{};

  void createDefaultContext(Rect rect, Painter paint) {
    final context = PaintingContext(layer, rect);
    paint(context, rect.topLeft);
    context.stopRecordingIfNeeded();
  }

  void createOverrideContext(Rect rect, Painter painter) {
    final context = OverridePaintingContext(
      layer: layer,
      shaderPaint: shaderPaint,
      config: config,
      estimatedBounds: rect,
    );
    painter(context, rect.topLeft);
    context.stopRecordingIfNeeded();
  }

  bool _didPaint = false;

  @override
  ui.Canvas get canvas =>
      isCustom ? super.canvas : ShimmerizeCanvas(super.canvas, this);

  @override
  PaintingContext createChildContext(ContainerLayer childLayer, ui.Rect bounds) {
    return ShimmerizePaintingContext(
      layer: childLayer,
      estimatedBounds: bounds,
      shaderPaint: shaderPaint,
      config: config,
      isCustom: isCustom,
      animationValue: animationValue,
    );
  }

  @override
  void stopRecordingIfNeeded() {
    super.stopRecordingIfNeeded();
    _didPaint = false;
    _treatedAsOverride.clear();
  }

  @override
  void paintChild(RenderObject child, ui.Offset offset) {
    if (!isCustom && child is RenderObjectWithChildMixin) {
      final key = child.paintBounds.shift(offset).center;
      final subChild = child.child;
      var treatAsOverride =
          subChild == null ||
          (subChild is RenderIgnoredShimmer && subChild.enabled);
      if (child is RenderSemanticsAnnotations) {
        treatAsOverride |= child.properties.button == true;
      }
      if (treatAsOverride) {
        _treatedAsOverride.add(key);
      }
    }
    _paintChild(child, offset);
  }

  void _paintChild(RenderObject child, ui.Offset offset) {
    assert(() {
      debugOnProfilePaint?.call(child);
      return true;
    }());

    if (!kReleaseMode && debugProfilePaintsEnabled) {
      Map<String, String>? debugTimelineArguments;
      assert(() {
        if (debugEnhancePaintTimelineArguments) {
          debugTimelineArguments = child.toDiagnosticsNode().toTimelineArguments();
        }
        return true;
      }());
      FlutterTimeline.startSync('$runtimeType', arguments: debugTimelineArguments);
    }
    child.paint(this, offset);
    if (!kReleaseMode && debugProfilePaintsEnabled) {
      FlutterTimeline.finishSync();
    }
  }
}

/// A [Canvas] that draws a placeholder that represents the actual content
class ShimmerizeCanvas implements Canvas {
  /// Default constructor
  ShimmerizeCanvas(this.parent, this.context);

  /// The [ShimmerizePaintingContext] that controls the painting process
  final ShimmerizePaintingContext context;

  Paint get _shaderPaint => context.shaderPaint;

  ShimmerizeConfigData get _config => context.config;

  /// The parent [Canvas] that handles drawing operations
  final Canvas parent;

  /// Draws a rectangle on the canvas where the [paragraph]
  /// would otherwise be rendered
  @override
  void drawParagraph(ui.Paragraph paragraph, ui.Offset offset) {
    context._didPaint = true;
    final lines = paragraph.computeLineMetrics();

    for (var i = 0; i < lines.length; i++) {
      final rect = lineToRect(
        line: lines[i],
        offset: offset,
        numberOfLines: lines.length,
        justifyMultiLineText: _config.justifyMultiLineText,
        paragraphWidth: paragraph.width,
      );

      final borderRadius = _config.textBorderRadius.usesHeightFactor
          ? BorderRadius.circular((rect.height) * _config.textBorderRadius.heightPercentage!)
          : _config.textBorderRadius.borderRadius?.resolve(TextDirection.ltr);

      if (borderRadius != null) {
        final borderShape = _config.textBorderRadius.borderShape;
        switch (borderShape) {
          case TextBoneBorderShape.roundedRectangle:
            parent.drawRRect(borderRadius.toRRect(rect), _shaderPaint);
            break;
          case TextBoneBorderShape.roundedSuperellipse:
            parent.drawRSuperellipse(borderRadius.toRSuperellipse(rect), _shaderPaint);
            break;
        }
      } else {
        parent.drawRect(rect, _shaderPaint);
      }
    }
  }

  @override
  void clipPath(ui.Path path, {bool doAntiAlias = true}) => parent.clipPath(path, doAntiAlias: doAntiAlias);

  @override
  void clipRRect(ui.RRect rrect, {bool doAntiAlias = true}) => parent.clipRRect(rrect, doAntiAlias: doAntiAlias);

  @override
  void clipRect(
    ui.Rect rect, {
    ui.ClipOp clipOp = ui.ClipOp.intersect,
    bool doAntiAlias = true,
  }) =>
      parent.clipRect(rect, clipOp: clipOp, doAntiAlias: doAntiAlias);

  @override
  void drawArc(
    ui.Rect rect,
    double startAngle,
    double sweepAngle,
    bool useCenter,
    ui.Paint paint,
  ) =>
      parent.drawArc(rect, startAngle, sweepAngle, useCenter, paint);

  @override
  void drawAtlas(
    ui.Image atlas,
    List<ui.RSTransform> transforms,
    List<ui.Rect> rects,
    List<ui.Color>? colors,
    ui.BlendMode? blendMode,
    ui.Rect? cullRect,
    ui.Paint paint,
  ) =>
      parent.drawAtlas(
        atlas,
        transforms,
        rects,
        colors,
        blendMode,
        cullRect,
        paint,
      );

  @override
  void drawColor(ui.Color color, ui.BlendMode blendMode) {
    context._didPaint = true;
    parent.drawColor(color, blendMode);
  }

  @override
  void drawDRRect(ui.RRect outer, ui.RRect inner, ui.Paint paint) {
    context._didPaint = true;
    final treatAsBone = context._treatedAsOverride.containsFuzzy(outer.center);
    if (paint.color.a == 0 &&
        !treatAsBone &&
        (_config.ignoreContainers || _config.containersColor == null)) {
      return;
    }
    if (treatAsBone) {
      parent.drawDRRect(
        outer,
        inner,
        paint.copyWith(
          shader: _shaderPaint.shader,
        ),
      );
    } else if (!_config.ignoreContainers) {
      if (_config.containersColor != null) {
        parent.drawDRRect(
          outer,
          inner,
          paint.copyWith(
            color: _config.containersColor!,
          ),
        );
      } else {
        parent.drawDRRect(outer, inner, paint);
      }
    }
  }

  @override
  void drawImage(ui.Image image, ui.Offset offset, ui.Paint paint) {
    context._didPaint = true;
    parent.drawRect(
      (offset & Size(image.width.toDouble(), image.height.toDouble())),
      _shaderPaint,
    );
  }

  @override
  void drawImageNine(
    ui.Image image,
    ui.Rect center,
    ui.Rect dst,
    ui.Paint paint,
  ) {
    context._didPaint = true;
    parent.drawRect(dst, _shaderPaint);
  }

  @override
  void drawImageRect(
    ui.Image image,
    ui.Rect src,
    ui.Rect dst,
    ui.Paint paint,
  ) {
    context._didPaint = true;
    parent.drawRect(dst, _shaderPaint);
  }

  @override
  void drawLine(ui.Offset p1, ui.Offset p2, ui.Paint paint) {
    context._didPaint = true;
    parent.drawLine(p1, p2, paint);
  }

  @override
  void drawOval(ui.Rect rect, ui.Paint paint) {
    context._didPaint = true;
    parent.drawOval(rect, paint);
  }

  @override
  void drawPaint(ui.Paint paint) {
    context._didPaint = true;
    parent.drawPaint(paint);
  }

  @override
  void drawPicture(ui.Picture picture) {
    context._didPaint = true;
    parent.drawPicture(picture);
  }

  @override
  void drawPoints(
    ui.PointMode pointMode,
    List<ui.Offset> points,
    ui.Paint paint,
  ) {
    context._didPaint = true;
    parent.drawPoints(pointMode, points, paint);
  }

  @override
  void drawPath(ui.Path path, ui.Paint paint) {
    context._didPaint = true;
    final treatAsBone = context._treatedAsOverride.containsFuzzy(path.getBounds().center);
    if (paint.color.a == 0 &&
        !treatAsBone &&
        (_config.ignoreContainers || _config.containersColor == null)) {
      return;
    }
    if (treatAsBone) {
      parent.drawPath(path, paint.copyWith(shader: _shaderPaint.shader));
    } else if (!_config.ignoreContainers) {
      if (_config.containersColor != null) {
        parent.drawPath(path, paint.copyWith(color: _config.containersColor!));
      } else {
        parent.drawPath(path, paint);
      }
    }
  }

  @override
  void drawRect(ui.Rect rect, ui.Paint paint) {
    context._didPaint = true;
    final treatAsBone = context._treatedAsOverride.containsFuzzy(rect.center);
    if (paint.color.a == 0 &&
        !treatAsBone &&
        (_config.ignoreContainers || _config.containersColor == null)) {
      return;
    }
    if (treatAsBone) {
      parent.drawRect(rect, paint.copyWith(shader: _shaderPaint.shader));
    } else if (!_config.ignoreContainers) {
      if (_config.containersColor != null) {
        parent.drawRect(rect, paint.copyWith(color: _config.containersColor!));
      } else {
        parent.drawRect(rect, paint);
      }
    }
  }

  @override
  void drawRRect(ui.RRect rrect, ui.Paint paint) {
    context._didPaint = true;
    final treatAsBone = context._treatedAsOverride.containsFuzzy(rrect.center);
    if (paint.color.a == 0 &&
        !treatAsBone &&
        (_config.ignoreContainers || _config.containersColor == null)) {
      return;
    }
    if (treatAsBone) {
      parent.drawRRect(rrect, paint.copyWith(shader: _shaderPaint.shader));
    } else if (!_config.ignoreContainers) {
      if (_config.containersColor != null) {
        parent.drawRRect(rrect, paint.copyWith(color: _config.containersColor!));
      } else {
        parent.drawRRect(rrect, paint);
      }
    }
  }

  @override
  void drawCircle(ui.Offset c, double radius, ui.Paint paint) {
    context._didPaint = true;
    final treatAsBone = context._treatedAsOverride.containsFuzzy(c);
    if (paint.color.a == 0 &&
        !treatAsBone &&
        (_config.ignoreContainers || _config.containersColor == null)) {
      return;
    }
    if (treatAsBone) {
      parent.drawCircle(c, radius, paint.copyWith(shader: _shaderPaint.shader));
    } else if (!_config.ignoreContainers) {
      if (_config.containersColor != null) {
        parent.drawCircle(c, radius, paint.copyWith(color: _config.containersColor!));
      } else {
        parent.drawCircle(c, radius, paint);
      }
    }
  }

  @override
  void drawRawAtlas(
    ui.Image atlas,
    Float32List rstTransforms,
    Float32List rects,
    Int32List? colors,
    ui.BlendMode? blendMode,
    ui.Rect? cullRect,
    ui.Paint paint,
  ) {
    context._didPaint = true;
    parent.drawRawAtlas(
      atlas,
      rstTransforms,
      rects,
      colors,
      blendMode,
      cullRect,
      paint,
    );
  }

  @override
  void drawRawPoints(
    ui.PointMode pointMode,
    Float32List points,
    ui.Paint paint,
  ) {
    context._didPaint = true;
    parent.drawRawPoints(pointMode, points, _shaderPaint);
  }

  @override
  void drawShadow(
    ui.Path path,
    ui.Color color,
    double elevation,
    bool transparentOccluder,
  ) {
    if (!_config.ignoreContainers) {
      context._didPaint = true;
      parent.drawShadow(path, color, elevation, transparentOccluder);
    }
  }

  @override
  void drawVertices(
    ui.Vertices vertices,
    ui.BlendMode blendMode,
    ui.Paint paint,
  ) {
    context._didPaint = true;
    parent.drawVertices(vertices, blendMode, _shaderPaint);
  }

  @override
  int getSaveCount() => parent.getSaveCount();

  @override
  void restore() => parent.restore();

  @override
  void rotate(double radians) => parent.rotate(radians);

  @override
  void save() => parent.save();

  @override
  void saveLayer(ui.Rect? bounds, ui.Paint paint) => parent.saveLayer(bounds, paint);

  @override
  void scale(double sx, [double? sy]) => parent.scale(sx, sy);

  @override
  void skew(double sx, double sy) => parent.skew(sx, sy);

  @override
  void transform(Float64List matrix4) => parent.transform(matrix4);

  @override
  void translate(double dx, double dy) => parent.translate(dx, dy);

  @override
  ui.Rect getDestinationClipBounds() => parent.getDestinationClipBounds();

  @override
  ui.Rect getLocalClipBounds() => parent.getLocalClipBounds();

  @override
  Float64List getTransform() => parent.getTransform();

  @override
  void restoreToCount(int count) => parent.restoreToCount(count);

  @override
  void clipRSuperellipse(ui.RSuperellipse rse, {bool doAntiAlias = true}) =>
      parent.clipRSuperellipse(rse, doAntiAlias: doAntiAlias);

  @override
  void drawRSuperellipse(ui.RSuperellipse rse, ui.Paint paint) {
    context._didPaint = true;
    parent.drawRSuperellipse(rse, paint);
  }
}

/// A [PaintingContext] that marks all children as Overrides
/// and stops painting after first paintable child
class OverridePaintingContext extends ShimmerizePaintingContext {
  /// Default constructor
  OverridePaintingContext({
    required super.layer,
    required super.estimatedBounds,
    required super.shaderPaint,
    required super.config,
  }) : super(isCustom: false, animationValue: 0);

  @override
  void paintChild(RenderObject child, ui.Offset offset) {
    if (!_didPaint) {
      _treatedAsOverride.add(child.paintBounds.shift(offset).center);
      child.paint(this, offset);
    }
  }
}
