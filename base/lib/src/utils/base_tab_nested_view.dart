import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:flutter/material.dart';

import 'base_tab_page.dart';

class BaseNestedTabBar extends StatefulWidget {
  final List<BaseTabPage> tabs;
  final Color color;
  final Color indicatorColor;
  final Color labelColor;
  final Color unselectedLabelColor;
  final bool isScrollable;
  final TabBarIndicatorSize indicatorSize;
  final Decoration indicator;
  final Function(BaseTabPage page) buildTab;

  BaseNestedTabBar(
      {@required this.tabs,
      this.color,
      this.indicatorColor,
      this.labelColor,
      this.unselectedLabelColor,
      this.indicator,
      this.indicatorSize,
      this.isScrollable = false,
      this.buildTab});

  @override
  _NestedTabBarState createState() => _NestedTabBarState();
}

class _NestedTabBarState extends State<BaseNestedTabBar>
    with TickerProviderStateMixin {
  TabController _nestedTabController;

  @override
  void initState() {
    super.initState();
    _nestedTabController =
        new TabController(length: widget.tabs.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _nestedTabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return SafeArea(
        child: Column(children: <Widget>[
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
            shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(23)),
            color: widget.color ?? BaseColors.of(context).borderColor,
            child: TabBar(
              isScrollable: widget.isScrollable,
              controller: _nestedTabController,
              indicatorColor: widget.indicatorColor ?? themeData.primaryColor,
              indicatorSize: widget.indicatorSize,
              indicator: widget.indicator,
              labelColor: widget.labelColor ?? colors.accentColor,
              unselectedLabelColor:
                  widget.unselectedLabelColor ?? colors.hintColor,
              tabs: widget.buildTab != null
                  ? widget.tabs
                      .map<Widget>((page) => widget.buildTab(page))
                      .toList()
                  : widget.tabs
                      .map((page) => Tab(text: page.title, icon: page.icon))
                      .toList(),
            )),
      ),
      Expanded(
          child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              child: TabBarView(
                  controller: _nestedTabController,
                  children: widget.tabs.map<Widget>((BaseTabPage page) {
                    return page.body ??
                        Container(
                            child: Center(
                                child: Text('No Data found',
                                    style: BaseTheme.of(context)
                                        .body
                                        .copyWith())));
                  }).toList())))
    ]));
  }
}
