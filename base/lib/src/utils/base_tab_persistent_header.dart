import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:flutter/material.dart';

import 'base_persistent_header_delegate.dart';

class BaseTabPersistentHeader extends StatelessWidget {
  const BaseTabPersistentHeader({
    Key key,
    @required this.tabs,
  }) : super(key: key);

  final List<Tab> tabs;

  @override
  Widget build(BuildContext context) {
    final colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return SliverPersistentHeader(
        pinned: true,
        delegate: BasePersistentHeaderDelegate(
            builder: (BuildContext context, bool isAtTop) {
          return Material(
              elevation: isAtTop ? 2.0 : 1.0,
              child: TabBar(
                indicatorColor: themeData.primaryColor,
                labelStyle: BaseTheme.of(context).bodySemi,
                labelColor: colors.accentColor,
                unselectedLabelColor: colors.hintColor,
                tabs: tabs,
              ));
        }));
  }
}
