import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';

import 'base_tab_page.dart';

class BaseScrollableTabs extends StatefulWidget {
  final List<BaseTabPage> tabs;
  final String title;
  final List<Widget> actions;
  final bool isScrollable;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final Color indicatorColor;
  final Color labelColor;
  final Color unselectedLabelColor;
  final TabBarIndicatorSize indicatorSize;
  final Decoration indicator;
  final Function(BaseTabPage page) buildTab;
  final TabController controller;

  BaseScrollableTabs({
    @required this.tabs,
    @required this.title,
    this.controller,
    this.isScrollable = true,
    this.actions,
    this.floatingActionButton,
    this.floatingActionButtonLocation,
    this.indicatorColor,
    this.labelColor,
    this.unselectedLabelColor,
    this.indicatorSize = TabBarIndicatorSize.tab,
    this.indicator,
    this.buildTab,
  });

  @override
  BaseScrollableTabsState createState() => BaseScrollableTabsState();
}

class BaseScrollableTabsState extends State<BaseScrollableTabs>
    with SingleTickerProviderStateMixin {
  TabController controller;

  @override
  void initState() {
    controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.controller != null
        ? _Scaffold(
            title: widget.title,
            actions: widget.actions,
            floatingActionButton: widget.floatingActionButton,
            floatingActionButtonLocation: widget.floatingActionButtonLocation,
            tabBar: _buildTabBar(context),
            tabBarView: _buildTabBarView(),
          )
        : DefaultTabController(
            length: widget.tabs.length,
            child: _Scaffold(
              title: widget.title,
              actions: widget.actions,
              floatingActionButton: widget.floatingActionButton,
              floatingActionButtonLocation: widget.floatingActionButtonLocation,
              tabBar: _buildTabBar(context),
              tabBarView: _buildTabBarView(),
            ));
  }

  TabBar _buildTabBar(BuildContext context) {
    final colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return TabBar(
        controller: controller,
        isScrollable: widget.isScrollable ?? true,
        indicatorSize: widget.indicatorSize,
        indicator: widget.indicator,
        indicatorColor: widget.indicatorColor ?? themeData.primaryColor,
        labelColor: widget.labelColor ?? colors.accentColor,
        unselectedLabelColor: widget.unselectedLabelColor ?? colors.hintColor,
        labelStyle: BaseTheme.of(context).subhead1Semi,
        tabs: widget.buildTab != null
            ? widget.tabs.map<Widget>((page) => widget.buildTab(page)).toList()
            : widget.tabs
                .map((page) => Tab(text: page.title, icon: page.icon))
                .toList());
  }

  TabBarView _buildTabBarView() {
    return TabBarView(
        controller: controller,
        children: widget.tabs.map<Widget>((BaseTabPage page) {
          return page.body ??
              Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Text('No Data found',
                      style: BaseTheme.of(context).body.copyWith()));
        }).toList());
  }
}

class _Scaffold extends StatelessWidget {
  final String title;
  final List<Widget> actions;
  final TabBar tabBar;
  final TabBarView tabBarView;
  final Widget floatingActionButton;
  final FloatingActionButtonLocation floatingActionButtonLocation;

  const _Scaffold(
      {Key key,
      this.title,
      this.actions,
      this.tabBar,
      this.tabBarView,
      this.floatingActionButton,
      this.floatingActionButtonLocation})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BaseAppBar(actions: actions, title: Text(title), bottom: tabBar),
      body: tabBarView,
      floatingActionButton: floatingActionButton,
      floatingActionButtonLocation: floatingActionButtonLocation,
    );
  }
}
