import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/job_progress/job_progress_rpt_model.dart';
import 'package:redstars/src/services/repository/job_progress/job_progress_repository.dart';

class OptionConfigurationFetchedAction {
  List<BCCModel> processFlows;
  List<BranchModel> branches;

  OptionConfigurationFetchedAction(
    this.processFlows,
    this.branches,
  );
}

class ReportFetchedAction {
  final List<JobRptModel> detailReport;
  final List<JobProgressRptSummaryModel> summaryReport;
  final DateTime fromDate;
  final DateTime toDate;
  final BCCModel processFlow;
  final bool isAllBranch;
  final BranchModel branch;
  final JobProgressRptSummaryModel summary;

  ReportFetchedAction({
    this.detailReport,
    this.summaryReport,
    this.fromDate,
    this.toDate,
    this.processFlow,
    this.isAllBranch,
    this.branch,
    this.summary,
  });
}

class ProgressReportFetchedAction {
  final List<JobRptModel> detailReport;
  final bool isAllBranch;
  final BranchModel branch;
  final BCCModel processFlow;
  final JobRptModel job;

  ProgressReportFetchedAction({
    this.detailReport,
    this.isAllBranch,
    this.branch,
    this.processFlow,
    this.job,
  });
}

class JobSummaryDismissAction {}

ThunkAction getJobProgressConfigs() {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
        status: LoadingStatus.loading,
        message: "Initializing Option",
        type: "JobProgress",
      ));

      JobProgressRepository().getInitialConfigs(
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
                type: "JobProgress",
              )),
          onRequestSuccess: ({
            List<BCCModel> processFlows,
            List<BranchModel> branches,
          }) {
            store.dispatch(OptionConfigurationFetchedAction(
              processFlows,
              branches,
            ));
          });
    });
  };
}

ThunkAction getJobProgressReport({
  DateTime fromDate,
  DateTime toDate,
  BCCModel processFlow,
  bool isAllBranch = false,
  BranchModel branch,
  bool isInitialFetch = false,
  JobProgressRptSummaryModel summary,
}) {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Report",
        type: isInitialFetch ? "JobProgressReport" : "JobProgress",
      ));

      JobProgressRepository().getReport(
          allBranch: isAllBranch,
          fromDate: fromDate,
          toDate: toDate,
          processFlowId: processFlow.id,
          branch: branch,
          filterFlag: summary?.dataIndex,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
                type: "JobProgress",
              )),
          onRequestSuccess: (summaryReport, detailReport) {
            store.dispatch(ReportFetchedAction(
              detailReport: detailReport,
              summaryReport: summaryReport,
              isAllBranch: isAllBranch,
              branch: branch,
              fromDate: fromDate,
              toDate: toDate,
              processFlow: processFlow,
              summary: summary,
            ));
          });
    });
  };
}

ThunkAction getJobWiseProgressReport({
  BCCModel processFlow,
  bool isAllBranch = false,
  BranchModel branch,
  JobRptModel job,
}) {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Report",
        type: "JobProgress",
      ));

      JobProgressRepository().getReportProgress(
          allBranch: isAllBranch,
          processFlowId: processFlow.id,
          branch: branch,
          transNo: job.transNo,
          transTableId: job.transTableId,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
                type: "JobProgress",
              )),
          onRequestSuccess: (detailReport) {
            store.dispatch(ProgressReportFetchedAction(
              detailReport: detailReport,
              isAllBranch: isAllBranch,
              branch: branch,
              processFlow: processFlow,
              job: job,
            ));
          });
    });
  };
}
