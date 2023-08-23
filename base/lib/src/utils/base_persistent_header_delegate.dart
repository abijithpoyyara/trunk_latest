import 'package:flutter/material.dart';

class BasePersistentHeaderDelegate extends SliverPersistentHeaderDelegate {
  const BasePersistentHeaderDelegate({
    @required this.builder,
    double height,
    double minExtent,
    double maxExtent,
  })  : minExtent = height ?? minExtent ?? kTextTabBarHeight,
        maxExtent = height ?? maxExtent ?? kTextTabBarHeight;

  final Widget Function(BuildContext context, bool isAtTop) builder;
  @override
  final double maxExtent;
  @override
  final double minExtent;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return builder(context, shrinkOffset != 0);
  }

  @override
  bool shouldRebuild(BasePersistentHeaderDelegate oldDelegate) => true;
}
