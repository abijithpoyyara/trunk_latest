import 'package:animated_theme_switcher/animated_theme_switcher.dart';
import 'package:base/res/values/base_theme.dart';
import 'package:base/src/services/model/response/bcc_model.dart';
import 'package:base/utility.dart';
import 'package:base/widgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:redstars/resources.dart';
import 'package:redstars/src/redux/actions/job_progress/job_progress_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/viewmodels/job_progress/job_progress_viewmodel.dart';
import 'package:redstars/src/services/model/response/job_progress/job_progress_rpt_model.dart';
import 'package:redstars/src/widgets/screens/job_progress_report/partials/summary_grid_tile.dart';
import 'package:redstars/src/widgets/screens/job_progress_report/status_tracking_page.dart';
import 'package:redstars/src/widgets/screens/job_progress_report/view/filters_screen.dart';

class JobProgressDetailScreen extends StatelessWidget {
  final BCCModel process;

  const JobProgressDetailScreen({Key key, this.process}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView<AppState, JobProgressViewModel>(
      init: (store, context) {
        final state = store.state.jobProgressState;

        store.dispatch(getJobProgressReport(
          processFlow: process,
          isAllBranch: state.isAllBranch,
          toDate: state.toDate,
          fromDate: state.fromDate,
          branch: state.selectedBranch,
        ));
      },
      converter: (store) => JobProgressViewModel.fromStore(store),
      appBar: BaseAppBar(
        title: Text("${process.description}"),
      ),
      builder: (context, viewModel) => _JobProgDtlBody(viewModel: viewModel),
      onDispose: (store) => store.dispatch(JobSummaryDismissAction()),
    );
  }
}

class _JobProgDtlBody extends StatefulWidget {
  final JobProgressViewModel viewModel;

  const _JobProgDtlBody({Key key, this.viewModel}) : super(key: key);

  @override
  __JobProgDtlBodyState createState() => __JobProgDtlBodyState();
}

class __JobProgDtlBodyState extends State<_JobProgDtlBody> {
  ScrollController controller;

  @override
  void initState() {
    controller = ScrollController(
        // initialScrollOffset: widget.viewModel.selectedSummary != null
        //     ? (widget.viewModel.summaryReport?.length ?? 0) * 20.0
        //     : null,
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      floatHeaderSlivers: true,
      controller: controller,
      dragStartBehavior: DragStartBehavior.start,
      physics: BouncingScrollPhysics(),
      headerSliverBuilder: (context, overlap) {
        return [
          SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 2,
                mainAxisSpacing: 2,
                childAspectRatio: .95,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, position) {
                  var summary = widget.viewModel.summaryReport[position];

                  return SummaryGridTile(
                      position: position,
                      primaryTitle: "${summary.description} ",
                      count: summary.value,
                      isPercentage: summary.isPercentage,
                      primaryIcon: Icons.view_agenda,
                      isSelected:
                          widget.viewModel?.selectedSummary?.dataIndex ==
                              summary.dataIndex,
                      onClick: () {
                        widget.viewModel.onSummarySelected(summary);
                      });
                },
                addAutomaticKeepAlives: true,
                childCount: widget.viewModel.summaryReport.length,
              ))
        ];
      },
      body: Stack(
        fit: StackFit.expand,
        children: [
          if (widget.viewModel.firstLevelReport?.isNotEmpty ?? false)
            Container(
              //margin: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Expanded(
                    child: Container(
                        margin: EdgeInsets.only(top: 8, left: 4, right: 1),
                        padding:
                            EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                        decoration: BoxDecoration(
                          color:ThemeProvider.of(context).primaryColor,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black12,
                                blurRadius: 5,
                                offset: Offset(-1, -1))
                          ],
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(22),
                            topRight: Radius.circular(22),
                          ),
                        ),

                        // color: Colors.grey.withOpacity(.4),
                        child: ListView.builder(
                            padding:
                                EdgeInsets.only(top: 14, left: 8, right: 8),
                            shrinkWrap: true,
                            itemCount:
                                widget.viewModel.firstLevelReport?.length ?? 0,
                            itemBuilder: (context, pos) {
                              var particular =
                                  widget.viewModel.firstLevelReport[pos];

                              return SalesEnquiryListItem(
                                report: particular,
                                onClick: () {
                                  BaseNavigate(
                                      context,
                                      JobDetailProgressScreen(
                                          report: particular,
                                          process: widget
                                              .viewModel.selectedProcessFlow));
                                },
                              );
                            })),
                  ),
                ],
              ),
            )
          else
            Expanded(
              child: EmptyResultView(
                icon: Icons.check_circle_outline,
                message:
                    "No Process created in ${BaseDates(widget.viewModel.fromDate).format} -${BaseDates(widget.viewModel.toDate).format}",
                onRefresh: () => widget.viewModel.onRefresh(),
              ),
            ),
          Positioned(
            child: FloatingActionButton(
              child: Icon(Icons.sort),
              onPressed: () {
                FocusScope.of(context).requestFocus(FocusNode());
                Navigator.push<dynamic>(
                  context,
                  MaterialPageRoute<dynamic>(
                      builder: (BuildContext context) =>
                          FiltersScreen(viewModel: widget.viewModel),
                      fullscreenDialog: false),
                );
              },
            ),
            right: 8,
            bottom: 8,
          )
        ],
      ),
    );
  }
}

class SalesEnquiryListItem extends StatelessWidget {
  final JobRptModel report;

  final Function() onClick;

  const SalesEnquiryListItem({
    Key key,
    this.report,
    this.onClick,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    BaseTheme theme = BaseTheme.of(context);
    BaseColors colors = BaseColors.of(context);
    ThemeData themeData = ThemeProvider.of(context);

    DateTime enquiryDate = DateTime.now();
    // DateTime enquiryDate = DateTime.tryParse(enquiryItem?.datetime ?? "");
    return Container(
        decoration: BoxDecoration(
            color: themeData.primaryColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: themeData.primaryColorDark)),
        margin: EdgeInsets.symmetric(vertical: 4),
        child: InkWell(
            onTap: onClick,
            child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 6,
                            backgroundColor: report.colorCode == 19
                                ? Colors.green
                                : Colors.red,
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              (report?.refoptionname?.removeAllHtmlTags() ?? "")
                                  .toUpperCase(),
                              style: theme.bodyBold.copyWith(),
                            ),
                          ),
                          SizedBox(width: 4),
                        ],
                      ),
                      SizedBox(height: 6),
                      if (report.approvaltime.isNotEmpty)
                        Text(
                          ("Estimated ${report.approvaltime}"),
                          style: theme.body2MediumHint.copyWith(color: themeData.primaryColorDark),
                        ),
                      Divider(thickness: 1, color: colors.dividerColor),
                      Row(children: [
                        Expanded(
                            flex: 10,
                            child: Text(report?.timetaken ?? "",
                                style: theme.body2Medium
                                    .copyWith(color: colors.infoColor))),
                        if (enquiryDate != null)
                          Expanded(
                              flex: 7,
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(report?.status ?? "",
                                      style: theme.body2MediumHint.copyWith(color: Colors.white))))
                      ])
                    ]))));
  }
}
