import 'package:flutter/rendering.dart';
import 'package:shimmerize/shimmerize.dart';
import 'package:shimmerize/src/painting/shimmerize_painting_context.dart';

/// Builds a renderer object that overrides the painting operation
/// and provides a [ShimmerizePaintingContext] to paint the shimmer effect
class RenderShimmerize extends RenderProxyBox
    with _RenderShimmerBase<RenderBox> {
  /// Default constructor
  RenderShimmerize({
    required TextDirection textDirection,
    required double animationValue,
    required ShimmerizeConfigData config,
    required bool ignorePointers,
    required bool isCustom,
    RenderBox? child,
  })  : _animationValue = animationValue,
        _textDirection = textDirection,
        _config = config,
        _isCustom = isCustom,
        _ignorePointers = ignorePointers,
        super(child);

  TextDirection _textDirection;

  @override
  TextDirection get textDirection => _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsPaint();
    }
  }

  ShimmerizeConfigData _config;

  @override
  ShimmerizeConfigData get config => _config;

  set config(ShimmerizeConfigData value) {
    if (_config != value) {
      _config = value;
      markNeedsPaint();
    }
  }

  bool _ignorePointers;

  set ignorePointers(bool value) {
    if (_ignorePointers != value) {
      _ignorePointers = value;
      markNeedsPaint();
    }
  }

  bool _isCustom;

  set isCustom(bool value) {
    if (_isCustom != value) {
      _isCustom = value;
      markNeedsPaint();
    }
  }

  @override
  bool get isCustom => _isCustom;

  double _animationValue = 0;

  @override
  double get animationValue => _animationValue;

  set animationValue(double value) {
    if (_animationValue != value) {
      _animationValue = value;
      markNeedsPaint();
    }
  }

  @override
  bool hitTest(BoxHitTestResult result, {required Offset position}) {
    if (_ignorePointers) return false;
    return super.hitTest(result, position: position);
  }
}

/// Builds a sliver renderer object that overrides the painting operation
/// and provides a [ShimmerizePaintingContext] to paint the shimmer effect
class RenderSliverShimmerize extends RenderProxySliver
    with _RenderShimmerBase<RenderSliver> {
  /// Default constructor
  RenderSliverShimmerize({
    required TextDirection textDirection,
    required double animationValue,
    required ShimmerizeConfigData config,
    required bool ignorePointers,
    required bool isCustom,
    RenderSliver? child,
  })  : _animationValue = animationValue,
        _textDirection = textDirection,
        _config = config,
        _isCustom = isCustom,
        _ignorePointers = ignorePointers,
        super(child);

  TextDirection _textDirection;

  @override
  TextDirection get textDirection => _textDirection;

  set textDirection(TextDirection value) {
    if (_textDirection != value) {
      _textDirection = value;
      markNeedsPaint();
    }
  }

  ShimmerizeConfigData _config;

  @override
  ShimmerizeConfigData get config => _config;

  set config(ShimmerizeConfigData value) {
    if (_config != value) {
      _config = value;
      markNeedsPaint();
    }
  }

  bool _ignorePointers;

  set ignorePointers(bool value) {
    if (_ignorePointers != value) {
      _ignorePointers = value;
    }
  }

  bool _isCustom;

  set isCustom(bool value) {
    if (_isCustom != value) {
      _isCustom = value;
      markNeedsPaint();
    }
  }

  @override
  bool get isCustom => _isCustom;

  double _animationValue = 0;

  @override
  double get animationValue => _animationValue;

  set animationValue(double value) {
    if (_animationValue != value) {
      _animationValue = value;
      markNeedsPaint();
    }
  }

  @override
  bool hitTest(
    SliverHitTestResult result, {
    required double mainAxisPosition,
    required double crossAxisPosition,
  }) {
    if (_ignorePointers) return false;
    return super.hitTest(
      result,
      mainAxisPosition: mainAxisPosition,
      crossAxisPosition: crossAxisPosition,
    );
  }
}

mixin _RenderShimmerBase<R extends RenderObject>
    on RenderObjectWithChildMixin<R> {
  /// The text direction used to resolve Directional geometries
  TextDirection get textDirection;

  /// The resolved shimmerize theme data
  ShimmerizeConfigData get config;

  /// The value to animate painting effects
  double get animationValue;

  /// if true, only [Bone] and [Shimmerize] widgets will be shaded
  bool get isCustom;

  ShimmerizePaintingContext createShimmerizeContext(
      ContainerLayer layer, Offset offset) {
    final estimatedBounds = paintBounds.shift(offset);
    final shaderPaint = config.effect.createPaint(
      animationValue,
      estimatedBounds,
      textDirection,
    );
    return ShimmerizePaintingContext(
      layer: layer,
      animationValue: animationValue,
      estimatedBounds: estimatedBounds,
      shaderPaint: shaderPaint,
      config: config,
      isCustom: isCustom,
    );
  }

  @override
  OffsetLayer? get layer => super.layer as OffsetLayer?;

  @override
  void paint(PaintingContext context, Offset offset) {
    layer ??= OffsetLayer();
    if (layer!.hasChildren) {
      layer!.removeAllChildren();
    }
    context.addLayer(layer!);
    final shimmerizeContext = createShimmerizeContext(layer!, offset);
    super.paint(shimmerizeContext, offset);
    shimmerizeContext.stopRecordingIfNeeded();
  }
}
