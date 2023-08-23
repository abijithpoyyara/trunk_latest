import 'dart:developer';

import 'package:base/redux.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/actions/transaction_unblock_request_approval/transaction_unblock_request_approval_action.dart';
import 'package:redstars/src/redux/states/transaction_unblock_request_approval/transaction_unblock_request_approval_state.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/model/transaction_save_model.dart';

final transactionUnblockRequestApprovalReducer =
    combineReducers<TransactionUnblockReqApprlState>([
  TypedReducer<TransactionUnblockReqApprlState, LoadingAction>(
      _lodingStatusAction),
  TypedReducer<TransactionUnblockReqApprlState, TransactionApprovalReqDetails>(
      _transactionApprovalDetls),
  TypedReducer<TransactionUnblockReqApprlState, TransactionApprovalHeadindDtl>(
      _transactionHeadDetls),
  TypedReducer<TransactionUnblockReqApprlState, TransactionApprovalList>(
      _transactionApprovalList),
  TypedReducer<TransactionUnblockReqApprlState, SavingPaymentFilterAction>(
      _filterSaveAction),
  TypedReducer<TransactionUnblockReqApprlState, TransaunBlckReqApprSaveAction>(
      _saveTransactionUnblockRequestApproval),
  TypedReducer<TransactionUnblockReqApprlState, TransaunBlckReqApprSaveFromNotificationAction>(
      _saveTransactionUnblockRequestApprovalFromNotification),
  TypedReducer<TransactionUnblockReqApprlState, ApprovalTypeAction>(
      _ACtiontypeSaveAction),
  TypedReducer<TransactionUnblockReqApprlState, BranchObjAction>(_branchObj),
  TypedReducer<TransactionUnblockReqApprlState, FetchHistoryData>(_historyData),
  TypedReducer<TransactionUnblockReqApprlState, GetNotificationCount>(
      _notificationCount),
  TypedReducer<TransactionUnblockReqApprlState, GetUnreadNotificationList>(
      _getUnreadNotificationList),
  TypedReducer<TransactionUnblockReqApprlState, TransactionSaveModelAction>(
      _saveTransAction),
  TypedReducer<TransactionUnblockReqApprlState, TransactionReqApplClearAction>(
      _onClearAction),
      TypedReducer<TransactionUnblockReqApprlState, clearFilterAction>(
          _clearFilterAction),

      TypedReducer<TransactionUnblockReqApprlState, ClearTURPScreen>(
          _clearScreen),

      TypedReducer<TransactionUnblockReqApprlState, ChangeBranchId>(
          _changeBranchId),




  TypedReducer<TransactionUnblockReqApprlState,
          TransactionUnblockApprovalNotificationClickAction>(
      _onClickNotificationAction),
      ///update
      TypedReducer<TransactionUnblockReqApprlState,
          TransactionUnblockRequestApprovalFailureAction>(
          _transactionUnblockRequestApproveFailure),
]);

TransactionUnblockReqApprlState _lodingStatusAction(
    TransactionUnblockReqApprlState state, LoadingAction action) {
  return state.copyWith(
      loadingMessage: action.message,
      loadingError: action.message,
      loadingStatus: action.status);
}

TransactionUnblockReqApprlState _notificationCount(
    TransactionUnblockReqApprlState state, GetNotificationCount action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    notificationDetails: action.notificationCountDetails,
  );
}

TransactionUnblockReqApprlState _getUnreadNotificationList(
    TransactionUnblockReqApprlState state, GetUnreadNotificationList action) {
  return state.copyWith(
    unreadList: action.unreadList,
  );
}

TransactionUnblockReqApprlState _clearFilterAction(
    TransactionUnblockReqApprlState state, clearFilterAction action) {
  return state.copyWith(
     model: TransactionUnblockReqApprlState.initial().model,


  );
}
TransactionUnblockReqApprlState _clearScreen(
    TransactionUnblockReqApprlState state, ClearTURPScreen action) {
  return TransactionUnblockReqApprlState.initial();
}

