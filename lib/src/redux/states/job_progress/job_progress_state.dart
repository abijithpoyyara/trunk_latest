import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/job_progress/job_progress_rpt_model.dart';

@immutable
class JobProgressState extends BaseState {
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
  final JobProgressRptSummaryModel selectedSummary;
  final JobRptModel selectedJob;
  final List<JobRptModel> jobProgress;

  JobProgressState({
    this.fromDate,
    this.toDate,
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    this.branches,
    this.isAllBranch,
    this.processFlows,
    this.selectedBranch,
    this.selectedProcessFlow,
    this.initialReportStatus,
    this.summaryReport,
    this.detailReport,
    this.selectedJob,
    this.jobProgress,
    this.selectedSummary,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
        );

  JobProgressState copyWith({
    LoadingStatus loadingStatus,
    LoadingStatus initialReportStatus,
    String loadingMessage,
    String loadingError,
    DateTime fromDate,
    DateTime toDate,
    List<BranchModel> branches,
    bool isAllBranch,
    BCCModel selectedProcessFlow,
    BranchModel selectedBranch,
    List<BCCModel> processFlows,
    List<JobProgressRptSummaryModel> summaryReport,
    List<JobRptModel> detailReport,
    JobRptModel selectedJob,
    List<JobRptModel> jobProgress,
    JobProgressRptSummaryModel selectedSummary,
    bool isClearAction = false,
  }) {
    return JobProgressState(
      initialReportStatus: initialReportStatus ?? this.initialReportStatus,
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      loadingError: loadingError ?? this.loadingError,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      branches: branches ?? this.branches,
      isAllBranch: isAllBranch ?? this.isAllBranch,
      processFlows: processFlows ?? this.processFlows,
      selectedBranch: selectedBranch ?? this.selectedBranch,
      selectedProcessFlow: isClearAction
          ? selectedProcessFlow
          : selectedProcessFlow ?? this.selectedProcessFlow,
      summaryReport:
          isClearAction ? summaryReport : summaryReport ?? this.summaryReport,
      detailReport:
          isClearAction ? detailReport : detailReport ?? this.detailReport,
      selectedJob:
          isClearAction ? selectedJob : selectedJob ?? this.selectedJob,
      jobProgress:
          isClearAction ? jobProgress : jobProgress ?? this.jobProgress,
      selectedSummary: isClearAction
          ? selectedSummary
          : selectedSummary ?? this.selectedSummary,
    );
  }

  factory JobProgressState.initial() {
    return JobProgressState(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      initialReportStatus: LoadingStatus.success,
      fromDate: DateTime(DateTime.now().year, 1),
      toDate: DateTime.now(),
      processFlows: [],
      isAllBranch: true,
      branches: [],
      selectedBranch: null,
      selectedProcessFlow: null,
      summaryReport: [],
      detailReport: [],
      jobProgress: [],
      selectedJob: null,
      selectedSummary: null,
    );
  }
}
