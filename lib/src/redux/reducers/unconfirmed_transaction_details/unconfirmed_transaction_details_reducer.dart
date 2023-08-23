import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/unconfirmed_transaction_details/unconfirmed_transaction_details_action.dart';
import 'package:redstars/src/redux/states/unconfirmed_transaction_details/unconfirmed_transaction_details_state.dart';
import 'package:redstars/src/services/model/response/unconfirmed_transaction_details/unconfirmed_transaction_details_list_model.dart';

final unConfirmedTransactionDetailReducer =
    combineReducers<UnConfirmedTransactionDetailState>([
  TypedReducer<UnConfirmedTransactionDetailState, LoadingAction>(
      _lodingStatusAction),
  TypedReducer<UnConfirmedTransactionDetailState,
      UnconfirmedTransactionDetailInitialDataAction>(_initialConfigFetchAction),
  TypedReducer<UnConfirmedTransactionDetailState,
      UnconfirmedTransactionListDataAction>(_unconfirmedListFectchAction),
  TypedReducer<UnConfirmedTransactionDetailState,
      UnconfirmedFilterChangeAction>(_filterSaveAction),
  TypedReducer<UnConfirmedTransactionDetailState,
          UnconfirmedTransactionDetailSaveAction>(
      _saveUnConfirmedTransactionDetailAction),
  TypedReducer<UnConfirmedTransactionDetailState,
      UnconfirmedTransactionDetailClearAction>(_onClearAction),
  TypedReducer<UnConfirmedTransactionDetailState,
      UnconfirmedTransactionAddItemAction>(_addUnconfirmedItemAction),
  TypedReducer<UnConfirmedTransactionDetailState,
      UnconfirmedTransactionRemoveItemAction>(_removeUnconfirmedItemAction),
  TypedReducer<UnConfirmedTransactionDetailState, GetUnreadNotificationList>(
      _getUnreadList),
  TypedReducer<UnConfirmedTransactionDetailState, GetNotificationCount>(
      _onNotificationCountAction),
  TypedReducer<UnConfirmedTransactionDetailState,
      UnconfirmedNotificationClickAction>(_notificationClickAction),

      ///update
      TypedReducer<UnConfirmedTransactionDetailState,
          UnconfirmedTransactionApproveFailureAction>(
      _unconfirmedTransactionDocumentApproveFailure),
]);

UnConfirmedTransactionDetailState _lodingStatusAction(
    UnConfirmedTransactionDetailState state, LoadingAction action) {
  return state.copyWith(
      loadingMessage: action.message,
      loadingError: action.message,
      loadingStatus: action.status);
}

UnConfirmedTransactionDetailState _notificationClickAction(
    UnConfirmedTransactionDetailState state,
    UnconfirmedNotificationClickAction action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      unconfirmedNotificationModel: action.notificationModel);
}

UnConfirmedTransactionDetailState _onNotificationCountAction(
    UnConfirmedTransactionDetailState state, GetNotificationCount action) {
  return state.copyWith(
    notificationDetails: action.notificationCountDetails,
  );
}

UnConfirmedTransactionDetailState _getUnreadList(
    UnConfirmedTransactionDetailState state, GetUnreadNotificationList action) {
  return state.copyWith(
    unreadList: action.unreadList,
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
  );
}

UnConfirmedTransactionDetailState _removeUnconfirmedItemAction(
    UnConfirmedTransactionDetailState state,
    UnconfirmedTransactionRemoveItemAction action) {
  List<UnConfirmedTransactionDetailList> unconfirmedItems =
      state.addedUnconfirmedItems;
  unconfirmedItems.remove(action.unconfirmedRemovedList);
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      addedUnconfirmedItems: unconfirmedItems);
}

UnConfirmedTransactionDetailState _addUnconfirmedItemAction(
    UnConfirmedTransactionDetailState state,
    UnconfirmedTransactionAddItemAction action) {
  List<UnConfirmedTransactionDetailList> unconfirmedItems =
      state.addedUnconfirmedItems;
  if (!(unconfirmedItems.contains(action.unconfirmedList))) {
    unconfirmedItems.add(action.unconfirmedList);
  }

  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      addedUnconfirmedItems: unconfirmedItems);
}

UnConfirmedTransactionDetailState _initialConfigFetchAction(
    UnConfirmedTransactionDetailState state,
    UnconfirmedTransactionDetailInitialDataAction action) {
  if ((action.isFromNotify ?? false) == true) {
    return state.copyWith(
      transOptionTypes: action.transactionOptionTypes,
      initialTransType: action.transactionOptionTypes.first,
      statusTypes: action.statusTypes,
    );
  } else {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    transOptionTypes: action.transactionOptionTypes,
    initialTransType: action.transactionOptionTypes.first,
    statusTypes: action.statusTypes,
  );
  }
}

UnConfirmedTransactionDetailState _onClearAction(
    UnConfirmedTransactionDetailState state,
    UnconfirmedTransactionDetailClearAction action) {
  return state.copyWith(
      loadingError: "",
      loadingMessage: "",
      loadingStatus: LoadingStatus.success,
      unConfirmedTransactionDetailSave:
          action.unConfirmedTransactionDetailSave);
}

UnConfirmedTransactionDetailState _unconfirmedListFectchAction(
    UnConfirmedTransactionDetailState state,
    UnconfirmedTransactionListDataAction action) {
  if ((action.isFromNotify ?? false) == true) {
    return state.copyWith(
        unConfirmedTransactionDetailListData:
            action.unConfirmedTransactionDetailListData,
        statusCode: action.statusCode);
  } else {
  return state.copyWith(
    loadingError: "",
    loadingMessage: "",
    loadingStatus: LoadingStatus.success,
    unConfirmedTransactionDetailListData:
        action.unConfirmedTransactionDetailListData,
      statusCode: action.statusCode);
  }
}

UnConfirmedTransactionDetailState _filterSaveAction(
    UnConfirmedTransactionDetailState state,
    UnconfirmedFilterChangeAction action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      unConfirmedFilterModel: action.filter);
}

UnConfirmedTransactionDetailState _saveUnConfirmedTransactionDetailAction(
    UnConfirmedTransactionDetailState state,
    UnconfirmedTransactionDetailSaveAction action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      unConfirmedTransactionDetailSave: action.unConfirmedTransactionDetailSave,
      addedUnconfirmedItems: [],
  );
}

UnConfirmedTransactionDetailState _unconfirmedTransactionDocumentApproveFailure(
    UnConfirmedTransactionDetailState state,
    UnconfirmedTransactionApproveFailureAction action) {
  return state.copyWith(
    message: action.message,
    unconfirmedTransactionApprovalFailure: action.UTApprovalFailure,
    loadingStatus: LoadingStatus.success,
    loadingMessage: "",
    loadingError: "",
    addedUnconfirmedItems: [],
  );
}
