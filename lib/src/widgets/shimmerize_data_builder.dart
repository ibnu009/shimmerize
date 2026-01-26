import 'package:flutter/material.dart';

import 'shimmerize.dart';

typedef ShimmerizeListItemBuilder<T> = Widget Function(
  BuildContext context,
  T item,
  int index,
);

typedef ShimmerizeNullableListItemBuilder<T> = Widget Function(
  BuildContext context,
  T? item,
  int index,
  bool isLoading,
);

typedef ShimmerizeItemsWidgetBuilder<T> = Widget Function(
  BuildContext context,
  List<T?> items,
  bool isLoading,
);

abstract class ShimmerizeList<T> extends Widget {
  factory ShimmerizeList({
    Key? key,
    required bool isLoading,
    required List<T> items,
    required ShimmerizeItemsWidgetBuilder<T> builder,
    int loadingItemCount = 6,
    WidgetBuilder? emptyBuilder,
    Future<void> Function()? onRefresh,
  }) {
    return _ShimmerizeCustomList<T>(
      key: key,
      isLoading: isLoading,
      items: items,
      builder: builder,
      loadingItemCount: loadingItemCount,
      emptyBuilder: emptyBuilder,
      onRefresh: onRefresh,
    );
  }

  factory ShimmerizeList.builder({
    Key? key,
    required bool isLoading,
    required List<T> items,
    required ShimmerizeNullableListItemBuilder<T> itemBuilder,
    int loadingItemCount = 6,
    WidgetBuilder? emptyBuilder,
    Future<void> Function()? onRefresh,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    ScrollController? controller,
    bool? primary,
    bool shrinkWrap = false,
    bool reverse = false,
    Axis scrollDirection = Axis.vertical,
  }) {
    return _ShimmerizeListViewBuilderAuto<T>(
      key: key,
      isLoading: isLoading,
      items: items,
      itemBuilder: itemBuilder,
      loadingItemCount: loadingItemCount,
      emptyBuilder: emptyBuilder,
      onRefresh: onRefresh,
      padding: padding,
      physics: physics,
      controller: controller,
      primary: primary,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      scrollDirection: scrollDirection,
    );
  }

  factory ShimmerizeList.builderAuto({
    Key? key,
    required bool isLoading,
    required List<T> items,
    required ShimmerizeNullableListItemBuilder<T> itemBuilder,
    int loadingItemCount = 6,
    WidgetBuilder? emptyBuilder,
    Future<void> Function()? onRefresh,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    ScrollController? controller,
    bool? primary,
    bool shrinkWrap = false,
    bool reverse = false,
    Axis scrollDirection = Axis.vertical,
  }) {
    return ShimmerizeList.builder(
      key: key,
      isLoading: isLoading,
      items: items,
      itemBuilder: itemBuilder,
      loadingItemCount: loadingItemCount,
      emptyBuilder: emptyBuilder,
      onRefresh: onRefresh,
      padding: padding,
      physics: physics,
      controller: controller,
      primary: primary,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      scrollDirection: scrollDirection,
    );
  }

  factory ShimmerizeList.separated({
    Key? key,
    required bool isLoading,
    required List<T> items,
    required ShimmerizeNullableListItemBuilder<T> itemBuilder,
    required IndexedWidgetBuilder separatorBuilder,
    int loadingItemCount = 6,
    WidgetBuilder? emptyBuilder,
    Future<void> Function()? onRefresh,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    ScrollController? controller,
    bool? primary,
    bool shrinkWrap = false,
    bool reverse = false,
    Axis scrollDirection = Axis.vertical,
  }) {
    return _ShimmerizeListViewSeparatedAuto<T>(
      key: key,
      isLoading: isLoading,
      items: items,
      itemBuilder: itemBuilder,
      separatorBuilder: separatorBuilder,
      loadingItemCount: loadingItemCount,
      emptyBuilder: emptyBuilder,
      onRefresh: onRefresh,
      padding: padding,
      physics: physics,
      controller: controller,
      primary: primary,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      scrollDirection: scrollDirection,
    );
  }

  factory ShimmerizeList.separatedAuto({
    Key? key,
    required bool isLoading,
    required List<T> items,
    required ShimmerizeNullableListItemBuilder<T> itemBuilder,
    required IndexedWidgetBuilder separatorBuilder,
    int loadingItemCount = 6,
    WidgetBuilder? emptyBuilder,
    Future<void> Function()? onRefresh,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    ScrollController? controller,
    bool? primary,
    bool shrinkWrap = false,
    bool reverse = false,
    Axis scrollDirection = Axis.vertical,
  }) {
    return ShimmerizeList.separated(
      key: key,
      isLoading: isLoading,
      items: items,
      itemBuilder: itemBuilder,
      separatorBuilder: separatorBuilder,
      loadingItemCount: loadingItemCount,
      emptyBuilder: emptyBuilder,
      onRefresh: onRefresh,
      padding: padding,
      physics: physics,
      controller: controller,
      primary: primary,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      scrollDirection: scrollDirection,
    );
  }

