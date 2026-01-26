import 'package:flutter/material.dart';
import 'package:shimmerize/src/rendering/render_shimmerize.dart';
import 'package:shimmerize/src/widgets/shimmerize.dart';

/// Builds a [RenderShimmerize]
class ShimmerizeRenderObjectWidget extends SingleChildRenderObjectWidget {
  /// The default constructor
  const ShimmerizeRenderObjectWidget({
    super.key,
    required super.child,
    required this.data,
  });

  /// The Shimmerize build data
  final ShimmerizeBuildData data;

  @override
  RenderShimmerize createRenderObject(BuildContext context) {
    return RenderShimmerize(
      animationValue: data.animationValue,
      textDirection: data.textDirection,
      config: data.config,
      ignorePointers: data.ignorePointers,
      isCustom: data.isCustom,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderShimmerize renderObject,
  ) {
    renderObject
      ..animationValue = data.animationValue
      ..config = data.config
      ..ignorePointers = data.ignorePointers
      ..isCustom = data.isCustom
      ..textDirection = data.textDirection;
  }
}

/// Builds a [RenderShimmerize]
class SliverShimmerizeRenderObjectWidget
    extends SingleChildRenderObjectWidget {
  /// The default constructor
  const SliverShimmerizeRenderObjectWidget({
    super.key,
    required super.child,
    required this.data,
  });

  /// The Shimmerize build data
  final ShimmerizeBuildData data;

  @override
  RenderSliverShimmerize createRenderObject(BuildContext context) {
    return RenderSliverShimmerize(
      animationValue: data.animationValue,
      textDirection: data.textDirection,
      config: data.config,
      ignorePointers: data.ignorePointers,
      isCustom: data.isCustom,
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    covariant RenderSliverShimmerize renderObject,
  ) {
    renderObject
      ..animationValue = data.animationValue
      ..config = data.config
      ..ignorePointers = data.ignorePointers
      ..isCustom = data.isCustom
      ..textDirection = data.textDirection;
  }
}
