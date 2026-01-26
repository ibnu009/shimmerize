import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:shimmerize/shimmerize.dart';
import 'package:shimmerize/src/painting/shimmerize_painting_context.dart';

typedef ShimmerizePainter = void Function(
  ShimmerizePaintingContext context,
  Rect paintBounds,
  Painter paint,
  TextDirection? textDirection,
);

typedef Painter = void Function(PaintingContext context, Offset offset);

abstract class Shimmer extends Widget {
  const Shimmer({super.key});
  bool get enabled;

  /// Creates a widget that keeps paints the original child as is when [Shimmerize.enabled] is true
  const factory Shimmer.ignore({
    Key? key,
    required Widget child,
    bool ignore,
  }) = _KeepShimmer;

  /// Creates a widget that replaces the child when [Shimmerize.enabled] is true
  const factory Shimmer.replace({
    Key? key,
    required Widget child,
    bool replace,
    double? width,
    double? height,
    Widget replacement,
  }) = _ShimmerReplace;

  /// Creates a widget that forces the child to have a painting effect
  /// e.g a Shimmer effect when [Shimmerize.enabled] is true
  const factory Shimmer.override({
    Key? key,
    required Widget child,
    bool enabled,
  }) = _OverrideShimmer;

  /// Creates a widget that ignores pointer events when [Shimmerize.enabled] is true
  const factory Shimmer.ignorePointer({
    Key? key,
    required Widget child,
    bool ignore,
  }) = _ShimmerIgnorePointer;
}

abstract class _BasicShimmer extends SingleChildRenderObjectWidget
    implements Shimmer {
  const _BasicShimmer({
    super.key,
    required Widget super.child,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderBasicShimmer(
      textDirection: Directionality.of(context),
      painter: paint,
      enabled: enabled,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant _RenderBasicShimmer renderObject,
  ) {
    renderObject
      ..textDirection = Directionality.of(context)
      ..enabled = enabled;
  }

  void paint(
    ShimmerizePaintingContext context,
    Rect paintBounds,
    Painter paint,
    TextDirection? textDirection,
  );
}

class _KeepShimmer extends _BasicShimmer {
  const _KeepShimmer({
    super.key,
    required super.child,
    bool ignore = true,
  }) : enabled = ignore;

  @override
  final bool enabled;

  @override
  void paint(
    ShimmerizePaintingContext context,
    Rect paintBounds,
    Painter paint,
    TextDirection? _,
  ) {
    context.createDefaultContext(paintBounds, paint);
  }
}

class _RenderBasicShimmer extends RenderProxyBox {
  /// Default constructor
  _RenderBasicShimmer({
    required TextDirection textDirection,
    required ShimmerizePainter painter,
    required bool enabled,
  })  : _textDirection = textDirection,
        _painter = painter,
        _enabled = enabled;

  bool _enabled = true;

  set enabled(bool value) {
    if (value != _enabled) {
      _enabled = value;
      markNeedsPaint();
    }
  }

  ShimmerizePainter? _painter;

  set painter(ShimmerizePainter? value) {
    if (value != _painter) {
      _painter = value;
      markNeedsPaint();
    }
  }

  TextDirection? _textDirection;

  set textDirection(TextDirection? value) {
    if (value != _textDirection) {
      _textDirection = value;
      markNeedsLayout();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (_enabled && context is ShimmerizePaintingContext) {
      assert(_painter != null, 'painter must not be null');
      return _painter!(
        context,
        offset & size,
        super.paint,
        _textDirection,
      );
    }
    super.paint(context, offset);
  }
}

/// A Render object that paints nothing when shimmerize is enabled
class RenderIgnoredShimmer extends RenderProxyBox {
  /// Default constructor
  RenderIgnoredShimmer({
    RenderBox? child,
    required bool enabled,
  }) : _enabled = enabled;

  bool _enabled = true;

  /// Whether the shimmerize is enabled
  bool get enabled => _enabled;

  set enabled(bool value) {
    if (value != _enabled) {
      _enabled = value;
      markNeedsPaint();
    }
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    if (!_enabled) {
      super.paint(context, offset);
    }
  }
}

class _OverrideShimmer extends _BasicShimmer {
  const _OverrideShimmer({
    super.key,
    required super.child,
    this.enabled = true,
  });

  @override
  final bool enabled;

  @override
  void paint(
    ShimmerizePaintingContext context,
    Rect paintBounds,
    Painter paint,
    TextDirection? _,
  ) {
    context.createOverrideContext(paintBounds, (overrideContext, _) {
      paint(overrideContext, paintBounds.topLeft);
    });
  }
}

/// Replace the original element when [Shimmerize.enabled] is true
class _ShimmerReplace extends StatelessWidget implements Shimmer {
  /// Default constructor
  const _ShimmerReplace({
    super.key,
    required this.child,
    bool replace = true,
    this.width,
    this.height,
    this.replacement = const ColoredBox(color: Colors.black),
  }) : enabled = replace;

  final Widget child;

  /// The width nad height of the replacement
  final double? width;
  final double? height;

  @override
  final bool enabled;

  /// The replacement widget
  final Widget replacement;

  @override
  Widget build(BuildContext context) {
    final doReplace = enabled && Shimmerize.maybeOf(context)?.isLoading == true;
    return SizedBox(
      width: width,
      height: height,
      child: doReplace ? replacement : child,
    );
  }
}

/// Ignores pointer events when [Shimmerize.enabled] is true
class _ShimmerIgnorePointer extends StatelessWidget implements Shimmer {
  /// Default constructor
  const _ShimmerIgnorePointer({
    super.key,
    required this.child,
    bool ignore = true,
  }) : enabled = ignore;

  final Widget child;

  @override
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final ignoring = enabled && Shimmerize.maybeOf(context)?.isLoading == true;
    return IgnorePointer(
      ignoring: ignoring,
      child: child,
    );
  }
}
