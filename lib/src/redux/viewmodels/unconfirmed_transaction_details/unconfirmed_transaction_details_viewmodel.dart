import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/redux/actions/unconfirmed_transaction_details/unconfirmed_transaction_details_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/states/unconfirmed_transaction_details/unconfirmed_transaction_details_state.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_unblock_notification_model.dart';
import 'package:redstars/src/services/model/response/unconfirmed_transaction_details/unconfirmed_transaction_details_list_model.dart';
import 'package:redstars/src/widgets/screens/unconfirmed_transaction_details/model/unconfirmed_filter.dart';

class UnConfirmedTransactionDetailViewModel extends BaseViewModel {
  final List<BCCModel> statusTypes;
  final List<BCCModel> transOptionTypes;
  final bool unConfirmedTransactionDetailSave;
  final int optionId;
  final List<UnConfirmedTransactionDetailList>
      unConfirmedTransactionDetailListData;
  final UnConfirmedFilterModel unConfirmedFilterModel;
  final List<UnConfirmedTransactionDetailList> addedUnconfirmedItems;
  final Function(String, String) onSaveUnConfirmedTransaction;
  final Function(UnConfirmedFilterModel filter) onChangeUnconfirmedFilter;
  final Function(UnConfirmedFilterModel filterModel) onUserSelect;
  final TransactionUnblockNotificationModel unconfirmedNotificationModel;
  final Function(UnConfirmedTransactionDetailList) onAddUnconfirmedData;
  final Function(UnConfirmedTransactionDetailList) onRemoveUnconfirmedData;
  final UnConfirmedTransactionDetailList selectedUnconfirmedData;
  final VoidCallback onUnconfirmedClearAction;
  final Function() onCalledAfterSave;
  final List<UnreadNotificationListModel> unreadList;
  final List<NotificationCountDetails> notificationDetails;
  final Function({
    int optionId,
    int transTableId,
    int transId,
    int notificationId,
  }) setNotificationAsReadFunction;

  final Function(
    BCCModel optionCode,
    int optnid,
  ) onCallBackData;
  final int statusCode;

  ///update
  String message;
  final bool unconfirmedTransactionApprovalFailure;
  VoidCallback resetUTApprovalFailure;
  final Function(
    int optnid,
  ) onRefreshData;

  UnConfirmedTransactionDetailViewModel(
      {LoadingStatus loadingStatus,
    String loadingMessage,
    String errorMessage,
    this.statusTypes,
    this.transOptionTypes,
    this.unConfirmedTransactionDetailSave,
    this.optionId,
    this.unConfirmedTransactionDetailListData,
    this.onSaveUnConfirmedTransaction,
    this.unConfirmedFilterModel,
    this.onChangeUnconfirmedFilter,
    this.onUserSelect,
    this.addedUnconfirmedItems,
    this.onAddUnconfirmedData,
    this.selectedUnconfirmedData,
    this.onRemoveUnconfirmedData,
    this.onUnconfirmedClearAction,
    this.onCalledAfterSave,
    this.unreadList,
    this.unconfirmedNotificationModel,
    this.notificationDetails,
    this.setNotificationAsReadFunction,
    this.onCallBackData,
    this.statusCode,
    this.unconfirmedTransactionApprovalFailure,
    this.message,
      this.resetUTApprovalFailure,
      this.onRefreshData})
      : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: errorMessage,
        );

  factory UnConfirmedTransactionDetailViewModel.fromStore(
      Store<AppState> store) {
    UnConfirmedTransactionDetailState state =
        store.state.unConfirmedTransactionDetailState;
    int optionId = store.state.homeState.selectedOption?.id;
    String loginUser = store.state.homeState.user.userName;
    return UnConfirmedTransactionDetailViewModel(
        loadingStatus: state.loadingStatus,
        errorMessage: state.loadingError,
        loadingMessage: state.loadingMessage,
        optionId: optionId,
        transOptionTypes: state.transOptionTypes,
        statusTypes: state.statusTypes,
        unreadList: state.unreadList,
        notificationDetails: state.notificationDetails,
        unConfirmedTransactionDetailSave:
            state.unConfirmedTransactionDetailSave,
        unconfirmedNotificationModel: state.unconfirmedNotificationModel,
        unConfirmedTransactionDetailListData:
            state.unConfirmedTransactionDetailListData,
        unConfirmedFilterModel: state.unConfirmedFilterModel,
        addedUnconfirmedItems: state.addedUnconfirmedItems,
        selectedUnconfirmedData: state.selectedUnconfirmedData,
        statusCode: state.statusCode,
        onCalledAfterSave: () {
          store.dispatch(fetchInitialConfigUnConfirmedTransactionDetails());
        },
        onCallBackData: (
          optionCode,
          optionId,
        ) {
          store.dispatch(fetchInitialConfigUnConfirmedTransactionDetails());
          store.dispatch(fetchUnconfirmedTransactionListAction(
              filterModel: UnConfirmedFilterModel(
            optionCode: optionCode,
            fromDate: DateTime(DateTime.now().year, DateTime.now().month, 1),
            toDate: DateTime.now(),
          )));
          store.dispatch(fetchUnreadUnconfirmedNotificationList(
              optionId: optionId,
              notificationId: store.state?.homeState?.selectedOption?.id));
        },
        onRefreshData: (optionId) {
          store.dispatch(fetchUnreadUnconfirmedNotificationList(
              optionId: optionId,
              notificationId: store.state?.homeState?.selectedOption?.id));
        },
        onRemoveUnconfirmedData: (removedItem) {
          store.dispatch(UnconfirmedTransactionRemoveItemAction(removedItem));
        },
        setNotificationAsReadFunction: (
            {optionId, transTableId, transId, notificationId}) {
          store.dispatch(setNotificationAsRead(
            optionId: optionId,
            transTableId: transTableId,
            transId: transId,
            notificationId: notificationId,
          ));
        },
        onAddUnconfirmedData: (confirmedListItem) {
          store
              .dispatch(UnconfirmedTransactionAddItemAction(confirmedListItem));
        },
        onSaveUnConfirmedTransaction: (apprvlStatus, optioncode) {
          store.dispatch(saveUnconfirmedTransaction(
              optionCode: state.unConfirmedFilterModel?.optionCode?.code ??
                  optioncode ??
                  "SALES_INVOICE",
              apprvlStatus: apprvlStatus,
              unconfirmedDetails: state.addedUnconfirmedItems));
        },
        onChangeUnconfirmedFilter: (filter) {
          store.dispatch(UnconfirmedFilterChangeAction(filter));
        },
        onUnconfirmedClearAction: () {
          store.dispatch(UnconfirmedTransactionDetailClearAction(
              unConfirmedTransactionDetailSave: false));
        },
        onUserSelect: (filtermodel) {
          store.dispatch(fetchUnconfirmedTransactionListAction(
              filterModel: filtermodel ?? state.unConfirmedFilterModel));
        },
        unconfirmedTransactionApprovalFailure:
            state.unconfirmedTransactionApprovalFailure,
      message: state.message,
      resetUTApprovalFailure: (){
          store.dispatch(UnconfirmedTransactionApproveFailureAction(
              UTApprovalFailure: false));
        });
  }
}
