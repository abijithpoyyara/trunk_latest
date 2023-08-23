import 'package:base/redux.dart';
import 'package:base/resources.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/redux/actions/sales_insight/customer_analysis_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/sales_insight/sale_insight_customer_viewmodel.dart';
import 'package:redstars/src/services/model/response/sales_insight/customer_analysis.dart';
import 'package:redstars/src/utils/app_chart.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_models/filter_model.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_partials/sale_enquiry_base.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_views/helper.dart';

class CustomerAnalysis extends StatelessWidget
    with BaseStoreMixin<AppState, SalesInsightCustomerViewModel> {
  @override
  void init(Store store, BuildContext context) {
    super.init(store, context);
    final state = store.state.salesInsightState.salesInsightCustomerState;
    store.dispatch(fetchCustomerData(state.fromDate, state.toDate));
    store.dispatch(fetchMarginData(state.fromDate, state.toDate));
  }

  @override
  Widget childBuilder(
      BuildContext context, SalesInsightCustomerViewModel viewModel) {
    final status = viewModel.loadingStatus;
    return SalesInsightBaseContainer(
        hasMajorBrand: false,
        hasMargin: false,
        filterModel: SaleInsightFilterModel(
          fromDate: viewModel.fromDate,
          toDate: viewModel.toDate,
        ),
        onFilterClicked: (filter) => viewModel.onFilter(filter),
        builder: (scrollController) => BaseNestedTabBar(
                isScrollable: false,
                color: BaseColors.of(context).hintColor.withOpacity(.5),
                indicatorSize: TabBarIndicatorSize.label,
                indicator: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10)),
                    color: Colors.white),
                buildTab: (page) => Tab(
                    child: Align(
                        alignment: Alignment.center,
                        child: Text("${page.title}"))),
                tabs: [
                  BaseTabPage(
                      title: "Customer Engagement",
                      body: _CustomerEngagementBody<CustomerBranchList>(
                        scrollController: scrollController,
                        builder: (data) => _BranchGridItem(branchItem: data),
                        analysisData: viewModel.branchAnalysis,
                        loadingStatus: status,
                        maxHeaderHeight: 160,
                        headerChild: _EngagementCard(viewModel: viewModel),
                      )),
                  BaseTabPage(
                      title: "Margin Analysis",
                      body: _CustomerEngagementBody<CustomerMarginList>(
                          headerChild: AppChart(
                              showLabels: true,
                              chartType: AppChartType.PIE_CHART,
                              chartData: viewModel.marginAnalysis
                                      ?.map((data) => AppChartModel(
                                            value: data.marginAmount,
                                            axisValue:
                                                data?.marginAmount?.floor() ??
                                                    0,
                                            axis: data.customerType,
                                            color:
                                                charts.ColorUtil.fromDartColor(
                                                    data.color),
                                          ))
                                      ?.toList() ??
                                  [],
                              showLegends: false,
                              title: "title"),
                          scrollController: scrollController,
                          builder: (data) => _MarginGridItem(marginItem: data),
                          analysisData: viewModel.marginAnalysis,
                          loadingStatus: status))
                ]));
  }

  @override
  SalesInsightCustomerViewModel converter(store) =>
      SalesInsightCustomerViewModel.fromStore(store);
}

class _CustomerEngagementBody<T> extends StatelessWidget {
  final List<T> analysisData;
  final LoadingStatus loadingStatus;
  final Function(T data) builder;
  final ScrollController scrollController;
  final Widget headerChild;

  final double maxHeaderHeight;

  const _CustomerEngagementBody(
      {Key key,
      @required this.analysisData,
      @required this.builder,
      this.scrollController,
      this.loadingStatus,
      this.headerChild,
      this.maxHeaderHeight})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loadingStatus == LoadingStatus.loading
        ? LoadingView()
        : Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: GraphDataView(
                maxHeaderHeight: maxHeaderHeight ?? 280,
                scrollController: scrollController,
                headerChild: headerChild,
                data: analysisData,
                builder: (analysisItem) => builder(analysisItem)));
  }
}

class _EngagementCard extends StatelessWidget {
  final SalesInsightCustomerViewModel viewModel;

