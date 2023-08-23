import 'package:base/redux.dart';
import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/sales_insight/customer_analysis_action.dart';
import 'package:redstars/src/redux/actions/sales_insight/sales_insight_action.dart';
import 'package:redstars/src/redux/states/sale_insight/sales_insight_customer.dart';
import 'package:base/redux.dart';

final salesInsightCustomerReducer = combineReducers<SalesInsightCustomerState>([
  TypedReducer<SalesInsightCustomerState, LoadingAction>(_changeLoadingStatus),
  TypedReducer<SalesInsightCustomerState, CustomerBranchFetchSuccessAction>(
      _branchesFetchSuccess),
  TypedReducer<SalesInsightCustomerState, CustomerEngagementFetchSuccessAction>(
      _engagementFetch),
  TypedReducer<SalesInsightCustomerState, MarginAnalysisFetchSuccessAction>(
      _marginAnalysisFetch),
  TypedReducer<SalesInsightCustomerState, ChangeFilterAction>(
      _changeFilterAction),
]);

SalesInsightCustomerState _branchesFetchSuccess(
    SalesInsightCustomerState state, CustomerBranchFetchSuccessAction action) {
  return state.copyWith(
      branchAnalysis: action.branches,
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "");
}

SalesInsightCustomerState _engagementFetch(SalesInsightCustomerState state,
    CustomerEngagementFetchSuccessAction action) {
  return state.copyWith(
      totalCustomers: action.customerEngagement.totalCustomers,
      repeatCustomers: action.customerEngagement.repeat,
      onceCustomers: action.customerEngagement.once,
      repeatPercent: action.customerEngagement.repeatPerc,
      oncePercent: action.customerEngagement.oncePerc,
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "");
}

SalesInsightCustomerState _marginAnalysisFetch(
    SalesInsightCustomerState state, MarginAnalysisFetchSuccessAction action) {
  return state.copyWith(
      marginAnalysis: action.marginList,
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "");
}

SalesInsightCustomerState _changeLoadingStatus(
        SalesInsightCustomerState state, LoadingAction action) =>
    state.copyWith(
        loadingStatus: action.status,
        loadingMessage: action.message,
        loadingError: action.message);

SalesInsightCustomerState _changeFilterAction(
        SalesInsightCustomerState state, ChangeFilterAction action) =>
    state.copyWith(
        fromDate: action.fromDate,
        toDate: action.toDate,
        major: action.major,
        margin: action.margin);
