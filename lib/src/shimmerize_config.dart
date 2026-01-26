import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:shimmerize/shimmerize.dart';

const _defaultTextBoneBorderRadius = TextBoneBorderRadius.fromHeightFactor(.5);

@immutable
class ShimmerizeConfigData extends ThemeExtension<ShimmerizeConfigData> {

  const ShimmerizeConfigData({
    this.effect = const ShimmerEffect(),
    this.textBorderRadius = _defaultTextBoneBorderRadius,
    this.justifyMultiLineText = true,
    this.ignoreContainers = false,
    this.containersColor = const Color(0xFFDADAE3),
    this.enableSwitchAnimation = false,
    this.switchAnimationConfig = const SwitchAnimationConfig(),
  });

  const ShimmerizeConfigData.dark({
    this.effect = const ShimmerEffect(
      baseColor: Color(0xFF3A3A3A),
      highlightColor: Color(0xFF424242),
    ),
    this.textBorderRadius = _defaultTextBoneBorderRadius,
    this.justifyMultiLineText = true,
    this.ignoreContainers = false,
    this.containersColor = const Color(0xFF3A3A3A),
    this.enableSwitchAnimation = false,
    this.switchAnimationConfig = const SwitchAnimationConfig(),
  });

  final PaintingEffect effect;
  final TextBoneBorderRadius textBorderRadius;
  final bool justifyMultiLineText;
  final bool ignoreContainers;
  final Color? containersColor;
  final bool enableSwitchAnimation;
  final SwitchAnimationConfig switchAnimationConfig;

  @override
  ShimmerizeConfigData copyWith({
    PaintingEffect? effect,
    TextBoneBorderRadius? textBorderRadius,
    bool? justifyMultiLineText,
    bool? ignoreContainers,
    Color? containersColor,
    bool? enableSwitchAnimation,
    SwitchAnimationConfig? switchAnimationConfig,
  }) {
    return ShimmerizeConfigData(
      effect: effect ?? this.effect,
      textBorderRadius: textBorderRadius ?? this.textBorderRadius,
      justifyMultiLineText: justifyMultiLineText ?? this.justifyMultiLineText,
      ignoreContainers: ignoreContainers ?? this.ignoreContainers,
      containersColor: containersColor ?? this.containersColor,
      enableSwitchAnimation: enableSwitchAnimation ?? this.enableSwitchAnimation,
      switchAnimationConfig: switchAnimationConfig ?? this.switchAnimationConfig,
    );
  }

