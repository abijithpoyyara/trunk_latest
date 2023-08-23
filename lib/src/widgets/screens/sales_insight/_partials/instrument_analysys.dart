import 'package:base/redux.dart';
import 'package:base/resources.dart';
import 'package:base/widgets.dart';
import 'package:charts_flutter/flutter.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/redux/actions/sales_insight/instrument_analysis_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/sales_insight/sale_insight_instrument_viewmodel.dart';
import 'package:redstars/src/services/model/response/sales_insight/instrument_analysis_model.dart';
import 'package:redstars/src/utils/app_chart.dart';
import 'package:redstars/src/utils/app_group_chart.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_models/filter_model.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_partials/sale_enquiry_base.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_views/helper.dart';

class InstrumentAnalysis extends StatelessWidget
    with BaseStoreMixin<AppState, SalesInsightInstrumentViewModel> {
  @override
  void init(Store store, BuildContext context) {
    super.init(store, context);
    final state = store.state.salesInsightState.salesInsightInstrumentState;
    store.dispatch(fetchHeaderData(state.fromDate, state.toDate));
    store.dispatch(fetchAnalysisData(state.fromDate, state.toDate));
  }

  @override
  Widget childBuilder(
      BuildContext context, SalesInsightInstrumentViewModel viewModel) {
    return SalesInsightBaseContainer(
        hasMajorBrand: false,
        hasMargin: false,
        filterModel: SaleInsightFilterModel(
          fromDate: viewModel.fromDate,
          toDate: viewModel.toDate,
        ),
        onFilterClicked: (filter) => viewModel.onFilter(filter),
        builder: (scrollController) => _AnalysisBody(viewModel: viewModel));
  }

  @override
  SalesInsightInstrumentViewModel converter(store) =>
      SalesInsightInstrumentViewModel.fromStore(store);
}

class _AnalysisBody extends StatelessWidget {
  final ScrollController scrollController;

  final SalesInsightInstrumentViewModel viewModel;

  const _AnalysisBody({Key key, this.scrollController, this.viewModel})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return viewModel.loadingStatus == LoadingStatus.loading
        ? LoadingView()
        : GraphDataView(
            scrollController: scrollController,
            headerChild: AppGroupChart(buildChart()),
            data: viewModel.instrumentDtl,
            builder: (Map<String, dynamic> analysisItem) => _AnalysisGridItem(
                  headers: viewModel.headers,
                  data: analysisItem,
                ));
  }

  List<AppSeriesChartModel> buildChart() {
    List<AppChartModel> credit = List();
    List<AppChartModel> axis = List();
    List<AppChartModel> advance = List();
    final _creditCol =
        ColorUtil.fromDartColor(RandomColorPicker().getRandomColor());
    final _axisCol =
        ColorUtil.fromDartColor(RandomColorPicker().getRandomColor());
    final _advanceCol =
        ColorUtil.fromDartColor(RandomColorPicker().getRandomColor());

    viewModel.coordinatesDtl?.forEach((data) {
      credit.add(AppChartModel(
          value: data.credit,
          axisValue: data?.credit?.floor() ?? 0,
          axis: data.branch,
          color: _creditCol));
      axis.add(AppChartModel(
          value: data.axisCard,
          axisValue: data?.axisCard?.floor() ?? 0,
          axis: data.branch,
          color: _axisCol));
      advance.add(AppChartModel(
          value: data.advance,
          axisValue: data?.advance?.floor() ?? 0,
          axis: data.branch,
          color: _advanceCol));
    });

    return [
      AppSeriesChartModel(chartData: credit, title: "credit"),
      AppSeriesChartModel(chartData: axis, title: "axis"),
      AppSeriesChartModel(chartData: advance, title: "advance"),
    ];
  }
}

class _AnalysisGridItem extends StatelessWidget {
  final List<InstrumentHeader> headers;
  final Map<String, dynamic> data;

  const _AnalysisGridItem({
    Key key,
    this.headers,
    this.data,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(8),
        margin: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
            borderRadius: new BorderRadius.all(Radius.circular(8.0)),
            border: Border.all(color: BaseColors.of(context).hintColor)),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: headers
                .map<Widget>((header) => _ItemRow(
                      title: "${header.header}",
                      value: "${data[header.dataindex] ?? ""}",
                    ))
                .toList()));
  }
}

class _ItemRow extends StatelessWidget {
  final String title;
  final String value;

  const _ItemRow({Key key, this.title, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme style = BaseTheme.of(context);
    return Row(
      children: <Widget>[
        Expanded(
            child: Text(
          title ?? "",
          style: style.bodyBold,
        )),
        Text(value ?? "", textAlign: TextAlign.end, style: style.subhead1Bold)
      ],
    );
  }
}
