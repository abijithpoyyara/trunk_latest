import 'package:base/redux.dart';
import 'package:flutter/cupertino.dart';
import 'package:redstars/src/redux/viewmodels/transaction_unblock_request/transaction_unblock_request_viewmodel.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_transaction_dtl.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/Action_Taken%20Agst_Whom_Model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/pending_transaction_detail_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/TransactionUnblockReqInitModel.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/transactionDtl%20listtModel.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/transactionDtlHeadingModel l.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request/user_object.dart';

class TransUnblkReqState extends BaseState {
  final TransactionUnblockReqInitType pendingTransactionsListModel;
  final List<TransactionUnblockReqInitType> ptListModel;
  final TransactionReqHeading tableModel;
  final TransactionReqHeadingList tableList;
  final   TransactionReqHeading  transactionReqHeadingList;
  final TransactionReqHeadingList pendingTile;
//
final     List<TransUnblockReqDtlModel> pendingTransactionDetailList;
  final   List<TransactionUnblockReqInitModelList> pendingList;
  final List<UserObject> userObjects;
  final  List<BranchesList>branchObjList;
  final  List<ActionTakenAgainstwhom> actionTakenAgainstwhomlist;

final bool loading;

  TransUnblkReqState({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String loadingError,
    this.ptListModel,
    this.pendingTransactionsListModel,
    this.tableModel,
    this.loading,
    this.transactionReqHeadingList,
    this.pendingTile,
    this.actionTakenAgainstwhomlist,
//    this.dtlModel,
//    this.dtlModelList,
    this.tableList,
    this.pendingList,
    this.userObjects,
    this.branchObjList,
    this.pendingTransactionDetailList,
  }) : super(
    loadingMessage: loadingMessage,
    loadingError: loadingError,
    loadingStatus: loadingStatus,
  );

  TransUnblkReqState copyWith({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    List<TransactionUnblockReqInitType> ptListModel,
    TransactionUnblockReqInitType pendingTransactionsListModel,
    TransactionReqHeading tableModel,
    TransactionReqHeadingList pendingTile,
    TransactionReqHeading  transactionReqHeadingList,
//    PendingTransactionDetailModel dtlModel,
//    PendingTransactionDetailModelList dtlModelList,
    TransactionReqHeadingList tableList,
    List<TransactionUnblockReqInitModelList> pendingList,
    List<UserObject> userObjects,
    List<BranchesList> branchObjList,
    List<TransUnblockReqDtlModel> pendingTransactionDetailList,
    List<ActionTakenAgainstwhom> actionTakenAgainstwhomlist,
    bool loading,


  }) {
    return TransUnblkReqState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingError: loadingError,
      loadingMessage: loadingMessage,
      ptListModel: ptListModel ?? this.ptListModel,
      pendingTransactionsListModel: pendingTransactionsListModel ?? this.pendingTransactionsListModel,
      tableModel: tableModel ?? this.tableModel,
      transactionReqHeadingList: transactionReqHeadingList ?? this.transactionReqHeadingList,
      pendingTile: pendingTile ?? this.pendingTile,
//      dtlModel: dtlModel ?? this.dtlModel,
//      dtlModelList: dtlModelList ?? this.dtlModelList,
      tableList: tableList ?? this.tableList,
      actionTakenAgainstwhomlist: actionTakenAgainstwhomlist ?? this.actionTakenAgainstwhomlist,
      pendingList: pendingList ?? this.pendingList,
      userObjects: userObjects ?? this.userObjects,
      branchObjList:branchObjList??this.branchObjList,
        loading: loading??this.loading,
        pendingTransactionDetailList:pendingTransactionDetailList?? this.pendingTransactionDetailList,
    );
  }

  factory TransUnblkReqState.initial() {
    return TransUnblkReqState(
      loadingStatus: LoadingStatus.success,
      loadingError: '',
      loadingMessage: '',
      ptListModel: [],
      pendingTransactionsListModel: null,
      tableModel: null,
      loading: false,
      transactionReqHeadingList: null,
//      dtlModel: null,
      tableList: null,
        pendingList: List(),
        pendingTransactionDetailList:[],
        branchObjList:List(),
        userObjects: List(),
        actionTakenAgainstwhomlist:[],
    );
  }
}