  const _EngagementCard({Key key, this.viewModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (_context, constrains) {
      double width = (constrains.maxWidth - 12) / 3;

      return Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15))),
          child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                _EngagementItem(
                  title: "New",
                  count: viewModel.onceCustomers,
                  percent: viewModel.oncePercent,
                  color: Colors.green,
                  icon: Icons.person_pin,
                  width: width,
                ),
                SizedBox(width: 2),
                _EngagementItem(
                  title: "Repeat",
                  count: viewModel.repeatCustomers,
                  percent: viewModel.repeatPercent,
                  color: Colors.orangeAccent,
                  icon: Icons.person_pin,
                  width: width,
                ),
                SizedBox(width: 2),
                _EngagementItem(
                  title: "Total",
                  count: viewModel.totalCustomers,
                  color: Colors.blue,
                  icon: Icons.person_pin,
                  width: width,
                )
              ]));
    });
  }
}

class _EngagementItem extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final int count;
  final double percent;
  final double width;

  _EngagementItem(
      {this.color,
      this.icon,
      this.title,
      this.count,
      this.percent,
      this.width});

  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);

    return Container(
        decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: color,
            )),
        child: Material(
            type: MaterialType.transparency,
            child: Container(
                width: width,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                          flex: 3,
                          child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              alignment: Alignment.center,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Icon(icon, size: 45, color: Colors.white),
                                    Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(title,
                                            style: style.bodyBold
                                                .copyWith(color: Colors.white)))
                                  ]))),
                      Flexible(
                          flex: 2,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            alignment: Alignment.center,
                            child: Column(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  Text(count.toString(), style: style.bodyBold),
                                  SizedBox(height: 6),
                                  if (percent != null)
                                    Text("${percent.toString()} %",
                                        style: style.body2),
                                ]),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(10),
                                    bottomRight: Radius.circular(10),
                                    bottomLeft: Radius.circular(40),
                                    topLeft: Radius.circular(40))),
                          ))
                    ]))));
  }
}

class _BranchGridItem extends StatelessWidget {
  final CustomerBranchList branchItem;

  const _BranchGridItem({Key key, @required this.branchItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);

    String newCustomers =
        "${branchItem?.once ?? ""}  (${branchItem?.oncePerc ?? "0"}%)";
    String repeatCustomers =
        "${branchItem?.repeat ?? ""}  (${branchItem?.repeatPerc ?? "0"}%)";

    return Container(
        padding: EdgeInsets.all(6),
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
            borderRadius: new BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(
                color: BaseColors.of(context).hintColor.withOpacity(.5))),
        child: Row(children: <Widget>[
          Expanded(
              child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                Text("${branchItem.branchName}", style: style.bodyBold),
                SizedBox(height: 8),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                  ),
                  child: Text("New : $newCustomers"),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.orangeAccent),
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.transparent,
                  ),
                  child: Text("Repeat : $repeatCustomers"),
                ),
              ])),
          Text("${branchItem.totalCustomers}",
              style: style.bodyBold.copyWith(color: Colors.blue, fontSize: 15))
        ]));
  }
}

class _MarginGridItem extends StatelessWidget {
  final CustomerMarginList marginItem;

  const _MarginGridItem({Key key, @required this.marginItem}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);
    return Container(
        padding: EdgeInsets.all(6),
        margin: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
            borderRadius: new BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(color: marginItem.color)),
        child: Column(children: <Widget>[
          Text(marginItem?.customerType ?? "", style: style.bodyBold),
          SizedBox(height: 8),
          Row(children: <Widget>[
            Expanded(child: Text(" Revenue ")),
            Text("${marginItem?.totalValue ?? ""}")
          ]),
          SizedBox(height: 4),
          Row(children: <Widget>[
            Expanded(child: Text(" Margin Amount ")),
            Text("${marginItem?.marginAmount ?? ""}")
          ]),
          SizedBox(height: 4),
          Row(children: <Widget>[
            Expanded(child: Text(" % ")),
            Text("${marginItem?.marginPerc ?? ""}")
          ]),
        ]));
  }
}
