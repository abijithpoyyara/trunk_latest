import 'package:base/utility.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:base/resources.dart';

import 'app_pie_chart.dart';

enum AppChartType { BAR_CHART, LINE_CHART, PIE_CHART, DONUT_CHART }

class AppChartModel {
  final String axis;
  final double value;
  final int axisValue;
  final charts.Color color;
  final int groupId;

  AppChartModel(
      {@required this.axis,
      this.axisValue = 0,
      @required this.value,
      @required this.color,
      this.groupId});
}

class _AppCharts extends StatelessWidget {
  final AppChartType chartType;
  final List<AppChartModel> chartData;
  final bool showLegends;
  final String title;
  final bool showLabels;

  const _AppCharts(
      {Key key,
      @required this.chartType,
      @required this.chartData,
      this.showLegends,
      this.title,
      this.showLabels})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (chartType) {
      case AppChartType.BAR_CHART:
        return _AppBarChart(chartData,
            showLabels: showLabels,
            showLegends: showLegends,
            title: title,
            animate: true);

      case AppChartType.LINE_CHART:
        return _AppLineChart(chartData, animate: true);

      case AppChartType.PIE_CHART:
        return AppPieChart(chartData,
            showLabels: showLabels,
            showLegends: showLegends,
            title: title,
            animate: true);

      case AppChartType.DONUT_CHART:
        return AppDonutChart(chartData,
            showLabels: showLabels,
            showLegends: showLegends,
            title: title,
            animate: true);
    }
    return SizedBox();
  }
}

class AppChart extends StatefulWidget {
  final AppChartType chartType;
  final List<AppChartModel> chartData;
  final bool showLegends;
  final String title;
  final bool showLabels;

  const AppChart(
      {Key key,
      @required this.chartType,
      @required this.chartData,
      this.showLegends,
      this.showLabels = true,
      this.title})
      : super(key: key);

  @override
  _AppChartState createState() => _AppChartState(chartType: chartType);
}

class _AppChartState extends State<AppChart> {
  AppChartType chartType;

  _AppChartState({this.chartType});

  @override
  Widget build(BuildContext context) {
    List<Color> _colors = [
      BaseColors.of(context).selectedColor,
      BaseColors.of(context).secondaryColor
    ];
    List<double> _stops = [0.2, 0.5];
    return Container(
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
//        padding: const EdgeInsets.only(right: 4.0, left: 4.0),
        child: Row(children: <Widget>[
          SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    if (widget.chartData.length < 18)
                      _AppChartTypeList(
                          icon: Icons.insert_chart,
                          isSelected: chartType == AppChartType.BAR_CHART,
                          onClick: () {
                            setState(() {
                              chartType = AppChartType.BAR_CHART;
                            });
                          }),
                    _AppChartTypeList(
                        icon: Icons.pie_chart,
                        isSelected: chartType == AppChartType.PIE_CHART,
                        onClick: () {
                          setState(() {
                            chartType = AppChartType.PIE_CHART;
                          });
                        }),
                    _AppChartTypeList(
                        icon: Icons.donut_small,
                        isSelected: chartType == AppChartType.DONUT_CHART,
                        onClick: () {
                          setState(() {
                            chartType = AppChartType.DONUT_CHART;
                          });
                        }),
                  ])),
          Expanded(
              child: _AppCharts(
                  chartType: chartType,
                  chartData: widget.chartData,
                  showLegends: widget.showLegends,
                  title: widget.title,
                  showLabels: widget.showLabels))
        ]));
  }
}

class _AppChartTypeList extends StatelessWidget {
  final IconData icon;
  final VoidCallback onClick;
  final bool isSelected;

  _AppChartTypeList(
      {@required this.icon, this.onClick, this.isSelected = false});

  @override
  Widget build(BuildContext context) {
    BaseColors _colors = BaseColors.of(context);
    return IconButton(
        icon: Icon(icon,
            color: isSelected ? _colors.secondaryColor: _colors.hintColor),
        onPressed: onClick,
        iconSize: isSelected ? 24.0 : 18.0);
  }
}

class _AppBarChart extends StatelessWidget {
  final List<AppChartModel> seriesList;
  final bool animate;
  final bool showLegends;
  final String title;

  final bool showLabels;

  _AppBarChart(this.seriesList,
      {this.animate = true, this.showLegends, this.title, this.showLabels});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(_createData(seriesList),
        animate: true,
        vertical: true,
        barRendererDecorator: new charts.BarLabelDecorator<String>(
            labelAnchor: charts.BarLabelAnchor.middle,
            labelPosition: charts.BarLabelPosition.outside,
            outsideLabelStyleSpec: charts.TextStyleSpec()),
        domainAxis: new charts.OrdinalAxisSpec(
          renderSpec: new charts.NoneRenderSpec(),
          showAxisLine: true,
        ),
        primaryMeasureAxis: charts.NumericAxisSpec(
          renderSpec: charts.NoneRenderSpec(),
          showAxisLine: false,
//            tickFormatterSpec:
//                charts.BasicNumericTickFormatterSpec.fromNumberFormat(
//                    NumberFormat.compactCurrency(
//                        decimalDigits: 1, symbol: ''))
        ),
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

  List<charts.Series<AppChartModel, String>> _createData(
      List<AppChartModel> chartData) {
    return [
      charts.Series<AppChartModel, String>(
          id: title,
          labelAccessorFn: (AppChartModel chart, _) =>
              showLabels ? NumberFormat.compact().format(chart.value) : "",
          domainFn: (AppChartModel chart, _) => chart.axis,
          measureFn: (AppChartModel chart, _) => chart.value,
          colorFn: (AppChartModel chart, __) => chart.color,
          data: chartData)
    ];
  }
}

class _AppLineChart extends StatelessWidget {
  final List<AppChartModel> seriesList;
  final bool animate;

  _AppLineChart(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.LineChart(
      _createData(seriesList),
      animate: animate,
    );
  }

  List<charts.Series<AppChartModel, int>> _createData(List data) {
    return [
      new charts.Series<AppChartModel, int>(
        id: 'Sales',
        colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
        domainFn: (AppChartModel chart, _) => chart.axisValue,
        measureFn: (AppChartModel chart, _) => chart.value,
        labelAccessorFn: (AppChartModel chart, _) =>
            BaseDates.findMonth(chart.axisValue.toInt()),
        data: data,
      )
    ];
  }
}