  factory ShimmerizeList.builderWithLoading({
    Key? key,
    required bool isLoading,
    required List<T> items,
    required ShimmerizeListItemBuilder<T> itemBuilder,
    required IndexedWidgetBuilder loadingItemBuilder,
    int loadingItemCount = 6,
    WidgetBuilder? emptyBuilder,
    Future<void> Function()? onRefresh,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    ScrollController? controller,
    bool? primary,
    bool shrinkWrap = false,
    bool reverse = false,
    Axis scrollDirection = Axis.vertical,
  }) {
    return _ShimmerizeListViewBuilder<T>(
      key: key,
      isLoading: isLoading,
      items: items,
      itemBuilder: itemBuilder,
      loadingItemBuilder: loadingItemBuilder,
      loadingItemCount: loadingItemCount,
      emptyBuilder: emptyBuilder,
      onRefresh: onRefresh,
      padding: padding,
      physics: physics,
      controller: controller,
      primary: primary,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      scrollDirection: scrollDirection,
    );
  }

  factory ShimmerizeList.separatedWithLoading({
    Key? key,
    required bool isLoading,
    required List<T> items,
    required ShimmerizeListItemBuilder<T> itemBuilder,
    required IndexedWidgetBuilder separatorBuilder,
    required IndexedWidgetBuilder loadingItemBuilder,
    IndexedWidgetBuilder? loadingSeparatorBuilder,
    int loadingItemCount = 6,
    WidgetBuilder? emptyBuilder,
    Future<void> Function()? onRefresh,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    ScrollController? controller,
    bool? primary,
    bool shrinkWrap = false,
    bool reverse = false,
    Axis scrollDirection = Axis.vertical,
  }) {
    return _ShimmerizeListViewSeparated<T>(
      key: key,
      isLoading: isLoading,
      items: items,
      itemBuilder: itemBuilder,
      separatorBuilder: separatorBuilder,
      loadingItemBuilder: loadingItemBuilder,
      loadingSeparatorBuilder: loadingSeparatorBuilder,
      loadingItemCount: loadingItemCount,
      emptyBuilder: emptyBuilder,
      onRefresh: onRefresh,
      padding: padding,
      physics: physics,
      controller: controller,
      primary: primary,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      scrollDirection: scrollDirection,
    );
  }

  factory ShimmerizeList.gridWithLoading({
    Key? key,
    required bool isLoading,
    required List<T> items,
    required ShimmerizeListItemBuilder<T> itemBuilder,
    required IndexedWidgetBuilder loadingItemBuilder,
    required SliverGridDelegate gridDelegate,
    int loadingItemCount = 6,
    WidgetBuilder? emptyBuilder,
    Future<void> Function()? onRefresh,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    ScrollController? controller,
    bool? primary,
    bool shrinkWrap = false,
    bool reverse = false,
    Axis scrollDirection = Axis.vertical,
  }) {
    return _ShimmerizeGridViewBuilder<T>(
      key: key,
      isLoading: isLoading,
      items: items,
      itemBuilder: itemBuilder,
      loadingItemBuilder: loadingItemBuilder,
      gridDelegate: gridDelegate,
      loadingItemCount: loadingItemCount,
      emptyBuilder: emptyBuilder,
      onRefresh: onRefresh,
      padding: padding,
      physics: physics,
      controller: controller,
      primary: primary,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      scrollDirection: scrollDirection,
    );
  }

  factory ShimmerizeList.grid({
    Key? key,
    required bool isLoading,
    required List<T> items,
    required ShimmerizeNullableListItemBuilder<T> itemBuilder,
    required SliverGridDelegate gridDelegate,
    int loadingItemCount = 6,
    WidgetBuilder? emptyBuilder,
    Future<void> Function()? onRefresh,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    ScrollController? controller,
    bool? primary,
    bool shrinkWrap = false,
    bool reverse = false,
    Axis scrollDirection = Axis.vertical,
  }) {
    return _ShimmerizeGridViewBuilderAuto<T>(
      key: key,
      isLoading: isLoading,
      items: items,
      itemBuilder: itemBuilder,
      gridDelegate: gridDelegate,
      loadingItemCount: loadingItemCount,
      emptyBuilder: emptyBuilder,
      onRefresh: onRefresh,
      padding: padding,
      physics: physics,
      controller: controller,
      primary: primary,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      scrollDirection: scrollDirection,
    );
  }

