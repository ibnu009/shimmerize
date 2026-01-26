import 'package:flutter/material.dart';
import 'package:shimmerize/src/effects/painting_effect.dart';
import 'package:shimmerize/src/shimmerize_config.dart';
import 'package:shimmerize/src/widgets/shimmerize_render_object_widget.dart';

/// Paints a placeholder of the [child] widget
///
/// if [isLoading] is set the false the child
/// will be painted normally
abstract class Shimmerize extends StatefulWidget {
  /// The widget to be painted as a placeholder
  final Widget child;

  /// Placeholder painting state, isLoading = true will paint the placeholder
  /// otherwise the child will be painted normally
  final bool isLoading;

  /// The painting effect to apply
  /// on the placeholder elements
  final PaintingEffect? effect;

  /// The [TextElement] border radius config
  final TextBoneBorderRadius? textBoneBorderRadius;

  /// Whether to ignore container elements and only paint
  /// the dependents
  final bool? ignoreContainers;

  /// Whether to justify multi line text bones
  final bool? justifyMultiLineText;

  /// The color of the container elements
  /// this includes [Container], [Card], [DecoratedBox] ..etc
  ///
  /// if null the actual color will be used
  final Color? containersColor;

  /// Whether to ignore pointer events
  ///
  /// defaults to true
  final bool ignorePointers;

  /// Whether to enable switch animation
  ///
  /// This will animate the switch between the placeholder and the actual widget
  final bool? enableSwitchAnimation;

  /// The switch animation config
  ///
  /// This will be used if [enableSwitchAnimation] is true
  final SwitchAnimationConfig? switchAnimationConfig;

  final bool _isCustom;

  /// Default constructor
  const Shimmerize._({
    super.key,
    required this.child,
    this.isLoading = true,
    this.effect,
    this.textBoneBorderRadius,
    this.ignoreContainers,
    this.justifyMultiLineText,
    this.containersColor,
    this.ignorePointers = true,
    this.enableSwitchAnimation,
    this.switchAnimationConfig,
  }) : _isCustom = false;

  /// Creates a Shimmerize widget that only shades [Bone] widgets
  const Shimmerize._custom({
    super.key,
    required this.child,
    this.isLoading = true,
    this.effect,
    this.textBoneBorderRadius,
    this.ignoreContainers,
    this.justifyMultiLineText,
    this.containersColor,
    this.ignorePointers = true,
    this.enableSwitchAnimation,
    this.switchAnimationConfig,
  }) : _isCustom = true;

  /// Creates a [Shimmerize] widget
  const factory Shimmerize({
    Key? key,
    required Widget child,
    bool? isLoading,
    PaintingEffect? effect,
    TextBoneBorderRadius? textBoneBorderRadius,
    bool? ignoreContainers,
    bool? justifyMultiLineText,
    Color? containersColor,
    bool? ignorePointers,
    bool? enableSwitchAnimation,
    SwitchAnimationConfig? switchAnimationConfig,
  }) = _Shimmerize;

  /// Creates a Shimmerize widget that only shades [Bone] and nested shimmerizes
  const factory Shimmerize.custom({
    Key? key,
    required Widget child,
    PaintingEffect? effect,
    TextBoneBorderRadius? textBoneBorderRadius,
    bool? ignoreContainers,
    bool? justifyMultiLineText,
    Color? containersColor,
    bool? ignorePointers,
    bool? isLoading,
    bool? enableSwitchAnimation,
    SwitchAnimationConfig? switchAnimationConfig,
  }) = _Shimmerize.custom;

  /// Creates a [SliverShimmerize] widget
  const factory Shimmerize.sliver({
    Key? key,
    required Widget child,
    bool? isLoading,
    PaintingEffect? effect,
    TextBoneBorderRadius? textBoneBorderRadius,
    bool? ignoreContainers,
    bool? justifyMultiLineText,
    Color? containersColor,
    bool? ignorePointers,
  }) = SliverShimmerize;

  @override
  State<Shimmerize> createState() => ShimmerizeState();

  /// Depends on the the nearest ShimmerizeScope if any
  static ShimmerizeScope? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ShimmerizeScope>();
  }

  /// Depends on the the nearest ShimmerizeScope if any otherwise it throws
  static ShimmerizeScope of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<ShimmerizeScope>();
    assert(() {
      if (scope == null) {
        throw FlutterError(
          'Shimmerize operation requested with a context that does not include a Shimmerize.\n'
          'The context used to push or pop routes from the Navigator must be that of a '
          'widget that is a descendant of a Shimmerize widget.',
        );
      }
      return true;
    }());
    return scope!;
  }

  /// Delegates the build to the [ShimmerizeState]
  Widget build(BuildContext context, ShimmerizeBuildData data);
}