TransactionUnblockReqApprlState _changeBranchId(
    TransactionUnblockReqApprlState state, ChangeBranchId action) {
  log("reducer model level all branch count ${action.isAllBranchSelected}");
  log("reducer model level all branchid ${action.branch}");
  log("reducer model level all branchname ${action.branchName}");
  return state.copyWith(
     branch: action.branch,isAllBranchSelected: action.isAllBranchSelected,branchName: action.branchName);
}





TransactionUnblockReqApprlState _historyData(
    TransactionUnblockReqApprlState state, FetchHistoryData action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    historyData: action.historyModel,
  );
}

TransactionUnblockReqApprlState _branchObj(
    TransactionUnblockReqApprlState state, BranchObjAction action) {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    branchObjList: action.branchObjList,
  );
}

TransactionUnblockReqApprlState _transactionApprovalDetls(
    TransactionUnblockReqApprlState state,
    TransactionApprovalReqDetails action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      tranansctionScreenDtl: action.transactionScreenDtl,
      statusCode: action.statusCode);
}

TransactionUnblockReqApprlState _saveTransactionUnblockRequestApproval(
    TransactionUnblockReqApprlState state,
    TransaunBlckReqApprSaveAction action) {
  return state.copyWith(
    isTransReqAppvl: action.isTransReqAppvl,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}
TransactionUnblockReqApprlState _saveTransactionUnblockRequestApprovalFromNotification(
    TransactionUnblockReqApprlState state,
    TransaunBlckReqApprSaveFromNotificationAction action) {
  return state.copyWith(
    isTransReqAppvlNotification: action.isTransReqAppvlNotification,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

// TransactionUnblockReqApprlState _onClearAction(
//     TransactionUnblockReqApprlState state,
//     TransactionReqApplClearAction action) {
//   return TransactionUnblockReqApprlState.initial().copyWith(
//       actionTypes: state.actionTypes,
//       tranansctionScreenHeadingList: state.tranansctionScreenHeadingList,
//       transactionApprovalListview: state.transactionApprovalListview,
//     isTransReqAppvl: action.isTransReqAppvl,
//
//       tranansctionScreenDtl: state.tranansctionScreenDtl,
//       notificationDetails: state.notificationDetails,
//       branchObjList: state.branchObjList,
//
//
//   );
// }

TransactionUnblockReqApprlState _onClearAction(
    TransactionUnblockReqApprlState state,
    TransactionReqApplClearAction action) {
  return state.copyWith(
    isTransReqAppvl: action.isTransReqAppvl,
    isTransReqAppvlNotification: false,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

TransactionUnblockReqApprlState _transactionHeadDetls(
    TransactionUnblockReqApprlState state,
    TransactionApprovalHeadindDtl action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      tranansctionScreenHeadingList: action.transactionApprovalHeadindDtl);
}

TransactionUnblockReqApprlState _transactionApprovalList(
    TransactionUnblockReqApprlState state, TransactionApprovalList action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      transactionApprovalListview: action.transactionReqApprovallis);
}

TransactionUnblockReqApprlState _filterSaveAction(
    TransactionUnblockReqApprlState state, SavingPaymentFilterAction action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      model: action.filterModel);
}

TransactionUnblockReqApprlState _saveTransAction(
    TransactionUnblockReqApprlState state, TransactionSaveModelAction action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      approvalSaveModel: action.saveModel);
}

TransactionUnblockReqApprlState _onClickNotificationAction(
    TransactionUnblockReqApprlState state,
    TransactionUnblockApprovalNotificationClickAction action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      notificationModel: action.notificationModel);
}

TransactionUnblockReqApprlState _ACtiontypeSaveAction(
    TransactionUnblockReqApprlState state, ApprovalTypeAction action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      actionTypes: action.ActionType);
}

TransactionUnblockReqApprlState _transactionUnblockRequestApproveFailure(TransactionUnblockReqApprlState state,TransactionUnblockRequestApprovalFailureAction action){
  return state.copyWith(
    message: action.message,
    transactionUnblockRequestApprovalFailure:  action.TURequestApprovalFailure,
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
  );
}