  factory ShimmerizeList.gridAuto({
    Key? key,
    required bool isLoading,
    required List<T> items,
    required ShimmerizeNullableListItemBuilder<T> itemBuilder,
    required SliverGridDelegate gridDelegate,
    int loadingItemCount = 6,
    WidgetBuilder? emptyBuilder,
    Future<void> Function()? onRefresh,
    EdgeInsetsGeometry? padding,
    ScrollPhysics? physics,
    ScrollController? controller,
    bool? primary,
    bool shrinkWrap = false,
    bool reverse = false,
    Axis scrollDirection = Axis.vertical,
  }) {
    return ShimmerizeList.grid(
      key: key,
      isLoading: isLoading,
      items: items,
      itemBuilder: itemBuilder,
      gridDelegate: gridDelegate,
      loadingItemCount: loadingItemCount,
      emptyBuilder: emptyBuilder,
      onRefresh: onRefresh,
      padding: padding,
      physics: physics,
      controller: controller,
      primary: primary,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      scrollDirection: scrollDirection,
    );
  }
}

class _ShimmerizeListViewBuilderAuto<T> extends StatelessWidget
    implements ShimmerizeList<T> {
  const _ShimmerizeListViewBuilderAuto({
    super.key,
    required this.isLoading,
    required this.items,
    required this.itemBuilder,
    this.loadingItemCount = 6,
    this.emptyBuilder,
    this.onRefresh,
    this.padding,
    this.physics,
    this.controller,
    this.primary,
    this.shrinkWrap = false,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
  });

  final bool isLoading;
  final List<T> items;
  final ShimmerizeNullableListItemBuilder<T> itemBuilder;
  final int loadingItemCount;
  final WidgetBuilder? emptyBuilder;
  final Future<void> Function()? onRefresh;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool? primary;
  final bool shrinkWrap;
  final bool reverse;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmerize(
        isLoading: true,
        child: ListView.builder(
          padding: padding,
          physics: physics,
          controller: controller,
          primary: primary,
          shrinkWrap: shrinkWrap,
          reverse: reverse,
          scrollDirection: scrollDirection,
          itemCount: loadingItemCount,
          itemBuilder: (context, index) =>
              itemBuilder(context, null, index, true),
        ),
      );
    }

    if (items.isEmpty) {
      return emptyBuilder?.call(context) ?? const SizedBox.shrink();
    }

    Widget child = ListView.builder(
      padding: padding,
      physics: physics,
      controller: controller,
      primary: primary,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      scrollDirection: scrollDirection,
      itemCount: items.length,
      itemBuilder: (context, index) =>
          itemBuilder(context, items[index], index, false),
    );

    final refresh = onRefresh;
    if (refresh != null) {
      child = RefreshIndicator(onRefresh: refresh, child: child);
    }

    return child;
  }
}

class _ShimmerizeCustomList<T> extends StatelessWidget implements ShimmerizeList<T> {
  const _ShimmerizeCustomList({
    super.key,
    required this.isLoading,
    required this.items,
    required this.builder,
    this.loadingItemCount = 6,
    this.emptyBuilder,
    this.onRefresh,
  });

  final bool isLoading;
  final List<T> items;
  final ShimmerizeItemsWidgetBuilder<T> builder;
  final int loadingItemCount;
  final WidgetBuilder? emptyBuilder;
  final Future<void> Function()? onRefresh;

  List<T?> _createLoadingItems() {
    return List<T?>.filled(loadingItemCount, null, growable: false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmerize(
        isLoading: true,
        child: builder(context, _createLoadingItems(), true),
      );
    }

    if (items.isEmpty) {
      return emptyBuilder?.call(context) ?? const SizedBox.shrink();
    }

    Widget child = builder(context, List<T?>.from(items), false);

    final refresh = onRefresh;
    if (refresh != null) {
      child = RefreshIndicator(onRefresh: refresh, child: child);
    }

    return child;
  }
}

