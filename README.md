<!--
This README describes the package. If you publish this package to pub.dev,
this README's contents appear on the landing page for your package.

For information about how to write a good package README, see the guide for
[writing package pages](https://dart.dev/tools/pub/writing-package-pages).

For general information about developing packages, see the Dart guide for
[creating packages](https://dart.dev/guides/libraries/create-packages)
and the Flutter guide for
[developing packages and plugins](https://flutter.dev/to/develop-packages).
-->

# shimmerize

`shimmerize` helps you build **loading placeholders (skeletons)** by painting an animated effect over your existing widget tree, with optional “bone” widgets for fully-custom skeleton layouts.

## Features

- **Animated placeholder painter**
  Wrap any widget tree with `Shimmerize(isLoading: true, child: ...)` to paint a loading skeleton.
- **Multiple effects**
  Built-in `ShimmerEffect` (sliding gradient) and `PulseEffect` (color pulsing).
- **Configurable per-scope**
  Set defaults via `ShimmerizeConfig` / `ShimmerizeConfigData` (a `ThemeExtension`) and override per `Shimmerize`.
- **Custom skeleton layouts with bones**
  Use `Bone` widgets to create placeholders explicitly:
  `Bone.circle`, `Bone.square`, `Bone.text`, `Bone.multiText`, `Bone.button`, `Bone.iconButton`, etc.
- **Custom mode (only paint bones)**
  Use `Shimmerize.custome(...)` to shade only `Bone` widgets (and nested shimmerizes) instead of auto-detecting the whole tree.
- **Works with slivers**
  Use `Shimmerize.sliver(...)` inside a `CustomScrollView`.
- **Switch animation**
  Optional animated transition between placeholder and content using `enableSwitchAnimation` and `SwitchAnimationConfig`.
- **List helpers**
  `ShimmerizeList` builders for `ListView`, `GridView`, separated variants, and refresh support.

## Getting started

Add the dependency:

```bash
flutter pub add shimmerize
```

Import it:

```dart
import 'package:shimmerize/shimmerize.dart';
```

## Usage

### 1) Wrap any widget tree

```dart
Shimmerize(
  isLoading: isLoading,
  effect: const ShimmerEffect(),
  enableSwitchAnimation: true,
  child: YourPageBody(),
);
```

### 2) Bone-based custom skeleton (custom mode)

```dart
Shimmerize.custom(
  isLoading: isLoading,
  effect: const PulseEffect(),
  child: const Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Bone.circle(size: 48),
      SizedBox(height: 12),
      Bone.text(words: 6),
      SizedBox(height: 8),
      Bone.multiText(lines: 3),
    ],
  ),
);
```

### 3) Configure defaults globally

```dart
MaterialApp(
  theme: ThemeData(
    extensions: const [
      ShimmerizeConfigData(
        effect: ShimmerEffect(),
        justifyMultiLineText: true,
        ignoreContainers: false,
      ),
    ],
  ),
  home: const MyApp(),
);
```

Or wrap a subtree:

```dart
ShimmerizeConfig(
  data: const ShimmerizeConfigData.dark(),
  child: YourSection(),
);
```

### 4) Lists with loading placeholders

```dart
ShimmerizeList<YourModel>.builder(
  isLoading: isLoading, // true to show loading placeholders
  items: items, // your items
  loadingItemCount: 4, // number of loading items
  itemBuilder: (context, item, index, isLoading) {
    return ListTile(title: Text(item!.toString()));
  },
);
```