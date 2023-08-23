import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_action.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_history_action.dart';
import 'package:redstars/src/redux/states/document_approval/document_approval_state.dart';

final documentApprHistoryReducer = combineReducers<DAHistoryState>([
  TypedReducer<DAHistoryState, LoadingAction>(_changeLoadingStatusAction),
  TypedReducer<DAHistoryState, ListHistoryFetchSuccessAction>(
      _historiesListReceiveAction),
  TypedReducer<DAHistoryState, ListApprovalsFetchSuccessAction>(
      _approvalsListReceiveAction),
  TypedReducer<DAHistoryState, TransactionStatusSuccessAction>(
      _transactionStatusAction),
]);

DAHistoryState _changeLoadingStatusAction(
        DAHistoryState state, LoadingAction action){
  bool isScreen = action.type == DocumentApprovalAction.RELATION_SCREEN;
  return state.copyWith(
      loadingStatus: isScreen ? action.status : state.loadingStatus,
      loadingMessage: isScreen ? action.message : state.loadingMessage,
      loadingError: isScreen ? action.message : state.loadingError);
}

DAHistoryState _historiesListReceiveAction(
        DAHistoryState state, ListHistoryFetchSuccessAction action) =>
    state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        transactionHistories: action.transactionHistoryList);

DAHistoryState _approvalsListReceiveAction(
        DAHistoryState state, ListApprovalsFetchSuccessAction action) =>
    state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        transactionApprovals: action.transactionApprovalList);

DAHistoryState _transactionStatusAction(
        DAHistoryState state, TransactionStatusSuccessAction action) =>
    state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        transactionStatus: action.transactionMap);
