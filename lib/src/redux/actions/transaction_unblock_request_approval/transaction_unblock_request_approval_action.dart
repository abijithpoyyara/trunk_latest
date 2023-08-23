import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_approval_action_types_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_approval_history_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_approval_mainscreen_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_list_head_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_list_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_unblock_notification_model.dart';
import 'package:redstars/src/services/repository/transaction_unblock_request_approval/transaction_unblock_request_approval_repository.dart';
import 'package:redstars/src/widgets/screens/company_listing_screen/company_detail_listing.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/model/branch_model.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/model/transaction_save_model.dart';
import 'package:redux_thunk/redux_thunk.dart';

class TransactionApprovalReqDetails {
  List<TransactionUnblockReqApprlCountList> transactionScreenDtl;
  final int statusCode;
  TransactionApprovalReqDetails(this.transactionScreenDtl, this.statusCode);
}

class TransactionSaveModelAction {
  final ApprovalSaveModel saveModel;

  TransactionSaveModelAction(this.saveModel);
}

class TransactionApprovalHeadindDtl {
  TransactionUnblockListHead transactionApprovalHeadindDtl;

  TransactionApprovalHeadindDtl(this.transactionApprovalHeadindDtl);
}

class TransactionApprovalList {
  TransactionUnblockListHead1 transactionReqApprovallis;

  TransactionApprovalList(this.transactionReqApprovallis);
}

class TransactionUnblockApprovalNotificationClickAction {
  final TransactionUnblockNotificationModel notificationModel;

  TransactionUnblockApprovalNotificationClickAction(this.notificationModel);
}
class clearFilterAction{}

class ChangeBranchId {
  int branch;
  bool isAllBranchSelected;
  String branchName;
  ChangeBranchId({this.branch,this.isAllBranchSelected,this.branchName});
}

class ClearTURPScreen{

}



class SavingPaymentFilterAction {
  PVFilterModel filterModel;

  SavingPaymentFilterAction({this.filterModel});
}

class ApprovalTypeAction {
  List<ActionTaken> ActionType;

  ApprovalTypeAction(this.ActionType);
}

class BranchObjAction {
  List<BranchesList> branchObjList;

  BranchObjAction(this.branchObjList);
}

class FetchHistoryData {
  List<HistoryModel> historyModel;

  FetchHistoryData(this.historyModel);
}

class GetUnreadNotificationList {
  List<UnreadNotificationListModel> unreadList;
  GetUnreadNotificationList(this.unreadList);
}
///
class TransactionReqApplClearAction {
  bool isTransReqAppvl;
  TransactionReqApplClearAction({this.isTransReqAppvl});
}

class TransaunBlckReqApprSaveAction {
  bool isTransReqAppvl;
  TransaunBlckReqApprSaveAction({this.isTransReqAppvl});
}

class TransaunBlckReqApprSaveFromNotificationAction {
  bool isTransReqAppvlNotification;
  TransaunBlckReqApprSaveFromNotificationAction({this.isTransReqAppvlNotification});
}

class GetNotificationCount{
  List<NotificationCountDetails> notificationCountDetails;
  GetNotificationCount(this.notificationCountDetails);
}




class TransactionUnblockRequestApprovalFailureAction {
  String message;
  bool TURequestApprovalFailure;
  TransactionUnblockRequestApprovalFailureAction({this.message,this.TURequestApprovalFailure});
}

