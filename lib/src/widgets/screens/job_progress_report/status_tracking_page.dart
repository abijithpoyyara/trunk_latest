import 'dart:ui';

import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/src/services/model/response/bcc_model.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/job_progress/job_progress_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/job_progress/job_progress_viewmodel.dart';
import 'package:redstars/src/services/model/response/job_progress/job_progress_rpt_model.dart';

class JobDetailProgressScreen extends StatelessWidget {
  final JobRptModel report;
  final BCCModel process;

  const JobDetailProgressScreen({
    Key key,
    this.report,
    this.process,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AppState, JobProgressViewModel>(
        init: (store, context) {
          final state = store.state.jobProgressState;
          store.dispatch(getJobWiseProgressReport(
            job: report,
            processFlow: state.selectedProcessFlow,
            branch: state.selectedBranch,
            isAllBranch: state.isAllBranch,
          ));
        },
        converter: (store) => JobProgressViewModel.fromStore(store),
        appBar: BaseAppBar(
          title: Text("${process.description}"),
        ),
        builder: (context, viewModel) {
          return Container(
            color: Colors.black12,
            child: Column(
              children: [
                ProcessHorizontalList(viewModel: viewModel),
                Expanded(
                  child: Container(
                    color: ThemeProvider.of(context).primaryColor,
                    child: CupertinoScrollbar(
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.all(8),
                          shrinkWrap: true,
                          itemCount: viewModel.jobProgress?.length ?? 0,
                          itemBuilder: (context, pos) {
                            var particular = viewModel.jobProgress[pos];

                            return _EnquiryStatusListWidget(report: particular);
                          }),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class ProcessHorizontalList extends StatefulWidget {
  final JobProgressViewModel viewModel;

  const ProcessHorizontalList({Key key, this.viewModel}) : super(key: key);

  @override
  _ProcessHorizontalListState createState() => _ProcessHorizontalListState();
}

class _ProcessHorizontalListState extends State<ProcessHorizontalList> {
  ScrollController _controller;

  @override
  void initState() {
    _controller = ScrollController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      scrollDirection: Axis.horizontal,
      child: IntrinsicWidth(
        child: Row(
            children: widget.viewModel
                .getSortedFirstLevelReport()
                .map((e) => _buildHeaderWidget(
                      selected: e.id == widget.viewModel.selectedJob?.id,
                      report: e,
                      onTap: () {
                        widget.viewModel.onJobChange(e);
                        _controller.animateTo(
                          0,
                          duration: Duration(
                            milliseconds: _controller.offset.floor(),
                          ),
                          curve: Curves.bounceIn,
                        );
                      },
                    ))
                .toList()),
      ),
    );
  }

  Widget _buildHeaderWidget({
    bool selected = false,
    VoidCallback onTap,
    JobRptModel report,
  }) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: selected ? null : onTap,
        borderRadius: BorderRadius.circular(22),
        child: Container(
          height: 48,
          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 21),
          margin: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
              color: selected ? ThemeProvider.of(context).primaryColor : Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(15)),
              boxShadow: [
                if (selected)
                  BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.3),
                      offset: Offset(0, 12),
                      blurRadius: 20)
              ]),
          child: DefaultTextStyle(
            style: BaseTheme.of(context)
                .subhead1Semi
                // .subtitle1
                .copyWith(color: selected ? Colors.white : ThemeProvider.of(context).primaryColorDark),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    !selected ? Icons.circle : Icons.check_circle_outline,
                    color: selected ? Colors.white : null,
                  ),
                  SizedBox(width: 12.5),
                  Text("${report.refoptionname.removeAllHtmlTags()}")
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _EnquiryStatusListWidget extends StatelessWidget {
  final JobRptModel report;

  const _EnquiryStatusListWidget({
    Key key,
    this.report,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    BaseColors baseColor = BaseColors.of(context);

    DateTime startDate = DateTime.now();
    DateTime endDate = DateTime.now();

    if (report.isLeaf ?? false) {
      String date = report.startdate ?? report.enddate;
      String startDate = date?.substring(0, 10) ?? "";
      String startTime = date?.substring(11) ?? "";

      return Container(
          margin: EdgeInsets.only(left: 10, bottom: 8),
          child: IntrinsicHeight(
            child: Row(children: [
              Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text(startDate,
                    style: theme.bodyHint.copyWith(color: Colors.black)),
                SizedBox(height: 4),
                Text("$startTime",
                    style: theme.bodyHint.copyWith(color: Colors.black)),
              ]),
              SizedBox(width: 10),
              VerticalDivider(color: baseColor.dark, thickness: 1),
              SizedBox(width: 20),
              Expanded(
                  child: Container(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    Text(
                        "${BaseStringCase(report.refoptionname.removeAllHtmlTags()).sentenceCase}",
                        style: theme.body.copyWith()),
                    SizedBox(height: 4),
                    Text(
                        BaseStringCase(
                                "by ${report.name ?? " "} ${report.timetaken.isNotEmpty ? 'in ${report.timetaken}' : ""}")
                            .sentenceCase,
                        style: theme.body2),
                    SizedBox(height: 8),
                  ])))
            ]),
          ));
    }

    if (report.isHeader ?? false)
      return Container(
          margin: EdgeInsets.only(left: 4, top: 8),
          child: IntrinsicHeight(
              child: Container(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                Text("${report.refoptionname.removeAllHtmlTags()}",
                    style: theme.subhead1Semi.copyWith(
                      color: Colors.black,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                            blurRadius: 2,
                            offset: Offset(0, 2),
                            color: Colors.black38)
                      ],
                    )),
                SizedBox(height: 12),
              ]))));
    return Container(
        margin: EdgeInsets.only(left: 4, top: 8),
        child: IntrinsicHeight(
            child: Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
              Text("${report.refoptionname.removeAllHtmlTags()}",
                  style: theme.body2Medium.copyWith()),
              SizedBox(height: 12),
            ]))));
  }
}
