import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/actions/job_progress/job_progress_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/services/model/response/job_progress/job_progress_rpt_model.dart';

class JobProgressViewModel extends BaseViewModel {
  final LoadingStatus initialReportStatus;

  final DateTime fromDate;
  final DateTime toDate;
  final List<BCCModel> processFlows;
  final List<BranchModel> branches;

  final BCCModel selectedProcessFlow;
  final BranchModel selectedBranch;

  final bool isAllBranch;

  final List<JobProgressRptSummaryModel> summaryReport;
  final List<JobRptModel> detailReport;
  final List<JobRptModel> firstLevelReport;

  final JobRptModel selectedJob;
  final JobProgressRptSummaryModel selectedSummary;
  final List<JobRptModel> jobProgress;

  final ValueChanged<JobRptModel> onJobChange;
  final ValueChanged<JobProgressRptSummaryModel> onSummarySelected;

  final Function(BCCModel, bool, BranchModel, DateTimeRange) onChangeFilters;

  JobProgressViewModel({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    this.initialReportStatus,
    this.fromDate,
    this.toDate,
    this.branches,
    this.isAllBranch,
    this.processFlows,
    this.selectedBranch,
    this.selectedSummary,
    this.selectedProcessFlow,
    this.detailReport,
    this.summaryReport,
    this.firstLevelReport,
    this.jobProgress,
    this.selectedJob,
    this.onJobChange,
    this.onChangeFilters,
    this.onSummarySelected,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
        );

  factory JobProgressViewModel.fromStore(Store<AppState> store) {
    final state = store.state.jobProgressState;

    return JobProgressViewModel(
        loadingError: state.loadingError,
        loadingMessage: state.loadingMessage,
        loadingStatus: state.loadingStatus,
        initialReportStatus: state.initialReportStatus,
        fromDate: state.fromDate,
        toDate: state.toDate,
        branches: state.branches,
        isAllBranch: state.isAllBranch,
        selectedProcessFlow: state.selectedProcessFlow,
        selectedBranch: state.selectedBranch,
        processFlows: state.processFlows,
        detailReport: state.detailReport,
        summaryReport: state.summaryReport,
        firstLevelReport:
            state.detailReport?.where((e) => e.level == 1)?.toList() ?? [],
        selectedJob: state.selectedJob,
        selectedSummary: state.selectedSummary,
        jobProgress: state.jobProgress,
        onSummarySelected: (summary) {
          store.dispatch(getJobProgressReport(
            isAllBranch: state.isAllBranch,
            branch: state.selectedBranch,
            fromDate: state.fromDate,
            toDate: state.toDate,
            processFlow: state.selectedProcessFlow,
            summary: summary,
          ));
        },
        onJobChange: (job) {
          store.dispatch(getJobWiseProgressReport(
            job: job,
            processFlow: state.selectedProcessFlow,
            branch: state.selectedBranch,
            isAllBranch: state.isAllBranch,
          ));
        },
        onChangeFilters: (repotType, allBranch, branch, period) {
          store.dispatch(getJobProgressReport(
            isAllBranch: allBranch,
            branch: branch,
            fromDate: period.start,
            toDate: period.end,
            processFlow: state.selectedProcessFlow,
          ));
        });
  }

  List<BCCModel> getSortedReportSummary() {
    List<BCCModel> sortedProcess = processFlows;
    sortedProcess.sort((a, b) {
      if (a.id == selectedProcessFlow?.id)
        return -1;
      else if (b.id == selectedProcessFlow?.id)
        return 1;
      else
        return 0;
    });
    return sortedProcess;
  }

  List<JobRptModel> getSortedFirstLevelReport() {
    List<JobRptModel> sortedProcess = firstLevelReport;
    sortedProcess.sort((a, b) {
      if (a.id == selectedJob?.id)
        return -1;
      else if (b.id == selectedJob?.id)
        return 1;
      else
        return 0;
    });
    return sortedProcess;
  }

  onRefresh() {
    onChangeFilters(selectedProcessFlow, isAllBranch, selectedBranch,
        DateTimeRange(start: fromDate, end: toDate));
  }
}
