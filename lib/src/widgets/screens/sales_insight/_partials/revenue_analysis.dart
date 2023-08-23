import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/resources.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/redux/actions/sales_insight/sales_insight_home_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/sales_insight/sale_insight_home_viewmodel.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_branch_model.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_item_model.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_salesman_model.dart';
import 'package:redstars/src/utils/app_number_format.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_models/filter_model.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_partials/sale_enquiry_base.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_views/helper.dart';

class RevenueAnalysis extends StatelessWidget
    with BaseStoreMixin<AppState, SalesInsightHomeViewModel> {
  @override
  void init(Store store, BuildContext context) {
    final state = store.state.salesInsightState.salesInsightHomeState;
    store.dispatch(fetchRevenueAnalysisLists(state.fromDate, state.toDate,
        major: state.major, margin: state.margin));
    super.init(store, context);
  }

  @override
  Widget childBuilder(
          BuildContext context, SalesInsightHomeViewModel viewModel) =>
      SalesInsightBaseContainer(
          hasMajorBrand: true,
          hasMargin: true,
          filterModel: SaleInsightFilterModel(
              fromDate: viewModel.fromDate,
              toDate: viewModel.toDate,
              isMargin: viewModel.margin,
              isMajorCategory: viewModel.major),
          onFilterClicked: (filter) => viewModel.onFilterRevenue(filter),
          builder: (scrollController) => BaseNestedTabBar(
                  color: ThemeProvider.of(context).scaffoldBackgroundColor,
                  indicatorSize: TabBarIndicatorSize.tab,
                  unselectedLabelColor: BaseTheme.of(context).colors.white ,
                  labelColor:ThemeProvider.of(context).primaryColorDark,
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color:BaseTheme.of(context).colors.white ),
                  buildTab: (page) => Tab(
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            "${page.title}",
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  tabs: [
                    BaseTabPage(
                        title: "Sales Analysis",
                        body: _RevenueAnalysisBody<RevenueBranchItem>(
                            scrollController: scrollController,
                            builder: (data) =>
                                _BranchGridItem(revenueItem: data),
                            analysisData: viewModel.branchRevenue,
                            loadingStatus:
                                viewModel.branchRevenueLoadingStatus)),
                    BaseTabPage(
                        title: "Item-Wise Sales",
                        body: _RevenueAnalysisBody<RevenueItemList>(
                            scrollController: scrollController,
                            builder: (data) =>
                                _ItemWiseGridItem(revenueItem: data),
                            analysisData: viewModel.itemsRevenue,
                            loadingStatus: viewModel.itemsLoadingStatus)),
                    BaseTabPage(
                        title: "Salesman Performance",
                        body: _RevenueAnalysisBody<RevenueSalesmanItem>(
                            scrollController: scrollController,
                            builder: (data) =>
                                _SalesmanGridItem(revenueItem: data),
                            analysisData: viewModel.salesman,
                            loadingStatus: viewModel.salesmanLoadingStatus))
                  ]));

  @override
  SalesInsightHomeViewModel converter(store) =>
      SalesInsightHomeViewModel.fromStore(store);
}

class _RevenueAnalysisBody<T> extends StatelessWidget {
  final List<T> analysisData;
  final LoadingStatus loadingStatus;
  final Function(T data) builder;
  final ScrollController scrollController;

  const _RevenueAnalysisBody(
      {Key key,
      @required this.analysisData,
      @required this.builder,
      this.scrollController,
      this.loadingStatus})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loadingStatus == LoadingStatus.loading
        ? LoadingView()
        : GraphDataView(
            scrollController: scrollController,
            data: analysisData,
            builder: (analysisItem) => builder(analysisItem));
  }
}

class _BranchGridItem extends StatelessWidget {
  final RevenueBranchItem revenueItem;

