import 'package:base/redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/redux/actions/transaction_unblock_request/transaction_unblock_request_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/Action_Taken%20Agst_Whom_Model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/pending_transaction_detail_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/TransactionUnblockReqInitModel.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/transactionDtl%20listtModel.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/transactionDtlHeadingModel l.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/user_object.dart';

class TranUnblockReqViewmodel extends BaseViewModel {
  final List<TransactionUnblockReqInitType> ptListModel;
  final TransactionUnblockReqInitType pendingTransactionsListModel;
  final TransactionReqHeading tableModel;
  TransactionReqHeading transactionReqHeadingList;
  final TransactionReqHeadingList pendingTile;

//  final PendingTransactionDetailModel dtlModel;
//  final PendingTransactionDetailModelList dtlModelList;
  final List<TransactionUnblockReqInitModelList> pendingList;
  final List<TransUnblockReqDtlModel> pendingTransactionDetailList;
  final List<BranchesList> branchObjList;
  final List<UserObject> userObjects;
  final List<ActionTakenAgainstwhom> actionTakenAgainstwhomlist;
  final String loginedUser;
  final bool loading;
final Function restLoading;
final Function({int optionId,int userId,bool allbranBYUser}) allBranchFilter ;

//  final Function() refresh;
//  final Function() initialcall;

  // final List<dynamic>  selectedActionAgainstUsers;

  final Function(
      {String actiontaken,
      String blockedreason,
      int notificationid,
      int reftableid,
      int reftabledataid,
      String isblockedyn,
      List<dynamic> data,
      String blockeddate}) onSave;

//  final Function({
//    int start,
//    int sor_Id,
//    int eor_Id,
//    int totalRecords,
//    int value,
//    int FinYearId,
//  }) ActionTkenWhom;
  final int optionId;
  final int userId;
  final Function(int rptFormatId, int Id, int st, int branch,int optionId) getDtl;
  final Function({int id, int selopt, int userId, int branchId,int optionId}) searchByUser;
final Function () refreshmainscreen;
  TranUnblockReqViewmodel({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String loadingError,
    this.ptListModel,
    this.refreshmainscreen,
    this.pendingTransactionsListModel,
    this.tableModel,
    this.transactionReqHeadingList,
    this.pendingTile,
    this.actionTakenAgainstwhomlist,
//      this.dtlModel,
    this.searchByUser,
    this.loading,
    this.restLoading,
    this.getDtl,
  this.allBranchFilter,
//    this.dtlModelList,
    this.branchObjList,
    this.pendingList,
    this.pendingTransactionDetailList,
    this.userObjects,
    this.optionId,
    this.onSave,
    this.loginedUser,
    this.userId,
//    this.initialcall,
//      this.ActionTkenWhom
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: loadingError,
        );

  factory TranUnblockReqViewmodel.fromStore(Store<AppState> store) {
    final state = store.state.tranUnblkReqState;
    int optionid = store.state.homeState.selectedOption.optionId;
    String loginUser = store.state.homeState.user.userName;
    int userId = store.state.homeState.user.userId;
    return TranUnblockReqViewmodel(
        loadingStatus: state.loadingStatus,
        loadingError: state.loadingError,
        loadingMessage: state.loadingMessage,
        pendingTransactionsListModel: state.pendingTransactionsListModel,
        ptListModel: state.ptListModel,
        tableModel: state.tableModel,
        transactionReqHeadingList: state.transactionReqHeadingList,
        pendingTile: state.pendingTile,
        loading: state.loading,
//      dtlModel: state.dtlModel,
        optionId: optionid,
        loginedUser: loginUser,
        actionTakenAgainstwhomlist: state.actionTakenAgainstwhomlist,
        pendingTransactionDetailList: state.pendingTransactionDetailList,
//      dtlModelList: state.dtlModelList,
        branchObjList: state.branchObjList,
        pendingList: state.pendingList,
        userObjects: state.userObjects,
userId: userId,


//
//        initialcall: store.dispatch(fetchTransactionReqinitList(
//          optionId: optionid,
//        )),

        allBranchFilter: ({int optionId,int userId,bool allbranBYUser}){
          store.dispatch(fetchAllBranchFilter(optionId: optionId,userId: userId,allbranBYUser: allbranBYUser));
    },

        searchByUser: ({int id, int selopt, int userId, int branchId,int optionId}) {
          store.dispatch(fetchUnblockDataItemsFilterUsers(
            id: id,
            selopt: selopt,
            branchId: branchId,
            userId: userId,
            optionId: optionId
          ));
        },
refreshmainscreen: (){
  store.dispatch(fetchTransactionReqinitList(optionId: optionid));
},

        getDtl: (rptFormatId, id, st, brachid,optionId) {
          store
              .dispatch(fetchTransReqDtlListHeadings(RptFormatId: rptFormatId));
          store.dispatch(fetchPendingTransactionsReqDtlListDetail(
              id: id, branchId: brachid, st: st,optionId: optionId,));
        },
restLoading: ()
      {
        store.dispatch(RestingLoadingAction());
      },

        onSave: (
            {String actiontaken,
            String blockedreason,
            notificationid,
            reftableid,
            reftabledataid,
            isblockedyn,
            blockeddate,
            data}) {
          store.dispatch(saveTransactionUnblockReqAppl(
              optionId: optionid,
              actiontaken: actiontaken,
              blockedreason: blockedreason,
              notificationid: notificationid,
              reftableid: reftableid,
              reftabledataid: reftabledataid,
              isblockedyn: isblockedyn,
              selectedActnAgnUsers: data,
              blockeddate: blockeddate));
        },

//
//        refresh: () {
//          store.dispatch(fetchTransactionReqinitList());
//          store.dispatch(fetchFilterUsers());
//          store.dispatch(fetchFilterBranches());
//          store.dispatch(fetchActionTakenAgainstwhom());
//        }

//      ActionTkenWhom: ({
//        start,
//        sor_Id,
//        eor_Id,
//        totalRecords,
//        value,
//        FinYearId,
//      }) {
//        store.dispatch(fetchActionTakenAgainstwhom(
//          start: 0,
//          eor_Id: eor_Id,
//          sor_Id: sor_Id,
//          totalRecords: totalRecords,
//          value: value,
//          FinYearId: FinYearId,
//        ));
//      },
        );
  }
}