  @override
  ShimmerizeConfigData lerp(ShimmerizeConfigData? other, double t) {
    if (other == null) return this;
    return ShimmerizeConfigData(
      effect: effect.lerp(other.effect, t),
      textBorderRadius: textBorderRadius.lerp(other.textBorderRadius, t),
      justifyMultiLineText: t < 0.5 ? justifyMultiLineText : other.justifyMultiLineText,
      ignoreContainers: t < 0.5 ? ignoreContainers : other.ignoreContainers,
      containersColor: t < 0.5 ? containersColor : other.containersColor,
      enableSwitchAnimation: t < 0.5 ? enableSwitchAnimation : other.enableSwitchAnimation,
      switchAnimationConfig: t < 0.5 ? switchAnimationConfig : other.switchAnimationConfig,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ShimmerizeConfigData &&
          runtimeType == other.runtimeType &&
          effect == other.effect &&
          textBorderRadius == other.textBorderRadius &&
          justifyMultiLineText == other.justifyMultiLineText &&
          ignoreContainers == other.ignoreContainers &&
          containersColor == other.containersColor &&
          enableSwitchAnimation == other.enableSwitchAnimation &&
          switchAnimationConfig == other.switchAnimationConfig;

  @override
  int get hashCode => Object.hash(effect, textBorderRadius, justifyMultiLineText, ignoreContainers, containersColor,
      enableSwitchAnimation, switchAnimationConfig);
}

/// Singleton instance for shimmerize theme configurations.
const ShimmerizeConfigData shimmerizeConfigData = ShimmerizeConfigData(
  effect: ShimmerEffect(),
  textBorderRadius: _defaultTextBoneBorderRadius,
  justifyMultiLineText: true,
  ignoreContainers: false,
  containersColor: Color(0xFFDADAE3),
  enableSwitchAnimation: false,
  switchAnimationConfig: SwitchAnimationConfig(),
);

/// Holds border radius information
/// for [TextElement]
class TextBoneBorderRadius {
  final BorderRadiusGeometry? _borderRadius;
  final double? _heightPercentage;

  /// The shape of the border
  final TextBoneBorderShape borderShape;

  /// Whether this is constructed using [fromHeightFactor]
  final bool usesHeightFactor;

  /// Builds TextBoneBorderRadius instance that
  /// uses default/fixed border radius
  const TextBoneBorderRadius(
    BorderRadiusGeometry borderRadius, {
    this.borderShape = TextBoneBorderShape.roundedRectangle,
  })  : _borderRadius = borderRadius,
        _heightPercentage = null,
        usesHeightFactor = false;

  /// Builds TextBoneBorderRadius instance that
  /// uses a high factor to resolve used border radius
  const TextBoneBorderRadius.fromHeightFactor(
    double factor, {
    this.borderShape = TextBoneBorderShape.roundedRectangle,
  })  : assert(factor >= 0 && factor <= 1),
        _borderRadius = null,
        _heightPercentage = factor,
        usesHeightFactor = true;

  /// This defines the value of border radius
  /// based on the font size e.g
  /// fontSize: 14
  /// heightPercentage: .5
  /// border radius =>  14 * .5 = 7
  double? get heightPercentage => _heightPercentage;

  /// The fixed border radius
  BorderRadiusGeometry? get borderRadius => _borderRadius;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextBoneBorderRadius &&
          runtimeType == other.runtimeType &&
          _borderRadius == other._borderRadius &&
          borderShape == other.borderShape &&
          _heightPercentage == other._heightPercentage &&
          usesHeightFactor == other.usesHeightFactor;

  @override
  int get hashCode =>
      _borderRadius.hashCode ^ _heightPercentage.hashCode ^ usesHeightFactor.hashCode ^ borderShape.hashCode;

  /// Linearly interpolate between two [TextBoneBorderRadius]
  TextBoneBorderRadius lerp(TextBoneBorderRadius? other, double t) {
    if (other == null) return this;
    if (usesHeightFactor && other.usesHeightFactor) {
      return TextBoneBorderRadius.fromHeightFactor(
        lerpDouble(_heightPercentage!, other._heightPercentage!, t)!,
        borderShape: borderShape == other.borderShape ? borderShape : other.borderShape,
      );
    } else if (!usesHeightFactor && !other.usesHeightFactor) {
      return TextBoneBorderRadius(
        BorderRadiusGeometry.lerp(_borderRadius, other._borderRadius, t)!,
        borderShape: borderShape == other.borderShape ? borderShape : other.borderShape,
      );
    } else {
      return this;
    }
  }
}

/// Enum to define the type of border for text bones
enum TextBoneBorderShape {
  /// Rectangular border shape
  roundedRectangle,

  /// Superellipse border shape
  roundedSuperellipse
}

/// Provided the scoped [ShimmerizeConfigData] to descended widgets
class ShimmerizeConfig extends InheritedTheme {
  /// The Scoped config data
  final ShimmerizeConfigData data;

  /// The [ShimmerizeConfigData] instance of the closest ancestor Theme.extension
  /// if exists, otherwise null.
  static ShimmerizeConfigData? maybeOf(BuildContext context) {
    final ShimmerizeConfig? inherited = context.dependOnInheritedWidgetOfExactType<ShimmerizeConfig>();
    return inherited?.data ?? Theme.of(context).extension<ShimmerizeConfigData>();
  }

  /// The [ShimmerizeConfigData] instance of the closest ancestor Theme.extension
  /// if not found it will throw an exception
  static ShimmerizeConfigData of(BuildContext context) {
    final ShimmerizeConfig? inherited = context.dependOnInheritedWidgetOfExactType<ShimmerizeConfig>();
    late final fromThemeExtension = Theme.of(context).extension<ShimmerizeConfigData>();
    assert(() {
      if (inherited == null && fromThemeExtension == null) {
        throw FlutterError(
            'ShimmerizeConfig.of() called with a context that does not contain a ShimmerizeConfigData.\n'
            'try wrapping the context with ShimmerizeConfig widget or provide the data using Theme.extension');
      }
      return true;
    }());
    return inherited?.data ?? fromThemeExtension!;
  }

  /// Default constructor
  const ShimmerizeConfig({
    super.key,
    required super.child,
    required this.data,
  });

  @override
  bool updateShouldNotify(covariant ShimmerizeConfig oldWidget) {
    return data != oldWidget.data;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return ShimmerizeConfig(data: data, child: child);
  }
}

/// Holds the configuration for the switch animation
class SwitchAnimationConfig {
  /// The duration of the switch animation
  final Duration duration;

  /// The curve of the switch in animation
  final Curve switchInCurve;

  /// The curve of the switch out animation
  final Curve switchOutCurve;

  /// The duration of the reverse switch animation
  final Duration? reverseDuration;

  /// The transition builder
  final AnimatedSwitcherTransitionBuilder transitionBuilder;

  /// The layout builder
  final AnimatedSwitcherLayoutBuilder layoutBuilder;

  /// Default constructor
  const SwitchAnimationConfig({
    this.duration = const Duration(milliseconds: 300),
    this.switchInCurve = Curves.linear,
    this.switchOutCurve = Curves.linear,
    this.transitionBuilder = AnimatedSwitcher.defaultTransitionBuilder,
    this.layoutBuilder = AnimatedSwitcher.defaultLayoutBuilder,
    this.reverseDuration,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SwitchAnimationConfig &&
          runtimeType == other.runtimeType &&
          duration == other.duration &&
          switchInCurve == other.switchInCurve &&
          switchOutCurve == other.switchOutCurve &&
          reverseDuration == other.reverseDuration &&
          transitionBuilder == other.transitionBuilder &&
          layoutBuilder == other.layoutBuilder;

  @override
  int get hashCode =>
      duration.hashCode ^
      switchInCurve.hashCode ^
      switchOutCurve.hashCode ^
      reverseDuration.hashCode ^
      transitionBuilder.hashCode ^
      layoutBuilder.hashCode;
}
