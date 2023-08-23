import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/transaction_unblock_request/transaction_unblock_request_action.dart';
import 'package:redstars/src/redux/states/transaction_unblock_request/transaction_unblock_request_state.dart';

final transactionUnblockReducer = combineReducers<TransUnblkReqState>([
  TypedReducer<TransUnblkReqState, LoadingAction>(
      _changeLoadingStatusAction),
  TypedReducer<TransUnblkReqState, TransactionReqHeadingActionFetch>(
      _transFetchSucces),
  TypedReducer<TransUnblkReqState, TransactionUnblockInitListAction>(
      _tranUnblkMainList),
  TypedReducer<TransUnblkReqState, BLockednotificationAction>(
      _BLockednotificationMainList),
  TypedReducer<TransUnblkReqState, UserObjectAction>(_userObj),
  TypedReducer<TransUnblkReqState, BranchObjAction>(_branchObj),
  TypedReducer<TransUnblkReqState, TransactionReqDtllListAction>(
      _transactionReqDtllListAction),
  TypedReducer<TransUnblkReqState, ActionTakenAgainstwhomAction>(
      _actionTakenAgainstwhomAction),
  TypedReducer<TransUnblkReqState, TransaunBlckReqSaveAction>(
      _transaunBlckReqSaveAction),
  TypedReducer<TransUnblkReqState, RestingLoadingAction>(
      _restingLoadingAction),
]);


TransUnblkReqState _changeLoadingStatusAction(
    TransUnblkReqState state, LoadingAction action) {
  return state.copyWith(
      loadingStatus: action.status,
      loadingMessage: action.message,
      loadingError: action.message);
}

TransUnblkReqState _transFetchSucces(
    TransUnblkReqState state, TransactionReqHeadingActionFetch action) {
//  print("tL----- ${action.documentResponse.length}");
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      transactionReqHeadingList: action.transactionReqHeadingList);
}
TransUnblkReqState _restingLoadingAction(
    TransUnblkReqState state, RestingLoadingAction action) {
  return state.copyWith(
      loading: false
  );
}
//UnblockRequestState _transListFetchSucces(
//    UnblockRequestState state, TransactionListActionFetch action) {
//  print(" ----- ${action.dtlModelList.ptDetailListModel.first.transno}");
//  return state.copyWith(
//      loadingStatus: LoadingStatus.success,
//      loadingMessage: "",
//      loadingError: "",
//      dtlModel: action.dtlModelList);
//}

TransUnblkReqState _tranUnblkMainList(
    TransUnblkReqState state, TransactionUnblockInitListAction action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      pendingList: action.pendingList);
}
TransUnblkReqState _BLockednotificationMainList(
    TransUnblkReqState state, BLockednotificationAction action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      pendingList: action.pendingList);
}
TransUnblkReqState _userObj(TransUnblkReqState state, UserObjectAction action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      userObjects: action.userObjList);
}

TransUnblkReqState _branchObj(
    TransUnblkReqState state, BranchObjAction action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      branchObjList: action.branchObjList);
}

TransUnblkReqState _transactionReqDtllListAction(
    TransUnblkReqState state, TransactionReqDtllListAction action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      pendingTransactionDetailList: action.pendingTransactionDetailList);
}

TransUnblkReqState _actionTakenAgainstwhomAction(
    TransUnblkReqState state, ActionTakenAgainstwhomAction action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      actionTakenAgainstwhomlist: action.actionTakenAgainstwhomlist);
}

TransUnblkReqState _transaunBlckReqSaveAction(
    TransUnblkReqState state, TransaunBlckReqSaveAction action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      loading: action.loading);
}