class _ShimmerizeGridViewBuilderAuto<T> extends StatelessWidget
    implements ShimmerizeList<T> {
  const _ShimmerizeGridViewBuilderAuto({
    super.key,
    required this.isLoading,
    required this.items,
    required this.itemBuilder,
    required this.gridDelegate,
    this.loadingItemCount = 6,
    this.emptyBuilder,
    this.onRefresh,
    this.padding,
    this.physics,
    this.controller,
    this.primary,
    this.shrinkWrap = false,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
  });

  final bool isLoading;
  final List<T> items;
  final ShimmerizeNullableListItemBuilder<T> itemBuilder;
  final SliverGridDelegate gridDelegate;
  final int loadingItemCount;
  final WidgetBuilder? emptyBuilder;
  final Future<void> Function()? onRefresh;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool? primary;
  final bool shrinkWrap;
  final bool reverse;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmerize(
        isLoading: true,
        child: GridView.builder(
          padding: padding,
          physics: physics,
          controller: controller,
          primary: primary,
          shrinkWrap: shrinkWrap,
          reverse: reverse,
          scrollDirection: scrollDirection,
          gridDelegate: gridDelegate,
          itemCount: loadingItemCount,
          itemBuilder: (context, index) =>
              itemBuilder(context, null, index, true),
        ),
      );
    }

    if (items.isEmpty) {
      return emptyBuilder?.call(context) ?? const SizedBox.shrink();
    }

    Widget child = GridView.builder(
      padding: padding,
      physics: physics,
      controller: controller,
      primary: primary,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      scrollDirection: scrollDirection,
      gridDelegate: gridDelegate,
      itemCount: items.length,
      itemBuilder: (context, index) =>
          itemBuilder(context, items[index], index, false),
    );

    final refresh = onRefresh;
    if (refresh != null) {
      child = RefreshIndicator(onRefresh: refresh, child: child);
    }

    return child;
  }
}

class _ShimmerizeListViewSeparatedAuto<T> extends StatelessWidget
    implements ShimmerizeList<T> {
  const _ShimmerizeListViewSeparatedAuto({
    super.key,
    required this.isLoading,
    required this.items,
    required this.itemBuilder,
    required this.separatorBuilder,
    this.loadingItemCount = 6,
    this.emptyBuilder,
    this.onRefresh,
    this.padding,
    this.physics,
    this.controller,
    this.primary,
    this.shrinkWrap = false,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
  });

  final bool isLoading;
  final List<T> items;
  final ShimmerizeNullableListItemBuilder<T> itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;
  final int loadingItemCount;
  final WidgetBuilder? emptyBuilder;
  final Future<void> Function()? onRefresh;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool? primary;
  final bool shrinkWrap;
  final bool reverse;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmerize(
        isLoading: true,
        child: ListView.separated(
          padding: padding,
          physics: physics,
          controller: controller,
          primary: primary,
          shrinkWrap: shrinkWrap,
          reverse: reverse,
          scrollDirection: scrollDirection,
          itemCount: loadingItemCount,
          itemBuilder: (context, index) =>
              itemBuilder(context, null, index, true),
          separatorBuilder: separatorBuilder,
        ),
      );
    }

    if (items.isEmpty) {
      return emptyBuilder?.call(context) ?? const SizedBox.shrink();
    }

    Widget child = ListView.separated(
      padding: padding,
      physics: physics,
      controller: controller,
      primary: primary,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      scrollDirection: scrollDirection,
      itemCount: items.length,
      itemBuilder: (context, index) =>
          itemBuilder(context, items[index], index, false),
      separatorBuilder: separatorBuilder,
    );

    final refresh = onRefresh;
    if (refresh != null) {
      child = RefreshIndicator(onRefresh: refresh, child: child);
    }

    return child;
  }
}

class _ShimmerizeListViewBuilder<T> extends StatelessWidget
    implements ShimmerizeList<T> {
  const _ShimmerizeListViewBuilder({
    super.key,
    required this.isLoading,
    required this.items,
    required this.itemBuilder,
    required this.loadingItemBuilder,
    this.loadingItemCount = 6,
    this.emptyBuilder,
    this.onRefresh,
    this.padding,
    this.physics,
    this.controller,
    this.primary,
    this.shrinkWrap = false,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
  });

  final bool isLoading;
  final List<T> items;
  final ShimmerizeListItemBuilder<T> itemBuilder;
  final IndexedWidgetBuilder loadingItemBuilder;
  final int loadingItemCount;
  final WidgetBuilder? emptyBuilder;
  final Future<void> Function()? onRefresh;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool? primary;
  final bool shrinkWrap;
  final bool reverse;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmerize(
        isLoading: true,
        child: ListView.builder(
          padding: padding,
          physics: physics,
          controller: controller,
          primary: primary,
          shrinkWrap: shrinkWrap,
          reverse: reverse,
          scrollDirection: scrollDirection,
          itemCount: loadingItemCount,
          itemBuilder: loadingItemBuilder,
        ),
      );
    }

    if (items.isEmpty) {
      return emptyBuilder?.call(context) ?? const SizedBox.shrink();
    }

    Widget child = ListView.builder(
      padding: padding,
      physics: physics,
      controller: controller,
      primary: primary,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      scrollDirection: scrollDirection,
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index], index),
    );

    final refresh = onRefresh;
    if (refresh != null) {
      child = RefreshIndicator(onRefresh: refresh, child: child);
    }

    return child;
  }
}

