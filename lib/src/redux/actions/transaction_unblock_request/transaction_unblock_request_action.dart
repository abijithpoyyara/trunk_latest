import 'package:base/redux.dart';
import 'package:redstars/src/constants/app_constants.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/Action_Taken%20Agst_Whom_Model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/pending_transaction_detail_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/TransactionUnblockReqInitModel.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/transactionDtl%20listtModel.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/transactionDtlHeadingModel l.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/user_object.dart';
import 'package:redstars/src/services/repository/transaction_unblock_request/transaction_unblock_repository.dart';

import '../../../../utility.dart';

class TransactionReqHeadingActionFetch {
  TransactionReqHeading transactionReqHeadingList;
  TransactionReqHeadingActionFetch(this.transactionReqHeadingList);
}

class RestingLoadingAction{}
//class TransactionListActionFetch{
//  PendingTransactionDetailModel dtlModelList;
//
//  TransactionListActionFetch(this.dtlModelList);
//}

class TransactionUnblockInitListAction {
  List<TransactionUnblockReqInitModelList> pendingList;
  TransactionUnblockInitListAction(this.pendingList);
}
class BLockednotificationAction {
  List<TransactionUnblockReqInitModelList> pendingList;
  BLockednotificationAction(this.pendingList);
}

class UserObjectAction {
  List<UserObject> userObjList;

  UserObjectAction(this.userObjList);
}

class BranchObjAction {
  List<BranchesList> branchObjList;

  BranchObjAction(this.branchObjList);
}

//class TransactionReqlListAction{
//  List<PendingTransactionDetailModelList> pendingTransactionDetailModelList;
//  TransactionReqlListAction(this.pendingTransactionDetailModelList);
//}

class ActionTakenAgainstwhomAction {
  List<ActionTakenAgainstwhom> actionTakenAgainstwhomlist;

  ActionTakenAgainstwhomAction(this.actionTakenAgainstwhomlist);
}

class TransactionReqDtllListAction {
  List<TransUnblockReqDtlModel> pendingTransactionDetailList;

  TransactionReqDtllListAction(this.pendingTransactionDetailList);
}

class TransaunBlckReqSaveAction {
  bool loading;

  TransaunBlckReqSaveAction(this.loading);
}


ThunkAction fetchTransactionReqinitList(
    {int optionId}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      TransactionUnblockRepository().getTransactionReqinitList(
        optionId: optionId,
        onRequestSuccess: (pendingList) =>
            store.dispatch(TransactionUnblockInitListAction(pendingList)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}
ThunkAction fetchBranchNotificaion_TransactionReqinitList(
    {int optionId,int branchId}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      TransactionUnblockRepository().getBranchNotificaion_TransactionReqinitList(
        optionId: optionId,
        brachId: branchId,
        onRequestSuccess: (pendingList) =>
            store.dispatch(BLockednotificationAction(pendingList)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}



ThunkAction fetchUnblockDataItemsFilterUsers(
    {int id, int selopt, int userId, int branchId,int optionId}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      TransactionUnblockRepository().getPendingTransactionsByFilterUser(
        id: id,
        selopt: selopt,
        userId: userId,
        branchId: branchId,
        optionId: optionId,
        onRequestSuccess: (pendingList) =>
            store.dispatch(TransactionUnblockInitListAction(pendingList)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}


ThunkAction fetchFilterUsers() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      TransactionUnblockRepository().getUserlistTransactionsFilterusers(
        onRequestSuccess: (pendingList) =>
            store.dispatch(UserObjectAction(pendingList)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
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
      TransactionUnblockRepository().getBranchTransactionsReq(
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




ThunkAction fetchTransReqDtlListHeadings({
  int RptFormatId,
//  TransactionReqHeadingList tableModelList,
  // PendingTransactionDetailModelList dtlModelList,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading List",
      ));
      TransactionUnblockRepository().getTransReqDtlListHeadings(
        rptId: RptFormatId,
        onRequestSuccess: (documentResponse) => store
            .dispatch(new TransactionReqHeadingActionFetch(documentResponse)),
        onRequestFailure: (error) => store.dispatch(LoadingAction(
            status: LoadingStatus.error, message: error.toString())),
      );
    });
  };
}


ThunkAction fetchPendingTransactionsReqDtlListDetail({
  int id,
  int optionId,
  int st,
  int branchId,
}) {

  return (Store store) async {
    new Future(() async {

      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Fetching list  ",
      ));
      TransactionUnblockRepository().getPendingTransactionsReqDtlListDetail(
          id: id,
          optionId: optionId,
          st: st,
          branchId: branchId,
          onRequestSuccess: (result) =>
              {store.dispatch(TransactionReqDtllListAction(result))},
          onRequestFailure: (error) => store.dispatch(new LoadingAction(
                status: LoadingStatus.error,
                message: error.toString(),
              )));
    });
  };
}

ThunkAction saveTransactionUnblockReqAppl({
  int optionId,
  String actiontaken,
  String blockedreason,
  int notificationid,
  int reftableid,
  int reftabledataid,
  String isblockedyn,
  String blockeddate,
  List<dynamic> selectedActnAgnUsers,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Saving Req ",
      ));

      TransactionUnblockRepository().saveTransactionUnblockRequest(
        actiontaken: actiontaken,
        blockedreason: blockedreason,
        optionId: optionId,
        selectedActnAgnUsers: selectedActnAgnUsers,
        notificationid: notificationid,
        reftableid: reftableid,
        reftabledataid: reftabledataid,
        isblockedyn: isblockedyn,
        blockeddate: blockeddate,
        onRequestSuccess: (result) =>
            {store.dispatch(new TransaunBlckReqSaveAction(result))},
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}

ThunkAction fetchActionTakenAgainstwhom({
  int start,
  int sor_Id,
  int eor_Id,
  int totalRecords,
  int value,
  int FinYearId,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      TransactionUnblockRepository().getActionTakenAgainstwhom(
        start: start,
        sor_Id: sor_Id,
        eor_Id: eor_Id,
        totalRecords: totalRecords,
        value: value,
        FinYearId: FinYearId,
        onRequestSuccess: (result) =>
            store.dispatch(new ActionTakenAgainstwhomAction(result)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });

  };
}

ThunkAction fetchAllBranchFilter(
    {int optionId,int userId,bool allbranBYUser,}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading ",
      ));
      TransactionUnblockRepository().getAllBranchFilter(
        allbranBYUser:allbranBYUser,
        userId: userId,
        optionId: optionId,
        onRequestSuccess: (pendingList) =>
            store.dispatch(TransactionUnblockInitListAction(pendingList)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
          status: LoadingStatus.error,
          message: error.toString(),
        )),
      );
    });
  };
}












//if( widget.flag==1)
//                                        Positioned(
//                                            right: MediaQuery.of(context).size.width * .02,
//                                            child: CircleAvatar(
//                                              backgroundColor:
//                                             widget.type
//                                                  ? Colors.red
//                                                  :
//                                              Colors.yellow,
//                                              radius: 10,
//                                              child:
//                                              widget.type
//                                                  ? Icon(
//                                                Icons.block,
//                                                color: Colors.white,
//                                                size: 12,
//                                              )
//                                                  :
//                                              Icon(
//                                                Icons.warning_amber_sharp,
//                                                color: Colors.black,
//                                                size: 12,
//                                              ),
//                                            )),