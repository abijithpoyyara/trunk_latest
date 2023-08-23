import 'package:base/utility.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BaseChartModel {
  final String axis;
  final double value;
  final int axisValue;
  final charts.Color color;
  final bool isMonth;

  BaseChartModel(
      {@required this.axis,
      this.axisValue = 0,
      @required this.value,
      @required this.color,
      this.isMonth = true});
}

class BaseLineChartModel {
  final int axis;
  final double value;
  final charts.Color color;
  final bool isMonth;

  BaseLineChartModel(
      {@required this.axis,
      @required this.value,
      this.color,
      this.isMonth = true});

  factory BaseLineChartModel.fromBaseChart(BaseChartModel data) =>
      BaseLineChartModel(
          axis: data.axisValue,
          isMonth: data.isMonth,
          value: data.value,
          color: data.color);
}

class BaseSeriesChartModel {
  final String title;
  final List<BaseChartModel> chartData;

  BaseSeriesChartModel({@required this.title, @required this.chartData});
}

class BaseChart extends StatefulWidget {
  final List<BaseLineChartModel> lineChartData;
  final BaseSeriesChartModel baseChartData;
  final bool showLegends;

  BaseChart(List<BaseChartModel> data,
      {String chartName, this.showLegends = false})
      : lineChartData = data
            .map((lineChartData) =>
                BaseLineChartModel.fromBaseChart(lineChartData))
            .toList(),
        this.baseChartData =
            BaseSeriesChartModel(title: chartName, chartData: data);

  @override
  State<StatefulWidget> createState() => BaseChartState();
}

class BaseChartState extends State<BaseChart> {
  bool isShowingMainData;

  @override
  void initState() {
    super.initState();
    isShowingMainData = true;
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(18)),
            border: Border.all(color: Theme.of(context).popupMenuTheme.color)),
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(height: 10),
//                _BaseChartToolsPanel(),
                const SizedBox(height: 7),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 16.0, left: 6.0),
//                    child: _BaseLineChart(widget.lineChartData),
                    child: _BaseBarChart([widget.baseChartData],
                        showLegends: widget.showLegends),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class BaseGroupChart extends StatelessWidget {
  final List<BaseSeriesChartModel> appChartData;

  BaseGroupChart(this.appChartData);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
        aspectRatio: 1.23,
        child: Container(
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(18)),
                border:
                    Border.all(color: Theme.of(context).popupMenuTheme.color)),
            child: Stack(children: <Widget>[
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: <
                  Widget>[
                const SizedBox(height: 37),
                Expanded(
                  child: Padding(
                      padding: const EdgeInsets.only(right: 16.0, left: 6.0),
//                    child: _BaseLineChart(widget.lineChartData),
                      child: _BaseBarChart(appChartData, showLegends: true)),
                ),
                const SizedBox(height: 4)
              ])
            ])));
  }
}

class _BaseBarChart extends StatelessWidget {
  final List<BaseSeriesChartModel> seriesList;
  final bool animate;
  final bool showLegends;

  _BaseBarChart(this.seriesList, {this.animate = true, this.showLegends});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(_createData(seriesList),
        animate: true,
        vertical: true,
        barRendererDecorator: new charts.BarLabelDecorator<String>(
            labelPosition: charts.BarLabelPosition.outside),
        domainAxis: new charts.OrdinalAxisSpec(),
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
                position: charts.BehaviorPosition.top,
                outsideJustification:
                    charts.OutsideJustification.middleDrawArea,
                horizontalFirst: true,
                desiredMaxRows: 2,
                cellPadding: new EdgeInsets.only(right: 6.0, bottom: 4.0),
                entryTextStyle: charts.TextStyleSpec())
        ]);
  }

  List<charts.Series<BaseChartModel, String>> _createData(
      List<BaseSeriesChartModel> chartData) {
    return chartData
        .map((data) => new charts.Series<BaseChartModel, String>(
              id: data.title,
              domainFn: (BaseChartModel chart, _) => chart.axis,
              measureFn: (BaseChartModel chart, _) => chart.value,
              colorFn: (BaseChartModel chart, __) => chart.color,
              labelAccessorFn: (BaseChartModel chart, _) =>
                  '${NumberFormat.compactCurrency(decimalDigits: 1, symbol: '').format(chart.value)}',
              data: data.chartData,
            ))
        .toList();
  }
}

class _BaseLineChart extends StatelessWidget {
  final List<BaseLineChartModel> seriesList;
  final bool animate;

  _BaseLineChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
      _createData(seriesList),
      animate: animate,
    );
  }

  List<charts.Series<BaseLineChartModel, int>> _createData(List data) {
    return [
      new charts.Series<BaseLineChartModel, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (BaseLineChartModel chart, _) => chart.axis.toInt(),
        measureFn: (BaseLineChartModel chart, _) => chart.value,
        labelAccessorFn: (BaseLineChartModel chart, _) =>
            BaseDates.findMonth(chart.axis.toInt()),
        data: data,
      )
    ];
  }
}

enum ChartType { BAR_CHART, LINE_CHART, PIE_CHART, NONE, GROUP }

class _BaseChartToolsPanel extends StatelessWidget {
  final VoidCallback onRotateChart;
  final VoidCallback onShowPieChart;
  final VoidCallback onShowLineChart;
  final VoidCallback onShowBarChart;
  final ChartType selectedType;

  _BaseChartToolsPanel(
      {this.onRotateChart,
      this.onShowPieChart,
      this.onShowLineChart,
      this.onShowBarChart,
      this.selectedType});

  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
      IconButton(
        icon: Icon(Icons.rotate_90_degrees_ccw),
        onPressed: onRotateChart,
      ),
      IconButton(
        icon: Icon(Icons.pie_chart),
        onPressed: onShowPieChart,
      ),
      IconButton(
        icon: Icon(Icons.insert_chart),
        onPressed: onShowBarChart,
      ),
      IconButton(
        icon: Icon(Icons.show_chart),
        onPressed: onShowLineChart,
      )
    ]);
  }
}
