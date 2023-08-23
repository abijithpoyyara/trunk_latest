import 'dart:developer';

import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_unblock_notification_model.dart';
import 'package:redstars/src/services/model/response/unconfirmed_transaction_details/unconfirmed_transaction_details_list_model.dart';
import 'package:redstars/src/services/repository/unconfirmed_transaction_details/unconfirmed_transaction_details_repository.dart';
import 'package:redstars/src/widgets/screens/unconfirmed_transaction_details/model/unconfirmed_filter.dart';
import 'package:redux_thunk/redux_thunk.dart';

class UnconfirmedTransactionDetailInitialDataAction {
  final List<BCCModel> statusTypes;
  final List<BCCModel> transactionOptionTypes;
  final bool isFromNotify;

  UnconfirmedTransactionDetailInitialDataAction(
      {this.statusTypes, this.transactionOptionTypes, this.isFromNotify});
}

class UnconfirmedTransactionRemoveItemAction {
  final UnConfirmedTransactionDetailList unconfirmedRemovedList;

  UnconfirmedTransactionRemoveItemAction(this.unconfirmedRemovedList);
}

class UnconfirmedTransactionAddItemAction {
  final UnConfirmedTransactionDetailList unconfirmedList;

  UnconfirmedTransactionAddItemAction(this.unconfirmedList);
}

class UnconfirmedTransactionListDataAction {
  final List<UnConfirmedTransactionDetailList>
      unConfirmedTransactionDetailListData;
  final int statusCode;
  final bool isFromNotify;
  UnconfirmedTransactionListDataAction(
      this.unConfirmedTransactionDetailListData,
      this.statusCode,
      this.isFromNotify);
}

class UnconfirmedTransactionDetailClearAction {
  bool unConfirmedTransactionDetailSave;
  UnconfirmedTransactionDetailClearAction(
      {this.unConfirmedTransactionDetailSave});
}

class UnconfirmedTransactionDetailSaveAction {
  bool unConfirmedTransactionDetailSave;
  UnconfirmedTransactionDetailSaveAction(
      {this.unConfirmedTransactionDetailSave});
}

class UnconfirmedFilterChangeAction {
  final UnConfirmedFilterModel filter;

  UnconfirmedFilterChangeAction(this.filter);
}

class GetUnreadNotificationList {
  List<UnreadNotificationListModel> unreadList;
  GetUnreadNotificationList(this.unreadList);
}

class GetNotificationCount {
  List<NotificationCountDetails> notificationCountDetails;
  GetNotificationCount(this.notificationCountDetails);
}

class UnconfirmedNotificationClickAction {
  final TransactionUnblockNotificationModel notificationModel;

  UnconfirmedNotificationClickAction(this.notificationModel);
}

///update

class UnconfirmedTransactionApproveFailureAction {
  String message;
  bool UTApprovalFailure;
  UnconfirmedTransactionApproveFailureAction(
      {this.message, this.UTApprovalFailure});
}

ThunkAction fetchInitialConfigUnConfirmedTransactionDetails(
    {int optionId, bool isFromNotify}) {
  return (Store store) async {
    new Future(() async {
      if(isFromNotify != true)
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Data",
      ));

      UnConfirmedTransactionDetailsRepository().getInitialConfigs(
          onRequestSuccess: (
                  {List<BCCModel> statusTypes,
                  List<BCCModel> transactionOptionTypes}) =>
              store.dispatch(UnconfirmedTransactionDetailInitialDataAction(
                isFromNotify: isFromNotify,
                statusTypes: statusTypes,
                transactionOptionTypes: transactionOptionTypes,
              )),
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
      UnConfirmedTransactionDetailsRepository().getNotificationCount(
          optionID: optionId,
          onRequestSuccess: (response) =>
              store.dispatch(GetNotificationCount(response)),
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
              )));
    });
  };
}

ThunkAction fetchUnconfirmedTransactionListAction(
    {UnConfirmedFilterModel filterModel, bool isFromNotify}) {
  return (Store store) async {
    new Future(() async {
      if(isFromNotify != true)
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading Data",
      ));

      UnConfirmedTransactionDetailsRepository()
          .getUnConfirmedTransactionDetails(
              unConfirmedFilterModel: filterModel,
              onRequestSuccess: (result, statusCode) => {
                    store.dispatch(UnconfirmedTransactionListDataAction(
                        result, statusCode, isFromNotify))
                  },
              onRequestFailure: (error) => store.dispatch(new LoadingAction(
                    status: LoadingStatus.error,
                    message: error.toString(),
                  )));
    });
  };
}

ThunkAction saveUnconfirmedTransaction({
  List<UnConfirmedTransactionDetailList> unconfirmedDetails,
  String optionCode,
  String apprvlStatus,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Saving",
      ));

      UnConfirmedTransactionDetailsRepository().saveUnConfirmedTransaction(
        unconfirmedDetails: unconfirmedDetails,
        optionCode: optionCode,
        apprvlStatus: apprvlStatus,
        onRequestSuccess: () => store.dispatch(
            new UnconfirmedTransactionDetailSaveAction(
                unConfirmedTransactionDetailSave: true)),
        onRequestFailure: (error) {
          ///update
          // log("Exception Hit");
          store.dispatch(UnconfirmedTransactionApproveFailureAction(
              UTApprovalFailure: true, message: error.toString()));
        //   store.dispatch(new LoadingAction(
        //   status: LoadingStatus.error,
        //   message: error.toString(),
        // ));
        },
      );
    });
  };
}

ThunkAction fetchUnreadUnconfirmedNotificationList(
    {int notificationId, int optionId}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading List",
      ));
      UnConfirmedTransactionDetailsRepository().getUnreadListOfUnconfirmed(
        optionId: optionId,
        notificationId: notificationId,
        onRequestSuccess: (response) =>
            store.dispatch(GetUnreadNotificationList(response)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
            status: LoadingStatus.error, message: error.toString())),
      );
    });
  };
}

ThunkAction setNotificationAsRead(
    {var optionId, var transTableId, var transId, var notificationId}) {
  return (Store store) async {
    new Future(() async {
      // store.dispatch(new LoadingAction(
      //   status: LoadingStatus.loading,
      //   message: "Loading",
      // ));
      UnConfirmedTransactionDetailsRepository().setNotificationAsRead(
          optionId: optionId,
          transId: transId,
          transTableId: transTableId,
          notificationOptionId: notificationId,
          onRequestSuccess: (success) => print("Notification Seen"),
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
              )));
    });
  };
}

ThunkAction fetchUnconfirmedNotificationClickAction({
  int optionId,
  int transId,
  int transTableId,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Fetching Notification Data ",
      ));
      UnConfirmedTransactionDetailsRepository().getUnconfirmedNotification(
          optionId: optionId,
          transId: transId,
          transTableId: transTableId,
          onRequestSuccess: (result) =>
              {store.dispatch(UnconfirmedNotificationClickAction(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}
