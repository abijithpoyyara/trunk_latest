import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:base/resources.dart';
import 'package:base/resources.dart';
import 'package:redstars/src/widgets/screens/report_engine/report_helper.dart';

class SummaryReport<T> extends StatelessWidget {
  final List<T> reportData;
  final int gridAxisCount;
  final AppChildBuilder headerBuilder;
  final AppWidgetBuilder<T> gridChildBuilder;
  final AppChildBuilder footerChildBuilder;

  const SummaryReport(
      {Key key,
      this.reportData,
      this.headerBuilder,
      @required this.gridChildBuilder,
      this.footerChildBuilder,
      this.gridAxisCount = 2})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseColors _colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    double size = MediaQuery.of(context).size.width / 2;

    return Container(
      // padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(bottom: 10),
      color: themeData.primaryColor,

      child: GridView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: reportData?.length,
          padding: EdgeInsets.zero,
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
              childAspectRatio: 2.3, maxCrossAxisExtent: size),
          itemBuilder: (BuildContext context, int index) {
            final data = reportData[index];
            return  Container(
              alignment: Alignment.center,
              child: gridChildBuilder(data, index),
            );
          }),
    );
  }
}