/// The state of [Shimmerize] widget
class ShimmerizeState extends State<Shimmerize>
    with TickerProviderStateMixin<Shimmerize> {
  AnimationController? _animationController;

  late bool _isLoading = widget.isLoading;

  ShimmerizeConfigData? _config;

  double get _animationValue => _animationController?.value ?? 0.0;

  PaintingEffect? get _effect => _config?.effect;

  TextDirection _textDirection = TextDirection.ltr;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupEffect();
  }

  void _setupEffect() {
    _textDirection = Directionality.of(context);
    late final brightness = Theme.of(context).brightness;
    var resolvedConfig = ShimmerizeConfig.maybeOf(context) ??
        (brightness == Brightness.light
            ? const ShimmerizeConfigData()
            : const ShimmerizeConfigData.dark());

    resolvedConfig = resolvedConfig.copyWith(
      effect: widget.effect,
      textBorderRadius: widget.textBoneBorderRadius,
      ignoreContainers: widget.ignoreContainers,
      justifyMultiLineText: widget.justifyMultiLineText,
      containersColor: widget.containersColor,
      enableSwitchAnimation: widget.enableSwitchAnimation,
      switchAnimationConfig: widget.switchAnimationConfig,
    );
    if (resolvedConfig != _config) {
      _config = resolvedConfig;
      _stopAnimation();
      if (widget.isLoading) {
        _startAnimationIfNeeded();
      }
    }
  }

  void _stopAnimation() {
    _animationController
      ?..removeListener(_onShimmerChange)
      ..stop(canceled: true)
      ..dispose();
    _animationController = null;
  }

  void _startAnimationIfNeeded() {
    assert(_effect != null);
    if (_effect!.duration.inMilliseconds != 0) {
      _animationController = AnimationController.unbounded(vsync: this)
        ..addListener(_onShimmerChange)
        ..repeat(
          reverse: _effect!.reverse,
          min: _effect!.startingValue,
          max: _effect!.endingValue,
          period: _effect!.duration,
        );
    }
  }

  @override
  void didUpdateWidget(covariant Shimmerize oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isLoading != widget.isLoading) {
      _isLoading = widget.isLoading;
      if (!_isLoading) {
        _animationController?.reset();
        _animationController?.stop(canceled: true);
      } else {
        _startAnimationIfNeeded();
      }
    }
    _setupEffect();
  }

  @override
  void dispose() {
    _animationController?.removeListener(_onShimmerChange);
    _animationController?.dispose();
    super.dispose();
  }

  void _onShimmerChange() {
    if (mounted && widget.isLoading) {
      setState(() {
        // update the shimmer painting.
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final parent = Shimmerize.maybeOf(context);
    final isInsideZone = parent?.isCustom ?? false;
    return widget.build(
      context,
      ShimmerizeBuildData(
        isLoading: _isLoading,
        config: _config!,
        textDirection: _textDirection,
        animationValue: _animationValue,
        ignorePointers: widget.ignorePointers,
        isCustom: widget._isCustom,
        animationController: _animationController,
        isInsideZone: isInsideZone,
      ),
    );
  }
}

class _Shimmerize extends Shimmerize {
  const _Shimmerize({
    required Widget child,
    Key? key,
    bool? isLoading,
    PaintingEffect? effect,
    TextBoneBorderRadius? textBoneBorderRadius,
    bool? ignoreContainers,
    bool? justifyMultiLineText,
    Color? containersColor,
    bool? ignorePointers,
    bool? enableSwitchAnimation,
    SwitchAnimationConfig? switchAnimationConfig,
  }) : super._(
          key: key,
          child: child,
          isLoading: isLoading ?? true,
          effect: effect,
          textBoneBorderRadius: textBoneBorderRadius,
          ignoreContainers: ignoreContainers,
          justifyMultiLineText: justifyMultiLineText,
          containersColor: containersColor,
          ignorePointers: ignorePointers ?? true,
          enableSwitchAnimation: enableSwitchAnimation,
          switchAnimationConfig: switchAnimationConfig,
        );

  const _Shimmerize.custom({
    required Widget child,
    Key? key,
    PaintingEffect? effect,
    TextBoneBorderRadius? textBoneBorderRadius,
    bool? ignoreContainers,
    bool? justifyMultiLineText,
    Color? containersColor,
    bool? ignorePointers,
    bool? isLoading,
    bool? enableSwitchAnimation,
    SwitchAnimationConfig? switchAnimationConfig,
  }) : super._custom(
          key: key,
          child: child,
          isLoading: isLoading ?? true,
          effect: effect,
          textBoneBorderRadius: textBoneBorderRadius,
          ignoreContainers: ignoreContainers,
          justifyMultiLineText: justifyMultiLineText,
          containersColor: containersColor,
          ignorePointers: ignorePointers ?? true,
          enableSwitchAnimation: enableSwitchAnimation,
          switchAnimationConfig: switchAnimationConfig,
        );

  @override
  Widget build(BuildContext context, ShimmerizeBuildData data) {
    Widget body = data.isLoading
        ? ShimmerizeRenderObjectWidget(
            key: const ValueKey('shimmerize'),
            data: data,
            child: child,
          )
        : KeyedSubtree(
            key: const ValueKey('content'),
            child: child,
          );
    if (data.config.enableSwitchAnimation) {
      final switchConfig = data.config.switchAnimationConfig;
      body = AnimatedSwitcher(
        duration: switchConfig.duration,
        reverseDuration: switchConfig.reverseDuration,
        switchInCurve: switchConfig.switchInCurve,
        switchOutCurve: switchConfig.switchOutCurve,
        transitionBuilder: switchConfig.transitionBuilder,
        layoutBuilder: switchConfig.layoutBuilder,
        child: body,
      );
    }
    return ShimmerizeScope(
      isLoading: data.isLoading,
      config: data.config,
      isCustom: data.isCustom,
      isInsideZone: data.isInsideZone,
      animationController: data.animationController,
      child: body,
    );
  }
}

/// A [Shimmerize] widget that can be used in a [CustomScrollView]
class SliverShimmerize extends Shimmerize {
  /// Creates a [SliverShimmerize] widget
  const SliverShimmerize({
    required Widget child,
    Key? key,
    bool? isLoading,
    PaintingEffect? effect,
    TextBoneBorderRadius? textBoneBorderRadius,
    bool? ignoreContainers,
    bool? justifyMultiLineText,
    Color? containersColor,
    bool? ignorePointers,
  }) : super._(
          key: key,
          child: child,
          isLoading: isLoading ?? true,
          effect: effect,
          textBoneBorderRadius: textBoneBorderRadius,
          ignoreContainers: ignoreContainers,
          justifyMultiLineText: justifyMultiLineText,
          containersColor: containersColor,
          ignorePointers: ignorePointers ?? true,
          enableSwitchAnimation: false,
        );

  /// Creates a Shimmerize widget that only shades [Bone] widgets
  const SliverShimmerize.custome({
    required Widget child,
    Key? key,
    PaintingEffect? effect,
    TextBoneBorderRadius? textBoneBorderRadius,
    bool? ignoreContainers,
    bool? justifyMultiLineText,
    Color? containersColor,
    bool? ignorePointers,
    bool? isLoading,
  }) : super._custom(
          key: key,
          child: child,
          isLoading: isLoading ?? true,
          effect: effect,
          textBoneBorderRadius: textBoneBorderRadius,
          ignoreContainers: ignoreContainers,
          justifyMultiLineText: justifyMultiLineText,
          containersColor: containersColor,
          ignorePointers: ignorePointers ?? true,
          enableSwitchAnimation: false,
        );

  @override
  Widget build(BuildContext context, ShimmerizeBuildData data) {
    return ShimmerizeScope(
      isLoading: data.isLoading,
      config: data.config,
      isCustom: data.isCustom,
      isInsideZone: data.isInsideZone,
      animationController: data.animationController,
      child: data.isLoading
          ? SliverShimmerizeRenderObjectWidget(
              data: data,
              child: child,
            )
          : child,
    );
  }
}

/// The data that is passed to the [ShimmerizeRenderObjectWidget]
class ShimmerizeBuildData {
  const ShimmerizeBuildData({
    required this.isLoading,
    required this.config,
    required this.textDirection,
    required this.animationValue,
    required this.ignorePointers,
    required this.isCustom,
    required this.animationController,
    required this.isInsideZone,
  });

  final bool isLoading;
  final ShimmerizeConfigData config;
  final AnimationController? animationController;
  final TextDirection textDirection;
  final double animationValue;
  final bool ignorePointers;
  final bool isCustom;
  final bool isInsideZone;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShimmerizeBuildData &&
          runtimeType == other.runtimeType &&
          isLoading == other.isLoading &&
          config == other.config &&
          isCustom == other.isCustom &&
          isInsideZone == other.isInsideZone &&
          textDirection == other.textDirection &&
          animationValue == other.animationValue &&
          animationController == other.animationController &&
          ignorePointers == other.ignorePointers;

  @override
  int get hashCode =>
      isLoading.hashCode ^
      config.hashCode ^
      textDirection.hashCode ^
      animationValue.hashCode ^
      animationController.hashCode ^
      isCustom.hashCode ^
      isInsideZone.hashCode ^
      ignorePointers.hashCode;
}

class ShimmerizeScope extends InheritedWidget {
  const ShimmerizeScope({
    super.key,
    required super.child,
    required this.isLoading,
    required this.config,
    required this.isInsideZone,
    required this.isCustom,
    required this.animationController,
  });

  final bool isLoading;
  final bool isCustom;
  final bool isInsideZone;
  final ShimmerizeConfigData config;
  final AnimationController? animationController;

  @override
  bool updateShouldNotify(covariant ShimmerizeScope oldWidget) {
    return isLoading != oldWidget.isLoading ||
        config != oldWidget.config ||
        isCustom != oldWidget.isCustom ||
        isInsideZone != oldWidget.isInsideZone ||
        animationController != oldWidget.animationController;
  }
}
