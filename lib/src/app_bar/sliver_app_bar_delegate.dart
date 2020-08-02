import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {

  final FloatingHeaderSnapConfiguration _snapConfiguration;

  SliverAppBarDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.builder,
    FloatingHeaderSnapConfiguration snapConfiguration,
  }): _snapConfiguration = snapConfiguration;

  final double minHeight;
  final double maxHeight;
  final Widget Function(BuildContext context, double shrinkOffset, bool overlapsContent) builder;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => math.max(maxHeight, minHeight);

  @override
  FloatingHeaderSnapConfiguration get snapConfiguration => _snapConfiguration;

  @override
  OverScrollHeaderStretchConfiguration stretchConfiguration = OverScrollHeaderStretchConfiguration(
    stretchTriggerOffset: 140.0,
  );

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return builder(context, shrinkOffset, overlapsContent);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight;
  }
}