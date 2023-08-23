import 'package:base/utility.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_partials/home.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_partials/revenue_analysis.dart';

int tabCount = 2;

class SalesInsightView extends StatefulWidget {
  @override
  _SalesInsightViewState createState() => _SalesInsightViewState();
}

class _SalesInsightViewState extends State<SalesInsightView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: tabCount)
      ..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BaseScrollableTabs(
      controller: _tabController,
      // isScrollable: true,
      indicatorSize: TabBarIndicatorSize.tab,
      indicatorColor: Colors.transparent,
      buildTab: (page) => _SaleInsightTab(
        title: page.title,
        isExpanded: page.tabIndex == _tabController.index,
        icon: page.icon,
      ),
      tabs: <BaseTabPage>[
        BaseTabPage(
            tabIndex: 0,
            title: "Home",
            body: SaleInsightHome(),
            icon: Icon(Icons.home)),
        BaseTabPage(
            tabIndex: 1,
            title: "Revenue Analysys",
            body: RevenueAnalysis(),
            icon: Icon(Icons.attach_money)),
        // BaseTabPage(
        //     tabIndex: 2,
        //     title: "Customer Analysis",
        //     body: CustomerAnalysis(),
        //     icon: Icon(Icons.account_circle)),
        // BaseTabPage(
        //     tabIndex: 3,
        //     title: "Instrument Analysis",
        //     body: InstrumentAnalysis(),
        //     icon: Icon(Icons.category)),
        // BaseTabPage(
        //     tabIndex: 4,
        //     title: "Brand Connect",
        //     body: BrandConnect(),
        //     icon: Icon(Icons.store))
      ],
      title: "Sales Insights",
    );
  }
}

class _SaleInsightTab extends StatefulWidget {
  _SaleInsightTab({
    this.icon,
    String title,
    int tabIndex,
    this.isVertical,
    this.isExpanded,
  }) : titleText = Text(title);

  final Text titleText;
  final Icon icon;
  final bool isExpanded;
  final bool isVertical;

  @override
  _SaleInsightTabState createState() => _SaleInsightTabState();
}

class _SaleInsightTabState extends State<_SaleInsightTab>
    with SingleTickerProviderStateMixin {
  Animation<double> _titleSizeAnimation;
  Animation<double> _titleFadeAnimation;
  Animation<double> _iconFadeAnimation;
  AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _titleSizeAnimation = _controller.view;
    _titleFadeAnimation = _controller.drive(CurveTween(curve: Curves.easeOut));
    _iconFadeAnimation = _controller.drive(Tween<double>(begin: 0.6, end: 1));
    if (widget.isExpanded) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(_SaleInsightTab oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isExpanded) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    const expandedTitleWidthMultiplier = 2;
    final unitWidth = width / (tabCount + expandedTitleWidthMultiplier);

    return ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Row(children: [
          FadeTransition(
            child: SizedBox(
              width: unitWidth,
              child: widget.icon,
            ),
            opacity: _iconFadeAnimation,
          ),
          FadeTransition(
              child: SizeTransition(
                child: SizedBox(
                  width: unitWidth * expandedTitleWidthMultiplier,
                  child: Center(
                    child: ExcludeSemantics(child: widget.titleText),
                  ),
                ),
                axis: Axis.horizontal,
                axisAlignment: -1,
                sizeFactor: _titleSizeAnimation,
              ),
              opacity: _titleFadeAnimation)
        ]));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
