import 'package:base/redux.dart';
import 'package:base/utility.dart';
import 'package:redstars/src/redux/actions/sales_enquiry_mis/sale_enquiry_mis_action.dart';
import 'package:redstars/src/redux/states/sale_enquiry_mis/se_mis_state.dart';

final seMISReducer = combineReducers<SalesEnquiryMisState>([
  TypedReducer<SalesEnquiryMisState, LoadingAction>(_changeLoadingStatusAction),
  TypedReducer<SalesEnquiryMisState, OnClearAction>(_clearAction),
  TypedReducer<SalesEnquiryMisState, OptionConfigurationFetchedAction>(
      _onConfigAction),
  TypedReducer<SalesEnquiryMisState, FinYearMonthFetchedAction>(
      _onMonthsFetchedAction),
  TypedReducer<SalesEnquiryMisState, SEMISSummaryFetchedAction>(
      _onSummaryFetchdAction),
  TypedReducer<SalesEnquiryMisState, SEMISDtlFetchedAction>(_onDtlFetchdAction),
  TypedReducer<SalesEnquiryMisState, OnParticularSelectedAction>(
      _onParticularSelectedAction),
  TypedReducer<SalesEnquiryMisState, OnParticularBranchSelectedAction>(
      _onBranchSelectedAction),
  TypedReducer<SalesEnquiryMisState, CollapseItemSummaryAction>(
      _onCollapseItemSummaryAction),
]);

SalesEnquiryMisState _changeLoadingStatusAction(
    SalesEnquiryMisState state, LoadingAction action) {
  bool isScreen = action.type == "SaleEnquiryMis";
  bool isInitial = action.type == "SaleEnquiryMISReport";
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

SalesEnquiryMisState _clearAction(
    SalesEnquiryMisState state, OnClearAction action) {
  return SalesEnquiryMisState.initial().copyWith();
}

SalesEnquiryMisState _onConfigAction(
    SalesEnquiryMisState state, OptionConfigurationFetchedAction action) {
  action.finYears.forEach((element) {
    print(element);
  });
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingError: "",
    loadingMessage: "",
    branches: action.branches,
    isAllBranch: true,
    asOnDate: DateTime.now(),
    finYears: action.finYears,
    // selectedFinYear: action.finYears?.first,
    reportType: action.reportType,
    selectedReport: action.reportType?.first,
  );
}

SalesEnquiryMisState _onSummaryFetchdAction(
    SalesEnquiryMisState state, SEMISSummaryFetchedAction action) {
  return state.copyWith(
    initialReportStatus: LoadingStatus.success,
    onSummaryFetch: true,
    selectedMonth: action.selectedMonth,
    selectedTab: action.selectedTab,
    loadingMessage: "",
    loadingError: "",
    loadingStatus: LoadingStatus.success,
    selectedBranch: action.branch,
    isAllBranch: action.isAllBranch,
    selectedReport: state.reportType.firstWhere(
        (element) => element.id == action.reportType,
        orElse: () => null),
    fromDate: action.fromDate,
    toDate: action.toDate,
    summaryReport: action.summaryReport,
    detailsReport: [],
    selectedParticularBranch: null,
    selectedSummaryItem: null,
    selectedParticular: null,
  );
}

SalesEnquiryMisState _onMonthsFetchedAction(
    SalesEnquiryMisState state, FinYearMonthFetchedAction action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingError: "",
      loadingMessage: "",
      selectedTab: action.selectedTab,
      calenderMonths: action.months,
      selectedFinYear: action.finYear);
}

SalesEnquiryMisState _onDtlFetchdAction(
    SalesEnquiryMisState state, SEMISDtlFetchedAction action) {
  return state.copyWith(
      loadingMessage: "",
      loadingError: "",
      loadingStatus: LoadingStatus.success,
      detailsReport: action.dtlReport,
      selectedSummaryItem: action.summaryItem);
}

SalesEnquiryMisState _onParticularSelectedAction(
    SalesEnquiryMisState state, OnParticularSelectedAction action) {
  return state.copyWith(selectedParticular: action.particular);
}

SalesEnquiryMisState _onBranchSelectedAction(
    SalesEnquiryMisState state, OnParticularBranchSelectedAction action) {
  return state.copyWith(selectedParticularBranch: action.branch);
}

SalesEnquiryMisState _onCollapseItemSummaryAction(
    SalesEnquiryMisState state, CollapseItemSummaryAction action) {
  return state.copyWith(
    onSummaryFetch: true,
    // summaryReport: [],
    detailsReport: [],
    selectedSummaryItem: null,
  );
}