ThunkAction fetchTransactionApprovalMainscreen(
    {int optionId, int accId, int branchId, int flg,bool allBranch}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Fetching details ",
      ));
      TransactionUnblockReqRepository().getTransactionMainScreenData(
          optionId: optionId,
          branchId: branchId,
          flg: flg,
          allBranch:allBranch,
          onRequestSuccess: (result, statusCode) => {
                store
                    .dispatch(TransactionApprovalReqDetails(result, statusCode))
              },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchTransactionUnblockApprovalNotificationClickAction({
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

      TransactionUnblockReqRepository().getMobileNotification(
          optionId: optionId,
          transId: transId,
          transTableId: transTableId,
          onRequestSuccess: (result) => {
                store.dispatch(
                    TransactionUnblockApprovalNotificationClickAction(result))
              },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchTransactionApprovalHeading({rptFormatId}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Fetching the details ",
      ));

      TransactionUnblockReqRepository().getReportformatDtls(
          rptFormatId: rptFormatId,
          onRequestSuccess: (result) =>
              {store.dispatch(TransactionApprovalHeadindDtl(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchTransactionApprovalReqList2({
  int id,
  int flg,
  int optionId,
  int transReqOptionId,
  int branchId,
  int notificationOptionId,
  int notificationId,
  bool allBranchYN,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Fetching list  ",
      ));
      TransactionUnblockReqRepository().getTransactionApprovalList(
          id: id,
          flg: flg,
          branchId: branchId,
          optionId: optionId,
          onRequestSuccess: (result) =>
              {store.dispatch(TransactionApprovalList(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchTransactionApprovalReqList({
  int id,
  int flg,
  int optionId,
  int transReqOptionId,
  int unblockBranchId,
  int branchId,
  int notificationOptionId,
  int notificationId,
  bool allBranchYN,
}) {
  return (Store store) async {
    new Future(() async {


      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Fetching list  ",
      ));


      TransactionUnblockReqRepository().getTransactionApprovalList(
          id: id,
          flg: flg,
          branchId: branchId,
          optionId: optionId,
          onRequestSuccess: (result)
          {store.dispatch(TransactionApprovalList(result)
          );
          if(transReqOptionId == null) {
            transReqOptionId =
                result?.transactionUnblockListView?.first?.requestoptionid;
          }
      TransactionUnblockReqRepository().getUnreadList(
        optionId: transReqOptionId,
        notificationOptionId: notificationOptionId,
        notificationId: notificationId,
        unblockBranchId: unblockBranchId,
        allBranchYN: allBranchYN,
          branchIdFromCall: branchId,

        onRequestSuccess: (response) =>
            store.dispatch(GetUnreadNotificationList(response)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
            status: LoadingStatus.error, message: error.toString())),
      );
          },
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
            status: LoadingStatus.error,
            message: error.toString(),
          )));

    });
  };
}

ThunkAction fetchTransactionApprovalReqFilterList(
    {int branchId,
  int id,
  PVFilterModel filterModel,
  int optionId,
  String dynamicTitle,
    bool isBranchBlocked}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Fetching list  ",
      ));
      TransactionUnblockReqRepository().getTransactionApprovalfilterList(
        isBranchBlocked: isBranchBlocked,
          branchId:branchId,
          id: id,
          filterModel: filterModel,
          optionId: optionId,
          dynamicTitle: dynamicTitle,
          onRequestSuccess: (result) =>
              {store.dispatch(TransactionApprovalList(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchActionTypes() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Fetching details ",
      ));

      TransactionUnblockReqRepository().getApprovalTypes(
//          optionId: optionId,
          onRequestSuccess: (result) =>
              {store.dispatch(ApprovalTypeAction(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction fetchHistoryData(int tableId, tableDataId) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Fetching Details",
      ));
      TransactionUnblockReqRepository().getTransactionHistory(
          tableId: tableId,
          tableDataId: tableDataId,
          onRequestSuccess: (result) =>
              store.dispatch(FetchHistoryData(result)),
          onRequestFailure: (error) => store.dispatch(LoadingAction(
              status: LoadingStatus.error, message: error.toString())));
    });
  };
}

ThunkAction fetchFilterBranches() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      TransactionUnblockReqRepository().getBranchTransactionsReq(
        onRequestSuccess: (branchList) =>
            store.dispatch(BranchObjAction(branchList)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction saveTransactionUnblockReqAppl({
  DateTime approveddate,
  String docapprvlremarks,
  String docapprvlstatus,
  DateTime extendeddate,
  int Id,
  int reftabledataid,
  int reftableid,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Saving Approval ",
      ));

      TransactionUnblockReqRepository().saveTransactionUnblockRequestApproval(
        id: Id,
        status: docapprvlstatus,
        remark: docapprvlremarks,
        Apprvdate: approveddate,
        extendedDt: extendeddate,
        reftabledataid: reftabledataid,
        reftableid: reftableid,
        onRequestSuccess: () =>
            store.dispatch(new TransaunBlckReqApprSaveAction(isTransReqAppvl: true)),
        onRequestFailure: (error) {

          store.dispatch(TransactionUnblockRequestApprovalFailureAction(message: error.toString(),TURequestApprovalFailure: true));
        //    store.dispatch(new LoadingAction(
        //   status: LoadingStatus.error,
        //   message: error.toString(),
        // ));
        },
      );
    });
  };
}

ThunkAction saveTransactionUnblockReqApplFromNotification({
  DateTime approveddate,
  String docapprvlremarks,
  String docapprvlstatus,
  DateTime extendeddate,
  int Id,
  int reftabledataid,
  int reftableid,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Saving Approval ",
      ));

      TransactionUnblockReqRepository().saveTransactionUnblockRequestApproval(
        id: Id,
        status: docapprvlstatus,
        remark: docapprvlremarks,
        Apprvdate: approveddate,
        extendedDt: extendeddate,
        reftabledataid: reftabledataid,
        reftableid: reftableid,
        onRequestSuccess: () =>
            store.dispatch(new TransaunBlckReqApprSaveFromNotificationAction(isTransReqAppvlNotification: true)),
        onRequestFailure: (error) {

          store.dispatch(TransactionUnblockRequestApprovalFailureAction(message: error.toString(),TURequestApprovalFailure: true));
          //    store.dispatch(new LoadingAction(
          //   status: LoadingStatus.error,
          //   message: error.toString(),
          // ));
        },
      );
    });
  };
}

ThunkAction fetchUnreadCount({
  int branchId2,
  bool allBranchYN,
}) {
  return (Store store) async {
  new Future(() async {
    int optionId = store.state.homeState.selectedOption.id;
    store.dispatch(new LoadingAction(
    status: LoadingStatus.loading,
    message: "Loading ",
));
    TransactionUnblockReqRepository().getUnreadCount(
      branchId2: branchId2,
        allBranchYN: allBranchYN,
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

ThunkAction setNotificationAsRead(
    {int optionId, int transTableId, int transId, int notificationId,int branchId}) {
  return (Store store) async {
    new Future(() async {
      int optionId2 = store?.state?.homeState?.selectedOption?.id;
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading List",
      ));
      TransactionUnblockReqRepository().setNotificationAsRead(
          optionId: optionId2??optionId,
          transId: transId,
          transTableId: transTableId,
          unblockBranchId: branchId,
          notificationId: notificationId,
          onRequestSuccess: () => print("Notification Seen"),
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
            status: LoadingStatus.error,
                message: exception.toString(),
              )));
    });
  };
}
