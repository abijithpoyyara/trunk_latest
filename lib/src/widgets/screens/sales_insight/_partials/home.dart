import 'dart:ui';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/redux.dart';
import 'package:base/resources.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/sales_insight/sales_insight_home_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/sales_insight/sale_insight_home_viewmodel.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_analysis_model.dart';
import 'package:redstars/src/utils/app_chart.dart';
import 'package:redstars/src/utils/app_number_format.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_models/filter_model.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_partials/sale_enquiry_base.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_views/helper.dart';

import 'total_card.dart';

class SaleInsightHome extends StatelessWidget
    with BaseStoreMixin<AppState, SalesInsightHomeViewModel> {
  @override
  void init(Store store, BuildContext context) {
    super.init(store, context);
    final state = store.state.salesInsightState.salesInsightHomeState;
    store.dispatch(fetchSummaryList(state.fromDate, state.toDate,
        major: state.major, margin: state.margin));
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
          onFilterClicked: (filter) => viewModel.onFilterHome(filter),
          builder: (scrollController) => BaseNestedTabBar(
                  color: ThemeProvider.of(context).primaryColorDark.withOpacity(.5),
                  indicatorSize: TabBarIndicatorSize.label,
                  indicator: BoxDecoration(
                      // borderRadius: BorderRadius.only(
                      // topLeft: Radius.circular(10),
                      // topRight: Radius.circular(10)),
                      color: ThemeProvider.of(context).scaffoldBackgroundColor),
                  buildTab: (page) => Tab(
                      child: Align(
                          alignment: Alignment.center,
                          child: Text("${page.title}"))),
                  tabs: [
                    BaseTabPage(
                        title: "Branch",
                        body: _AnalysisBody(
                          analysisData: viewModel.branchList,
                          loadingStatus: viewModel.branchLoadingStatus,
                          scrollController: scrollController,
                          totalMargin: viewModel.totalMargin,
                          totalSale: viewModel.totalSale,
                        )),
                    BaseTabPage(
                        title: "Classification",
                        body: _AnalysisBody(
                          analysisData: viewModel.categoryList,
                          loadingStatus: viewModel.categoryLoadingStatus,
                          scrollController: scrollController,
                          totalMargin: viewModel.totalMargin,
                          totalSale: viewModel.totalSale,
                        )),
                    BaseTabPage(
                        title: "Brand",
                        body: _AnalysisBody(
                          analysisData: viewModel.brandList,
                          loadingStatus: viewModel.brandLoadingStatus,
                          scrollController: scrollController,
                          totalMargin: viewModel.totalMargin,
                          totalSale: viewModel.totalSale,
                        ))
                  ]));

  @override
  SalesInsightHomeViewModel converter(store) =>
      SalesInsightHomeViewModel.fromStore(store);
}

class _AnalysisBody extends StatelessWidget {
  final List<RevenueList> analysisData;
  final LoadingStatus loadingStatus;
  final ScrollController scrollController;
  final double totalSale;
  final double totalMargin;

  const _AnalysisBody({
    Key key,
    this.analysisData,
    this.loadingStatus,
    this.scrollController,
    this.totalSale,
    this.totalMargin,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loadingStatus == LoadingStatus.loading
        ? LoadingView()
        : GraphDataView(
            scrollController: scrollController,
            totalCard: Row(
              children: [
                Expanded(
                  child: TotalTile(
                    icon: Icons.monetization_on,
                    title: Text("Total Sales",style: BaseTheme.of(context).subhead1Bold.copyWith(color: ThemeProvider.of(context).primaryColorDark),),
                    value: totalSale,
                  ),
                ),
                SizedBox(width: 4),
                if (totalMargin != null)
                  Expanded(
                    child: TotalTile(
                      icon: Icons.code,
                      title: Text("Total Margin"),
                      value: totalMargin,
                    ),
                  ),
              ],
            ),
            headerChild: AppChart(
                showLabels: false,
                chartType: AppChartType.PIE_CHART,
                chartData: analysisData
                        ?.map((data) => AppChartModel(
                              value: data.revenue,
                              axisValue: data?.revenue?.floor() ?? 0,
                              axis: data.title,
                              color: charts.ColorUtil.fromDartColor(data.color),
                            ))
                        ?.toList() ??
                    [],
                showLegends: false,
                title: "title"),
            data: analysisData,
            builder: (analysisItem) => _AnalysisGridItem(
                title: analysisItem?.title,
                color: analysisItem?.color ?? Colors.blue,
                revenue: AppNumberFormat(number: analysisItem?.revenue ?? 0)
                    .formatCurrency(),
                margin: analysisItem?.margin ?? 0));
  }
}

class _AnalysisGridItem extends StatelessWidget {
  final String title;
  final String revenue;
  final double margin;
  final Color color;

  const _AnalysisGridItem(
      {Key key, this.title, this.revenue, this.margin, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: themeData.scaffoldBackgroundColor,
            border: Border(
                left: BorderSide(color: color, width: 4),
                bottom: BaseBorderSide(color: color))),
        child: Row(children: <Widget>[
          Expanded(flex: 5, child: Text(title ?? "", style: style.bodyBold)),
          Expanded(
              flex: 3,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(revenue ?? "", textAlign: TextAlign.end),
                    SizedBox(height: 4),
                    if (margin != null && margin > 0)
                      Container(
                          padding:
                              EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                          decoration: BoxDecoration(
                              border: Border.all(color: ThemeProvider.of(context).scaffoldBackgroundColor),
                              borderRadius: BorderRadius.circular(20),
                              color: ThemeProvider.of(context).scaffoldBackgroundColor),
                          child: Text(
                              "% : ${AppNumberFormat(number: margin).formatCurrency() ?? ""}"))
                  ]))
        ]));
  }
}
