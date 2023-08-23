import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/utils/app_child_dialog.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_models/filter_model.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_views/filter_dialog.dart';

typedef Builder = Widget Function(ScrollController controller);

class SalesInsightBaseContainer extends StatefulWidget {
  final bool hasMargin;
  final bool hasMajorBrand;
  final Function(SaleInsightFilterModel model) onFilterClicked;
  final Builder builder;
  final SaleInsightFilterModel filterModel;

  const SalesInsightBaseContainer(
      {Key key,
      this.hasMargin,
      this.hasMajorBrand,
      @required this.onFilterClicked,
      @required this.builder,
      this.filterModel})
      : super(key: key);

  @override
  _SalesInsightBaseContainerState createState() =>
      _SalesInsightBaseContainerState();
}

class _SalesInsightBaseContainerState extends State<SalesInsightBaseContainer>
    with SingleTickerProviderStateMixin {
  ScrollController _scrollController;
  AnimationController _hideFabAnimController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _hideFabAnimController = AnimationController(
        vsync: this,
        duration: kThemeAnimationDuration,
        value: 1 // initially visible
        );
    addScrollListener();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      widget.builder(_scrollController),
      Positioned(
          right: 20,
          bottom: 28,
          child: FadeTransition(
              opacity: _hideFabAnimController,
              child: ScaleTransition(
                  alignment: Alignment.bottomRight,
                  scale: _hideFabAnimController,
                  child: FloatingActionButton(
                      mini: true,
                      tooltip: "Filter",
                      child: Icon(Icons.filter_list),
                      onPressed: () =>
                          showFilterDialog(context, widget.filterModel)))))
    ]);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _hideFabAnimController.dispose();
    super.dispose();
  }

  void addScrollListener() {
    _scrollController.addListener(() {
      switch (_scrollController.position.userScrollDirection) {
        // Scrolling up - forward the animation (value goes to 1)
        case ScrollDirection.forward:
          _hideFabAnimController.forward();
          break;
        // Scrolling down - reverse the animation (value goes to 0)
        case ScrollDirection.reverse:
          _hideFabAnimController.reverse();
          break;
        // Idle - keep FAB visibility unchanged
        case ScrollDirection.idle:
          break;
      }
    });
  }

  showFilterDialog(BuildContext context, SaleInsightFilterModel model) async {
    SaleInsightFilterModel result =
        await appShowChildDialog<SaleInsightFilterModel>(
            context: context,
            child: FilterDialog(
              model: model,
              showBrandCategory: widget.hasMajorBrand,
              showMargin: widget.hasMargin,
            ),
            barrierDismissible: true);
    if (result != null)
      widget.onFilterClicked(result);
    else
      print("dismissed");
  }
}
