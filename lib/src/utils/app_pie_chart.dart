import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

import 'app_chart.dart';

class AppPieChart extends StatelessWidget {
  final List<AppChartModel> seriesList;
  final bool animate;
  final bool showLegends;
  final String title;
  final bool showLabels;

  AppPieChart(this.seriesList,
      {this.animate = true, this.showLegends, this.title, this.showLabels});

  @override
  Widget build(BuildContext context) => charts.PieChart(
        _createData(seriesList),
        animate: animate ?? false,
      );

  List<charts.Series<AppChartModel, String>> _createData(
      List<AppChartModel> chartData) {
    return [
      charts.Series<AppChartModel, String>(
        id: title,
        domainFn: (AppChartModel chart, _) => chart.axis,
        measureFn: (AppChartModel chart, _) => chart.value,
        colorFn: (AppChartModel chart, position) => chart.color,
        labelAccessorFn: (AppChartModel chart, _) =>
            showLabels ? '${chart.axis} ' : "",
        data: chartData,
      )
    ];
  }
}

class AppDonutChart extends StatelessWidget {
  final List<AppChartModel> seriesList;
  final bool animate;
  final bool showLegends;
  final String title;
  final bool showLabels;

  AppDonutChart(this.seriesList,
      {this.animate = true, this.showLegends, this.title, this.showLabels});

  @override
  Widget build(BuildContext context) => charts.PieChart(_createData(seriesList),
      animate: animate ?? false,
      defaultRenderer: new charts.ArcRendererConfig(
          arcWidth: 50,
          minHoleWidthForCenterContent: 10,
          arcRatio: .3,
          arcRendererDecorators: [
            new charts.ArcLabelDecorator(
              labelPadding: 1,
              leaderLineColor: charts.MaterialPalette.white,
              labelPosition: charts.ArcLabelPosition.auto,
            )
          ]));

  List<charts.Series<AppChartModel, String>> _createData(
      List<AppChartModel> chartData) {
    return [
      charts.Series<AppChartModel, String>(
        id: title,
        domainFn: (AppChartModel chart, _) => chart.axis,
        measureFn: (AppChartModel chart, _) => chart.value,
        colorFn: (AppChartModel chart, position) => chart.color,
        labelAccessorFn: (AppChartModel chart, _) =>
            showLabels ? '${chart.axis} ' : "",
        data: chartData,
      )
    ];
  }
}
