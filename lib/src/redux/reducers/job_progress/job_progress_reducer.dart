import 'package:base/redux.dart';
import 'package:base/utility.dart';
import 'package:redstars/src/redux/actions/job_progress/job_progress_action.dart';
import 'package:redstars/src/redux/states/job_progress/job_progress_state.dart';

final jobProgressReducer = combineReducers<JobProgressState>([
  TypedReducer<JobProgressState, LoadingAction>(_changeLoadingStatusAction),
  TypedReducer<JobProgressState, OnClearAction>(_clearAction),
  TypedReducer<JobProgressState, OptionConfigurationFetchedAction>(
      _onConfigAction),
  TypedReducer<JobProgressState, ReportFetchedAction>(_reportFetchedAction),
  TypedReducer<JobProgressState, ProgressReportFetchedAction>(
      _progressFetchedAction),
  TypedReducer<JobProgressState, JobSummaryDismissAction>(
      _summaryDismissAction),
]);

JobProgressState _changeLoadingStatusAction(
    JobProgressState state, LoadingAction action) {
  bool isScreen = action.type == "JobProgress";
  bool isInitial = action.type == "JobProgressReport";
  if (isScreen)
    return state.copyWith(
      loadingStatus: action.status,
      loadingMessage: action.message,
      loadingError: action.message,
      // initialReportStatus: action.status,
    );
  if (isInitial)
    return state.copyWith(
      loadingStatus: action.status.hasError() ? action.status : null,
      loadingMessage: action.message,
      loadingError: action.message,
      initialReportStatus: action.status,
    );
  else
    return state;
}

JobProgressState _clearAction(JobProgressState state, OnClearAction action) {
  return JobProgressState.initial().copyWith();
}

JobProgressState _onConfigAction(
    JobProgressState state, OptionConfigurationFetchedAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingError: "",
    loadingMessage: "",
    branches: action.branches,
    isAllBranch: true,
    processFlows: action.processFlows,
  );
}

JobProgressState _reportFetchedAction(
    JobProgressState state, ReportFetchedAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingError: "",
    loadingMessage: "",
    selectedProcessFlow: action.processFlow,
    fromDate: action.fromDate,
    toDate: action.toDate,
    isAllBranch: action.isAllBranch,
    selectedBranch: action.branch,
    summaryReport: action.summaryReport,
    detailReport: action.detailReport,
    selectedSummary: action.summary,
  );
}

JobProgressState _summaryDismissAction(
    JobProgressState state, JobSummaryDismissAction action) {
  return state.copyWith(
    isClearAction: true,
  );
}

JobProgressState _progressFetchedAction(
    JobProgressState state, ProgressReportFetchedAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingError: "",
    loadingMessage: "",
    selectedProcessFlow: action.processFlow,
    isAllBranch: action.isAllBranch,
    selectedBranch: action.branch,
    selectedJob: action.job,
    jobProgress: action.detailReport,
  );
}
