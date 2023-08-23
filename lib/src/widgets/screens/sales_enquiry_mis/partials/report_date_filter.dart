import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_style.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/resources.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/material.dart';
import 'package:redstars/res/drawbles/app_vectors.dart';
import 'package:redstars/src/redux/viewmodels/sales_enquiry_mis/sales_enquiry_mis_viewmodel.dart';

class FilterWidget extends StatefulWidget {
  final SalesEnquiryMisViewModel viewModel;

  const FilterWidget({Key key, @required this.viewModel}) : super(key: key);

  @override
  __FilterWidgetState createState() => __FilterWidgetState();
}

class __FilterWidgetState extends State<FilterWidget> {
  int selected;

  @override
  void initState() {
    selected = widget.viewModel.selectedTab ?? 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (BuildContext context) {
      BaseTheme theme = BaseTheme.of(context);
      return Column(children: [
        Row(
          children: [
            buildCardWidget(
                title: "As on Date",
                selected: selected == 1,
                onTap: () {
                  widget.viewModel.getReportOnAsonDate();
                  setState(() => selected = 1);
                }),
            buildCardWidget(
                title: "Period Wise",
                selected: selected == 2,
                onTap: () => setState(() => selected = 2)),
            buildCardWidget(
                title: "Month Wise",
                selected: selected == 3,
                onTap: () => setState(() => selected = 3)),
          ],
        ),
        Center(
            child: AnimatedSwitcher(
                duration: Duration(milliseconds: 400),
                child: _getContentBody(
                  key: UniqueKey(),
                ),
                switchInCurve: Curves.easeInToLinear,
                switchOutCurve: Curves.easeIn,
                transitionBuilder: (Widget child, Animation<double> animation) {
                  return SizeTransition(sizeFactor: animation, child: child
                      // transitionBuilder: __transitionBuilder,
                      // layoutBuilder: (widget, list) => Stack(children: [widget, ...list]),
                      );
                })),
      ]);
    });
  }

  Widget _getContentBody({UniqueKey key}) {
    switch (selected) {
      case 1:
        return buildAsOnDateContainer();
      case 2:
        return buildPeriodContainer();
      case 3:
        return buildMonthContainer();
    }
    return null;
  }

  buildAsOnDateContainer() {
    return Card(
        color: ThemeProvider.of(context).primaryColor,
        child: Column(children: [
      BaseDatePicker(
        isVector: true,
        icon: Icons.calendar_today,
        isEnabled: false,
        displayTitle: "As on Date",
        initialValue: widget.viewModel.asOnDate,
      )
    ]));
  }

  buildPeriodContainer() {
    return Card(
 color: ThemeProvider.of(context).primaryColor,
      child: Column(
        children: [
          BaseDatePicker(
            isVector: true,
            icon: Icons.calendar_today,
            isEnabled: true,
            displayTitle: "From Date",
            initialValue: widget.viewModel.fromDate,
            onChanged: (date) => widget.viewModel.onDateChanged(fromDate: date),
          ),
          BaseDatePicker(
            isVector: true,
            icon: Icons.calendar_today,
            isEnabled: true,
            displayTitle: "To Date",
            initialValue: widget.viewModel.toDate,
            onChanged: (date) => widget.viewModel.onDateChanged(toDate: date),
          ),
        ],
      ),
    );
  }

  buildMonthContainer() {
    return Builder(builder: (context) {
      return Card(
        color: ThemeProvider.of(context).primaryColor,
        child: Column(
          children: [
            BaseDialogField<FinYearModel>(
              vector: AppVectors.calenderSettlement,
              isEnabled: true,
              displayTitle: "Financial Year",
              list: widget.viewModel.finYears,
              fieldBuilder: (data) => Text(data.finyeardesc),
              listBuilder: (data, index) => DocumentTypeTile(
                icon: Icons.calendar_today_outlined,
                title: data.finyeardesc,
                onPressed: () => Navigator.pop(context, data),
                isVector: true,
                // subTitle: '${data.finyearcode} ',
              ),
              initialValue: widget.viewModel.selectedFinYear,
              onChanged: (finyear) =>
                  widget.viewModel.onFinYearChanged(finyear),
            ),
            BaseDialogField<CalendarModel>(
              vector: AppVectors.calenderSettlement,
              isEnabled: true,
              displayTitle: "Month",
              list: widget.viewModel.calenderMonths,
              initialValue: widget.viewModel.selectedMonth,
              fieldBuilder: (data) => Text(data.monthname),
              listBuilder: (data, index) => DocumentTypeTile(
                icon: Icons.calendar_today_outlined,
                title: data.monthname,
                subTitle: '${data.monthnumber} - ${data.monthname}',
                onPressed: () => Navigator.pop(context, data),
                isVector: true,
              ),
              onChanged: (month) => widget.viewModel.getReportOnMonth(month),
            ),
          ],
        ),
      );
    });
  }

  buildCardWidget({bool selected, String title, VoidCallback onTap}) {
    return Builder(builder: (context) {
      BaseTheme theme = BaseTheme.of(context);
      BaseColors colors = BaseColors.of(context);
      ThemeData themeData = ThemeProvider.of(context);

      return Expanded(
        child: InkWell(
          focusColor: Colors.transparent,
          highlightColor: Colors.transparent,
          hoverColor: Colors.transparent,
          splashColor: Colors.grey.withOpacity(0.2),
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
            onTap();
          },
          child: AnimatedContainer(
            duration: Duration(milliseconds: 300),
            margin: EdgeInsets.all(8),
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.fromBorderSide(BaseBorderSide(
                  color: selected ? themeData.primaryColor : colors.white,
                )),
                color: selected ? themeData.primaryColorDark : themeData.scaffoldBackgroundColor,
                boxShadow: [
                  // if (selected)
                  //   BoxShadow(
                  //       color: colors.accentColor.withOpacity(.4),
                  //       blurRadius: 8,
                  //       offset: Offset(4, 8))
                ]),
            child: Text(
              "$title",
              style: theme.bodyBold.copyWith(
                color: !selected ? colors.white : colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    });
  }
}