class _ShimmerizeListViewSeparated<T> extends StatelessWidget
    implements ShimmerizeList<T> {
  const _ShimmerizeListViewSeparated({
    super.key,
    required this.isLoading,
    required this.items,
    required this.itemBuilder,
    required this.separatorBuilder,
    required this.loadingItemBuilder,
    this.loadingSeparatorBuilder,
    this.loadingItemCount = 6,
    this.emptyBuilder,
    this.onRefresh,
    this.padding,
    this.physics,
    this.controller,
    this.primary,
    this.shrinkWrap = false,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
  });

  final bool isLoading;
  final List<T> items;
  final ShimmerizeListItemBuilder<T> itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;
  final IndexedWidgetBuilder loadingItemBuilder;
  final IndexedWidgetBuilder? loadingSeparatorBuilder;
  final int loadingItemCount;
  final WidgetBuilder? emptyBuilder;
  final Future<void> Function()? onRefresh;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool? primary;
  final bool shrinkWrap;
  final bool reverse;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmerize(
        isLoading: true,
        child: ListView.separated(
          padding: padding,
          physics: physics,
          controller: controller,
          primary: primary,
          shrinkWrap: shrinkWrap,
          reverse: reverse,
          scrollDirection: scrollDirection,
          itemCount: loadingItemCount,
          itemBuilder: loadingItemBuilder,
          separatorBuilder: loadingSeparatorBuilder ?? separatorBuilder,
        ),
      );
    }

    if (items.isEmpty) {
      return emptyBuilder?.call(context) ?? const SizedBox.shrink();
    }

    Widget child = ListView.separated(
      padding: padding,
      physics: physics,
      controller: controller,
      primary: primary,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      scrollDirection: scrollDirection,
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index], index),
      separatorBuilder: separatorBuilder,
    );

    final refresh = onRefresh;
    if (refresh != null) {
      child = RefreshIndicator(onRefresh: refresh, child: child);
    }

    return child;
  }
}

class _ShimmerizeGridViewBuilder<T> extends StatelessWidget
    implements ShimmerizeList<T> {
  const _ShimmerizeGridViewBuilder({
    super.key,
    required this.isLoading,
    required this.items,
    required this.itemBuilder,
    required this.loadingItemBuilder,
    required this.gridDelegate,
    this.loadingItemCount = 6,
    this.emptyBuilder,
    this.onRefresh,
    this.padding,
    this.physics,
    this.controller,
    this.primary,
    this.shrinkWrap = false,
    this.reverse = false,
    this.scrollDirection = Axis.vertical,
  });

  final bool isLoading;
  final List<T> items;
  final ShimmerizeListItemBuilder<T> itemBuilder;
  final IndexedWidgetBuilder loadingItemBuilder;
  final SliverGridDelegate gridDelegate;
  final int loadingItemCount;
  final WidgetBuilder? emptyBuilder;
  final Future<void> Function()? onRefresh;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics? physics;
  final ScrollController? controller;
  final bool? primary;
  final bool shrinkWrap;
  final bool reverse;
  final Axis scrollDirection;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Shimmerize(
        isLoading: true,
        child: GridView.builder(
          padding: padding,
          physics: physics,
          controller: controller,
          primary: primary,
          shrinkWrap: shrinkWrap,
          reverse: reverse,
          scrollDirection: scrollDirection,
          gridDelegate: gridDelegate,
          itemCount: loadingItemCount,
          itemBuilder: loadingItemBuilder,
        ),
      );
    }

    if (items.isEmpty) {
      return emptyBuilder?.call(context) ?? const SizedBox.shrink();
    }

    Widget child = GridView.builder(
      padding: padding,
      physics: physics,
      controller: controller,
      primary: primary,
      shrinkWrap: shrinkWrap,
      reverse: reverse,
      scrollDirection: scrollDirection,
      gridDelegate: gridDelegate,
      itemCount: items.length,
      itemBuilder: (context, index) => itemBuilder(context, items[index], index),
    );

    final refresh = onRefresh;
    if (refresh != null) {
      child = RefreshIndicator(onRefresh: refresh, child: child);
    }

    return child;
  }
}