  const _BranchGridItem({Key key, @required this.revenueItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    List<Color>_colors=[themeData.scaffoldBackgroundColor,themeData.primaryColor];
    List<double>_stops=[0.4,0.9];
    return Container(
        padding: EdgeInsets.all(6),
        margin: EdgeInsets.symmetric(horizontal: 2, vertical: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: _colors,
            stops: _stops
          ),
          //color: style.colors.selectedColor.withOpacity(.80),
          borderRadius: new BorderRadius.all(Radius.circular(8.0)),
          border: Border.all(color: revenueItem.color,width:1.5),
        ),
        child: Row(children: <Widget>[
          Expanded(
              flex: 5,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      revenueItem.branch ?? "",
                      style: style.bodyBold,
                    ),
                    Text(revenueItem.brand ?? ""),
                    Text(BaseStringCase(revenueItem.category ?? "")
                        .sentenceCase),
                  ])),
          Expanded(
              flex: 3,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppNumberFormat(number: revenueItem?.totalValue ?? 0)
                          .formatCurrency(),
                      textAlign: TextAlign.end,
                    ),
                    SizedBox(height: 4),
                    if (revenueItem?.margin != null && revenueItem.margin > 0)
                      Container(
                        padding:
                            EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                        decoration: BoxDecoration(
                          border: Border.all(color: themeData.scaffoldBackgroundColor),
                          borderRadius: BorderRadius.circular(20),
                          color: themeData.scaffoldBackgroundColor,
                        ),
                        child: Text("% : ${revenueItem.margin ?? ""}"),
                      ),
                  ]))
        ]));
  }
}

class _ItemWiseGridItem extends StatelessWidget {
  final RevenueItemList revenueItem;

  const _ItemWiseGridItem({Key key, @required this.revenueItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    List<Color>_colors=[style.colors.secondaryColor.withOpacity(.15),style.colors.white];
    List<double>_stops=[0.4,0.9];
    return Container(
        padding: EdgeInsets.all(6),
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(color:themeData.scaffoldBackgroundColor,
            borderRadius: new BorderRadius.all(Radius.circular(8.0)),
            border: Border(
              left: BaseBorderSide(color: revenueItem.color,width: 1.5),
              right: BaseBorderSide(color: revenueItem.color,width: 1.5),
              top: BaseBorderSide(color: revenueItem.color,width: 1.5),
              bottom: BaseBorderSide(color: revenueItem.color,width: 1.5),
            )),
        child: Row(children: <Widget>[
          Expanded(
              flex: 5,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      revenueItem?.itemName ?? "",
                      style: style.bodyBold,
                    ),
                    Text(revenueItem?.brand ?? ""),
                    Text(revenueItem?.category ?? ""),
                  ])),
          Text(AppNumberFormat(number: revenueItem?.revenue ?? 0)
              .formatCurrency(),)
        ]));
  }
}

class _SalesmanGridItem extends StatelessWidget {
  final RevenueSalesmanItem revenueItem;

  const _SalesmanGridItem({Key key, @required this.revenueItem})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    List<Color>_colors=[themeData.scaffoldBackgroundColor.withOpacity(.15),style.colors.white,];
    List<double>_stops=[0.0,0.9];
    return Container(
        padding: EdgeInsets.all(6),
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: _colors,stops: _stops),
            borderRadius: new BorderRadius.all(Radius.circular(8.0)),
            border: Border(
              left: BaseBorderSide(color: revenueItem.color),
              right: BaseBorderSide(color: revenueItem.color),
              top: BaseBorderSide(color: revenueItem.color),
              bottom: BaseBorderSide(color: revenueItem.color),
            )),
        child: Row(children: <Widget>[
          Expanded(
              flex: 5,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(revenueItem?.salesman ?? "", style: style.bodyBold),
                    Text(
                      BaseStringCase(revenueItem?.branch ?? "").titleCase,
                      style: style.body,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ])),
          Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                AppNumberFormat(number: revenueItem?.totalValue ?? 0)
                    .formatCurrency(),
                style: style.bodyBold.copyWith(fontWeight: FontWeight.w600,
                    color:
                        revenueItem.totalValue > 0 ? Colors.green: Colors.red),
              ),
              SizedBox(height: 4),
              Container(
                padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                decoration: BoxDecoration(
                  border: Border.all(color: ThemeProvider.of(context).scaffoldBackgroundColor),
                  borderRadius: BorderRadius.circular(20),
                  color: ThemeProvider.of(context).scaffoldBackgroundColor,
                ),
                child: Text(
                  "% : ${revenueItem.margin ?? ""} (${revenueItem.marginPerc ?? "0"}%)",
                  style: style.body,
                ),
              ),
            ],
          )
        ]));
  }
}
