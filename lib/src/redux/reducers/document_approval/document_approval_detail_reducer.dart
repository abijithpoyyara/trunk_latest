import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_action.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_detail_action.dart';
import 'package:redstars/src/redux/states/document_approval/document_approval_state.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_approvals.dart';

final documentApprDetailReducer = combineReducers<DADetailState>([
  TypedReducer<DADetailState, LoadingAction>(_changeLoadingStatusAction),
  TypedReducer<DADetailState, AddTrans>(_addTrans),
  TypedReducer<DADetailState, RemoveTrans>(_removeTrans),
  TypedReducer<DADetailState, AddTransList>(_addTransList),
  TypedReducer<DADetailState, PendingListFetchSuccessAction>(
      _inputListReceiveAction),
  TypedReducer<DADetailState, TransactionDetailsFetchSuccessAction>(
      _transactionDtl),
  TypedReducer<DADetailState, TransactionTypeSelectedAction>(_selectedOption),
  TypedReducer<DADetailState, OnUpdateSuccessAction>(_updateState),
  TypedReducer<DADetailState, DocumentSubmissionSuccessAction>(
      _saveSuccessAction),
  TypedReducer<DADetailState, MultiDocumentSubmissionSuccessAction>(
      _multiSaveSuccessAction),
  TypedReducer<DADetailState, GetUnreadNotificationList>(_getUnreadList),
  TypedReducer<DADetailState, ClearStateAction>(_clearStateAction),
  TypedReducer<DADetailState, OnDispose>(_onDispose),
  TypedReducer<DADetailState, OnDisposeDetails>(_onDisposeDetails),
  // TypedReducer<DADetailState, SelectAll>(_selectAll),

  TypedReducer<DADetailState, DocumentApproveFailureAction>(_documentApproveFailure),
]);

DADetailState _changeLoadingStatusAction(
    DADetailState state, LoadingAction action) {
  bool isScreen = action.type == DocumentApprovalAction.DETAIL_SCREEN;
  return state.copyWith(
      loadingStatus: isScreen ? action.status : state.loadingStatus,
      loadingMessage: isScreen ? action.message : state.loadingMessage,
      loadingError: isScreen ? action.message : state.loadingError);
}
///update

DADetailState _documentApproveFailure(DADetailState state,DocumentApproveFailureAction action){
  return state.copyWith(
      message: action.message,
      documentApprovalFailure: action.documentApprovalFailure,
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
  );
}

DADetailState _addTrans(DADetailState state, AddTrans action) {
  List<TransactionDetails> userAddedData = state.transList;
  // if (!(userAddedData.contains(action.trans))) {
  userAddedData.add(action.trans);
  // }

  return state.copyWith(
    transList: userAddedData,
  );
}

DADetailState _removeTrans(DADetailState state, RemoveTrans action) {
  var list = state.transList;
  list.remove(action.trans);
  return state.copyWith(
    transList: list,
  );
}

DADetailState _getUnreadList(
    DADetailState state, GetUnreadNotificationList action) {
  return state.copyWith(
    unreadList: action.unreadList,
  );
}

DADetailState _addTransList(DADetailState state, AddTransList action) {
  var list = state.transList;
  list.addAll(action.transList);
  return state.copyWith(
    transList: list,
  );
}

DADetailState _inputListReceiveAction(
    DADetailState state, PendingListFetchSuccessAction action) {
  return state.copyWith(
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    statusCode: action.statusCode,
    pendingList: action.documentResponse,
    transactionDtl: action.documentResponse.transactionDtl,
  );
}

DADetailState _transactionDtl(
    DADetailState state, TransactionDetailsFetchSuccessAction action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      transactionApprDTL: action.documentResponse);
}

DADetailState _clearStateAction(DADetailState state, ClearStateAction action) {
  return state.copyWith(multiDocumentSave: action.multiDocumentSave,documentSave: action.documentSave);
}

DADetailState _onDispose(DADetailState state, OnDispose action) {
  return DADetailState.initial();
}
//List<TransactionDtlApproval>
DADetailState _onDisposeDetails(DADetailState state, OnDisposeDetails action) {
  return state.copyWith(transactionDtl: null,transactionApprDTL: null,reportDtlFormat: null,reportSummaryFormat: null);
}

// DADetailState _selectAll(
//     DADetailState state, SelectAll action) {
//
//   return state.copyWith(selectAll: true);
// }

DADetailState _selectedOption(
        DADetailState state, TransactionTypeSelectedAction action) =>
    state.copyWith(
      onNewOption: true,
      selectedOption: action.transaction,
      isSummaryApproval: action.transaction.isSummaryApproval,
      reportDtlFormat: action.transaction.reportDtlFormat,
      reportSummaryFormat: action.transaction.reportSummaryFormat,
      approvalTypes: action.approvalTypes,
    );

DADetailState _updateState(DADetailState state, OnUpdateSuccessAction action) =>
    state.copyWith(
      documentSave: false,
    );

DADetailState _saveSuccessAction(
        DADetailState state, DocumentSubmissionSuccessAction action) =>
    state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        documentSave: action.documentSave);

DADetailState _multiSaveSuccessAction(
        DADetailState state, MultiDocumentSubmissionSuccessAction action) =>
    state.copyWith(
        loadingStatus: LoadingStatus.success,
        loadingMessage: "",
        loadingError: "",
        multiDocumentSave: action.multiDocumentSave);
