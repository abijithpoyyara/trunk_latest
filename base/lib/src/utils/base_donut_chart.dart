import 'package:base/resources.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class BaseDonutChartDataModel {
  final String axis;
  final double value;
  final String axisValue;

  BaseDonutChartDataModel({
    @required this.axis,
    this.axisValue,
    @required this.value,
  });
}

class BasePieChartModel {
  final String axis;
  final double value;
  final color;

  BasePieChartModel({
    @required this.axis,
    @required this.value,
    this.color,
  });

  factory BasePieChartModel.fromBaseChart(BaseDonutChartDataModel data) =>
      BasePieChartModel(axis: data.axisValue, value: data.value);
}

class BaseDonutSeriesChartModel {
  final String title;
  final List<BaseDonutChartDataModel> chartData;

  BaseDonutSeriesChartModel({@required this.title, @required this.chartData});
}

class BaseDonutChartData extends StatefulWidget {
  final List<BasePieChartModel> pieChartData;
  final BaseDonutSeriesChartModel appChartData;
  final bool showLegends;

  BaseDonutChartData(List<BaseDonutChartDataModel> data,
      {String chartName, this.showLegends = true})
      : pieChartData = data
            .map(
                (pieChartData) => BasePieChartModel.fromBaseChart(pieChartData))
            .toList(),
        this.appChartData =
            BaseDonutSeriesChartModel(title: chartName, chartData: data);

  @override
  State<StatefulWidget> createState() => BaseDonutChartDataState();
}

class BaseDonutChartDataState extends State<BaseDonutChartData> {
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
                border: Border(
                    bottom: BaseBorderSide(),
                    left: BaseBorderSide(),
                    top: BaseBorderSide(),
                    right: BaseBorderSide())),
            child: Stack(children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    const SizedBox(height: 40),
                    Expanded(
                        child: Padding(
                            padding:
                                const EdgeInsets.only(right: 16.0, left: 6.0),
                            child: _BasePieChart([widget.appChartData],
                                showLegends: widget.showLegends))),
                    const SizedBox(height: 10)
                  ])
            ])));
  }
}

class _BasePieChart extends StatelessWidget {
  final List<BaseDonutSeriesChartModel> seriesList;
  final bool animate;
  final bool showLegends;

  _BasePieChart(this.seriesList, {this.animate = true, this.showLegends});

  @override
  Widget build(BuildContext context) =>
      charts.PieChart(_createData(context, seriesList),
          animate: true,
          defaultRenderer: new charts.ArcRendererConfig(
              arcWidth: 20,
              minHoleWidthForCenterContent: 10,
              arcRatio: .3,
              arcRendererDecorators: [
                new charts.ArcLabelDecorator(
                    labelPadding: 1,
                    // outsideLabelStyleSpec: new charts.TextStyleSpec(...),
                    leaderLineColor: charts.MaterialPalette.white,
                    labelPosition: charts.ArcLabelPosition.outside)
              ]));

  List<charts.Series<BaseDonutChartDataModel, String>> _createData(
      BuildContext context, List<BaseDonutSeriesChartModel> chartData) {
    final List<charts.Color> circleColors = [
      charts.ColorUtil.fromDartColor(BaseColors.of(context).chartColors[1]),
      charts.ColorUtil.fromDartColor(BaseColors.of(context).chartColors[2]),
      charts.ColorUtil.fromDartColor(BaseColors.of(context).chartColors[3])
    ];
    return chartData
        .map((data) => new charts.Series<BaseDonutChartDataModel, String>(
              id: 'pieData',
              domainFn: (BaseDonutChartDataModel chart, _) => chart.axis,
              measureFn: (BaseDonutChartDataModel chart, _) => chart.value,
              colorFn: (BaseDonutChartDataModel chart, position) =>
                  circleColors[position],
              labelAccessorFn: (BaseDonutChartDataModel chart, _) =>
                  '${chart.axis} ',
              data: data.chartData,
            ))
        .toList();
  }
}
