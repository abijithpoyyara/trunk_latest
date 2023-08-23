import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/widgets/screens/report_engine/report_helper.dart';

class ReportEngineView<T> extends StatelessWidget {
  final bool isExpandable;
  final List<T> reportData;
  final Function(T, int) onClick;
  final Function(T, int) onLongPress;
  final AppWidgetBuilder<T> overChildBuilder;
  final AppWidgetBuilder<T> childBuilder;
  final AppWidgetBuilder<T> leadingChildBuilder;
  final AppWidgetBuilder<T> trailingChildBuilder;

  const ReportEngineView(
      {Key key,
      this.isExpandable = false,
      @required this.reportData,
      this.onClick,
      this.childBuilder,
      this.leadingChildBuilder,
      this.trailingChildBuilder,
      this.onLongPress,
      this.overChildBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: _StandardReport<T>(
      reportData: reportData,
      childBuilder: childBuilder,
      onClick: (data, index) => onClick(data, index),
      onLongPress: (data, index) => onLongPress(data, index),
      overChildBuilder: overChildBuilder,
      leadingChildBuilder: leadingChildBuilder,
      trailingChildBuilder: trailingChildBuilder,
    ));
  }
}

class _StandardReport<T> extends StatelessWidget {
  final List<T> reportData;
  final Function(T, int) onClick;
  final Function(T, int) onLongPress;
  final AppWidgetBuilder<T> childBuilder;
  final AppWidgetBuilder<T> leadingChildBuilder;
  final AppWidgetBuilder<T> trailingChildBuilder;
  final AppWidgetBuilder<T> overChildBuilder;

  const _StandardReport(
      {Key key,
      this.reportData,
      this.onClick,
      //@required
      this.childBuilder,
      this.leadingChildBuilder,
      this.trailingChildBuilder,
      this.onLongPress,
      this.overChildBuilder})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: reportData?.length??0,
        itemBuilder: (_context, index) {
          final data = reportData[index];
          return _ListItem(
             // onLongPress: () => onLongPress(data, index),
              child: childBuilder(data, index),
            //  onClick: () => onClick(data, index),
             // trailing: trailingChildBuilder(data, index),
             // leading: leadingChildBuilder(data, index),
              //top: overChildBuilder(data, index)
          );
        },
        physics: BouncingScrollPhysics(),
        shrinkWrap: true);
  }
}

class _ListItem extends StatelessWidget {
  final Widget leading;
  final Widget trailing;
  final Widget child;
  final Widget top;
  final Function onClick;
  final Function onLongPress;

  const _ListItem(
      {Key key,
      this.leading,
      @required this.child,
      this.trailing,
      this.onClick,
      this.top,
      this.onLongPress})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return InkWell(
        onTap: () => onClick(),
//        onLongPress: () => onLongPress(),
        child: Stack(
//          crossAxisAlignment: CrossAxisAlignment.stretch,
//fit: StackFit.passthrough,
            children: <Widget>[
              Container(
                color: themeData.scaffoldBackgroundColor,
                // margin: EdgeInsets.all(4),
                padding: EdgeInsets.all(4),
                // decoration: BoxDecoration(
                //     color: colors.secondaryColor,
                //     border: Border.all(color: colors.hintColor),
                //     borderRadius: BorderRadius.circular(4)),
                child: Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                         // leading,
                          Expanded(child: child),
                         // trailing
                        ]),
                    SizedBox(height: 6,)
                  ],
                ),
              ),
              if (top != null) top,
            ]));
  }
}
