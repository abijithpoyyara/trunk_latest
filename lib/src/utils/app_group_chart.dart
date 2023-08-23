import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:base/resources.dart';

import 'app_chart.dart';

class AppSeriesChartModel {
  final String title;
  final List<AppChartModel> chartData;

  AppSeriesChartModel({@required this.title, @required this.chartData});
}

class AppGroupChart extends StatelessWidget {
  final List<AppSeriesChartModel> appChartData;

  AppGroupChart(this.appChartData);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 4.0, left: 4.0, top: 4),
      margin: const EdgeInsets.only(right: 2.0, left: 2.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(18),
          ),
          border: Border.all(color: BaseColors.of(context).hintColor)),
      child: _AppBarChart(appChartData, showLegends: true),
    );
  }
}

class _AppBarChart extends StatelessWidget {
  final List<AppSeriesChartModel> seriesList;
  final bool animate;
  final bool showLegends;

  _AppBarChart(this.seriesList, {this.animate = true, this.showLegends});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(_createData(seriesList),
        animate: true,
        vertical: true,
        barRendererDecorator: new charts.BarLabelDecorator<String>(
            labelPosition: charts.BarLabelPosition.outside),
        domainAxis: new charts.OrdinalAxisSpec(
            tickFormatterSpec: charts.BasicOrdinalTickFormatterSpec(),
            renderSpec: charts.SmallTickRendererSpec(
                axisLineStyle: charts.LineStyleSpec(
                    color: charts.ColorUtil.fromDartColor(Colors.transparent)),
                labelJustification: charts.TickLabelJustification.inside,
                labelAnchor: charts.TickLabelAnchor.centered,
                labelStyle: charts.TextStyleSpec(),
                labelRotation: 270)),
        primaryMeasureAxis: charts.NumericAxisSpec(
            tickFormatterSpec:
                charts.BasicNumericTickFormatterSpec.fromNumberFormat(
                    NumberFormat.compactCurrency(
                        decimalDigits: 1, symbol: ''))),
        barGroupingType: charts.BarGroupingType.grouped,
        behaviors: [
          new charts.PanAndZoomBehavior(),
          if (showLegends)
            charts.SeriesLegend(
                position: charts.BehaviorPosition.bottom,
                outsideJustification:
                    charts.OutsideJustification.middleDrawArea,
                horizontalFirst: true,
                desiredMaxRows: 2,
                cellPadding: new EdgeInsets.only(right: 6.0, bottom: 4.0),
                entryTextStyle: charts.TextStyleSpec())
        ]);
  }

  List<charts.Series<AppChartModel, String>> _createData(
      List<AppSeriesChartModel> chartData) {
    return chartData
        .map((data) => new charts.Series<AppChartModel, String>(
              id: data.title,
              domainFn: (AppChartModel chart, _) => chart.axis,
              measureFn: (AppChartModel chart, _) => chart.value,
              colorFn: (AppChartModel chart, __) => chart.color,
              labelAccessorFn: (AppChartModel chart, _) =>
                  '${NumberFormat.compactCurrency(decimalDigits: 1, symbol: '').format(chart.value)}',
              data: data.chartData,
            ))
        .toList();
  }
}
