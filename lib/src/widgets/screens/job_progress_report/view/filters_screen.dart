import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/services.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/viewmodels/job_progress/job_progress_viewmodel.dart';

class FiltersScreen extends StatefulWidget {
  final JobProgressViewModel viewModel;

  const FiltersScreen({Key key, this.viewModel}) : super(key: key);

  @override
  _FiltersScreenState createState() => _FiltersScreenState();
}

class _FiltersScreenState extends State<FiltersScreen> {
  BCCModel reportType;
  bool isAllBranch;
  BranchModel selectedBranch;
  DateTimeRange period;

  @override
  void initState() {
    super.initState();
    reportType = widget.viewModel.selectedProcessFlow;
    isAllBranch = widget.viewModel.isAllBranch;
    selectedBranch = widget.viewModel.selectedBranch;
    period = DateTimeRange(
      start: widget.viewModel.fromDate,
      end: widget.viewModel.toDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    BaseColors colors = BaseColors.of(context);
    BaseTheme theme = BaseTheme.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    return Container(
      child: Scaffold(
        appBar: BaseAppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Filters",
                textAlign: TextAlign.center,
                style: theme.title.copyWith(),
              ),
              Material(
                  color: Colors.transparent,
                  child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.close),
                      ))),
            ],
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              color: ThemeProvider.of(context).primaryColor,
              padding: const EdgeInsets.all(8.0),
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Expanded(
                    child: BaseDatePicker(
                      isVector: true,
                      icon: Icons.calendar_today,
                      initialValue: period.start,
                      displayTitle: 'From Date',
                      onChanged: (date) => setState(() =>
                          period = DateTimeRange(start: date, end: period.end)),
                    ),
                  ),
                  Expanded(
                    child: BaseDatePicker(
                      isVector: true,
                      initialValue: period.end,
                      icon: Icons.calendar_today,
                      displayTitle: 'To Date',
                      onChanged: (date) => setState(() => period =
                          DateTimeRange(end: date, start: period.start)),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      "Branches",
                      style: theme.title.copyWith(),
                    ),
                  ),
                  CupertinoSwitch(
                    value: isAllBranch,
                    onChanged: (val) => setState(() => isAllBranch = val),
                  ),
                ],
              ),
            ),
            Expanded(
              child: AnimatedContainer(
                duration: kThemeAnimationDuration,
                child: (!isAllBranch)
                    ? ListView.builder(
                        itemCount: widget.viewModel.branches?.length ?? 0,
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.all(12),
                        itemBuilder: (con, pos) {
                          var branch = widget.viewModel.branches[pos];
                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(4.0)),
                              onTap: () =>
                                  setState(() => selectedBranch = branch),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Text(
                                        "${branch.name}",
                                        // style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    CupertinoSwitch(
                                      activeColor: Colors.grey.withOpacity(0.6),
                                      onChanged: (bool value) {
                                        if (value)
                                          setState(
                                              () => selectedBranch = branch);
                                        else
                                          setState(() => selectedBranch = null);
                                      },
                                      value: selectedBranch?.id == branch.id,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : SizedBox.expand(),
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: themeData.primaryColor,
                  borderRadius:  BorderRadius.circular(15),
                ),
                child: Material(
                  color: ThemeProvider.of(context).primaryColorDark,
                  child: InkWell(
                    borderRadius:  BorderRadius.circular(15),
                    highlightColor: Colors.transparent,
                    onTap: () {
                      if (!isAllBranch) isAllBranch = selectedBranch == null;
                      widget.viewModel.onChangeFilters(
                        reportType,
                        isAllBranch,
                        selectedBranch,
                        period,
                      );
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        'Apply',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void checkAppPosition(int index) {}
}
