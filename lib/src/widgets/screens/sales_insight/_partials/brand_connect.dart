import 'package:base/redux.dart';
import 'package:base/widgets.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/redux/actions/sales_insight/sales_insight_brand_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/sales_insight/sale_insight_brand_viewmodel.dart';
import 'package:redstars/src/services/model/response/sales_insight/brand_connect_analysis.dart';
import 'package:redstars/src/utils/app_chart.dart';
import 'package:redstars/src/utils/app_number_format.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_models/filter_model.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_partials/sale_enquiry_base.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_views/helper.dart';

class BrandConnect extends StatelessWidget
    with BaseStoreMixin<AppState, SalesInsightBrandViewModel> {
  @override
  SalesInsightBrandViewModel converter(store) =>
      SalesInsightBrandViewModel.fromStore(store);

  @override
  void init(Store store, BuildContext context) {
    final state = store.state.salesInsightState.salesInsightBrandState;
    store.dispatch(fetchBrandConnectList(state.fromDate, state.toDate));
  }

  @override
  Widget childBuilder(
      BuildContext context, SalesInsightBrandViewModel viewModel) {
    final status = viewModel.loadingStatus;
    return SalesInsightBaseContainer(
        hasMajorBrand: true,
        hasMargin: false,
        filterModel: SaleInsightFilterModel(
          fromDate: viewModel.fromDate,
          toDate: viewModel.toDate,
          isMajorCategory: viewModel.major,
          isMargin: viewModel.major,
        ),
        onFilterClicked: (filter) => viewModel.onFilterBrand(filter),
        builder: (scrollController) => _AnalysisBody(
              analysisData: viewModel.brandConnectlist,
              loadingStatus: status,
              scrollController: scrollController,
            ));
  }
}

class _AnalysisBody extends StatelessWidget {
  final List<BrandConnectList> analysisData;
  final LoadingStatus loadingStatus;
  final ScrollController scrollController;

  const _AnalysisBody(
      {Key key, this.analysisData, this.loadingStatus, this.scrollController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return loadingStatus == LoadingStatus.loading
        ? LoadingView()
        : GraphDataView(
            scrollController: scrollController,
            headerChild: AppChart(
              showLabels: false,
              chartType: AppChartType.PIE_CHART,
              chartData: analysisData
                      ?.map((data) => AppChartModel(
                            value: data.revenue,
                            axisValue: data?.qty?.floor() ?? 0,
                            color: charts.ColorUtil.fromDartColor(data.color),
                            axis: data.brand,
                          ))
                      ?.toList() ??
                  [],
              showLegends: false,
            ),
            data: analysisData,
            builder: (analysisItem) => _AnalysisGridItem(
                brand: analysisItem?.brand,
                color: analysisItem?.color ?? Colors.blue,
                qty: analysisItem?.qty,
                revenue: AppNumberFormat(number: analysisItem?.revenue ?? 0)
                    .formatCurrency()));
  }
}

class _AnalysisGridItem extends StatelessWidget {
  final String brand;
  final String revenue;
  final int qty;
  final Color color;

  const _AnalysisGridItem(
      {Key key, this.brand, this.revenue, this.qty, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.bottomRight,
                colors: <Color>[color.withOpacity(.02), Colors.white]),
            borderRadius: new BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(color: color, width: 1.2)),
        child: Row(children: <Widget>[
          Expanded(
              flex: 4,
              child: Text(brand ?? "",
                  style: TextStyle(
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87))),
          if (qty != null) Expanded(flex: 3, child: Text(qty.toString() ?? "")),
          Expanded(flex: 5, child: Text(revenue ?? "")),
        ]));
  }
}
