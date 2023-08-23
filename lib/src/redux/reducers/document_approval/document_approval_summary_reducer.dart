import 'dart:developer';

import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_action.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_summary_actions.dart';
import 'package:redstars/src/redux/states/document_approval/document_approval_state.dart';

final documentApprSummaryReducer = combineReducers<DASummaryState>([
  TypedReducer<DASummaryState, TransactionFetchSuccessAction>(
      _pendingListReceiveAction),
  TypedReducer<DASummaryState, BranchListFetchAction>(_branchListFetchAction),
  TypedReducer<DASummaryState, LoadingAction>(_changeLoadingStatusAction),
  TypedReducer<DASummaryState, TransactionTypeSelectedAction>(_selectedOption),
  TypedReducer<DASummaryState, BranchSelectAction>(_selectedBranch),
  TypedReducer<DASummaryState, UserTypeAction>(_userType),
  TypedReducer<DASummaryState, SummaryClearAction>(_clearAction),
  TypedReducer<DASummaryState, GetNotificationCount>(
      _onNotificationCountAction),
  ///
  TypedReducer<DASummaryState, SelectBranchId>(
      _selectSpecificBranchId),
]);

DASummaryState _changeLoadingStatusAction(
    DASummaryState state, LoadingAction action) {
  bool isScreen = action.type == DocumentApprovalAction.HOME_SCREEN;
  return state.copyWith(
      loadingStatus: isScreen ? action.status : state.loadingStatus,
      loadingMessage: isScreen ? action.message : state.loadingMessage,
      loadingError: isScreen ? action.message : state.loadingError);
}

DASummaryState _onNotificationCountAction(
    DASummaryState state, GetNotificationCount action) {
  return state.copyWith(
      notificationDetails: action.notificationCountDetails,
      ///update
      loadingStatus: LoadingStatus.success,
  );
}

DASummaryState _clearAction(DASummaryState state, SummaryClearAction action) {
  return DASummaryState.initial().copyWith();
}

DASummaryState _selectedOption(
        DASummaryState state, TransactionTypeSelectedAction action) =>
    state.copyWith(
      selectedOption: action.transaction,
    );

DASummaryState _branchListFetchAction(
        DASummaryState state, BranchListFetchAction action) =>
    state.copyWith(branchList: action.branchList);

DASummaryState _pendingListReceiveAction(
    DASummaryState state, TransactionFetchSuccessAction action) {
  action.documentResponse.approvalTypes
      .forEach((element) => print(element.toString()));
  action.documentResponse.transactionTypeList
      .forEach((element) => print(element.toString()));
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      statusCode: action.statusCode,
      approvalTypeList: action.documentResponse.approvalTypes,
      transactionTypes: action.documentResponse.transactionTypeList);
}

DASummaryState _selectedBranch(
    DASummaryState state, BranchSelectAction action) {
  return state.copyWith(selectedBranch: action.selectedBranch);
}

DASummaryState _selectSpecificBranchId(
    DASummaryState state, SelectBranchId action) {
  log("branchid at reducer level is "+action.branchId.toString());
  return state.copyWith(branchId: action.branchId);
}

DASummaryState _userType(DASummaryState state, UserTypeAction action) {
  return state.copyWith(isSuperUser: action.isSuperUser);
}
