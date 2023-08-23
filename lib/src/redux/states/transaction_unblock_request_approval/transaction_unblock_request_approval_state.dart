import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_approval_action_types_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_approval_history_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_approval_mainscreen_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_list_head_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_list_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_unblock_notification_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/model/branch_model.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/model/transaction_save_model.dart';

class TransactionUnblockReqApprlState extends BaseState {
  final List<TransactionUnblockReqApprlCountList> tranansctionScreenDtl;
  final TransactionUnblockListHead tranansctionScreenHeadingList;
  final TransactionUnblockListHead1 transactionApprovalListview;
  List<ActionTaken> actionTypes;
  final ApprovalSaveModel apprlSavemodel;
  final PVFilterModel model;
  final bool isTransReqAppvl;
  final int optionId;
  final int branch;
  final List<BranchesList> branchObjList;
  final List<HistoryModel> historyData;
  final List<UnreadNotificationListModel> unreadList;
  final List<NotificationCountDetails> notificationDetails;
  final TransactionUnblockNotificationModel notificationModel;
  final bool isTransReqAppvlNotification;

  final int statusCode;


  ///update
  String message;
  bool transactionUnblockRequestApprovalFailure;
  bool isAllBranchSelected;
  String branchName;

  TransactionUnblockReqApprlState({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    this.tranansctionScreenDtl,
    this.unreadList,
    this.tranansctionScreenHeadingList,
    this.transactionApprovalListview,
    this.model,
    this.actionTypes,
    this.apprlSavemodel,
    this.isTransReqAppvl,
    this.historyData,
    this.optionId,
    this.branchObjList,
    this.notificationModel,
    this.notificationDetails,
    this.statusCode,
    this.branch,

    this.message,
    this.transactionUnblockRequestApprovalFailure,
    this.isTransReqAppvlNotification,

    this.isAllBranchSelected,
    this.branchName
//    this.dtlMapData,
  }) : super(
            loadingStatus: loadingStatus,
            loadingError: loadingError,
            loadingMessage: loadingMessage);

  TransactionUnblockReqApprlState copyWith({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String loadingError,
    List<TransactionUnblockReqApprlCountList> tranansctionScreenDtl,
    TransactionUnblockListHead tranansctionScreenHeadingList,
    TransactionUnblockListHead1 transactionApprovalListview,
    List<ActionTaken> actionTypes,
    List<BranchesList> branchObjList,
    List<HistoryModel> historyData,
    List<NotificationCountDetails> notificationDetails,
    List<UnreadNotificationListModel> unreadList,
    PVFilterModel model,
    ApprovalSaveModel approvalSaveModel,
    bool isTransReqAppvl,
    int optionId,
    TransactionUnblockNotificationModel notificationModel,
    int statusCode,
    int branch,
    bool isAllBranchSelected,
    String message,
    bool transactionUnblockRequestApprovalFailure,
    bool isTransReqAppvlNotification,

    String branchName
  }) {
    return TransactionUnblockReqApprlState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      loadingError: loadingError ?? this.loadingError,
      unreadList: unreadList ?? this.unreadList,
      tranansctionScreenDtl:
          tranansctionScreenDtl ?? this.tranansctionScreenDtl,
      tranansctionScreenHeadingList:
          tranansctionScreenHeadingList ?? this.tranansctionScreenHeadingList,
      transactionApprovalListview:
          transactionApprovalListview ?? this.transactionApprovalListview,
      model: model ?? this.model,
      notificationDetails: notificationDetails ?? this.notificationDetails,
      actionTypes: actionTypes ?? this.actionTypes,
      branchObjList: branchObjList ?? this.branchObjList,
      isTransReqAppvl: isTransReqAppvl ?? this.isTransReqAppvl,
      notificationModel: notificationModel ?? this.notificationModel,
      historyData: historyData ?? this.historyData,
      statusCode: statusCode ?? this.statusCode,
      branch: branch??this.branch,
      message: message??this.message,
      isAllBranchSelected: isAllBranchSelected??this.isAllBranchSelected,
      branchName: branchName??this.branchName,
      transactionUnblockRequestApprovalFailure: transactionUnblockRequestApprovalFailure ?? this.transactionUnblockRequestApprovalFailure,
      isTransReqAppvlNotification:
      isTransReqAppvlNotification ?? this.isTransReqAppvlNotification,

    );
  }

  factory TransactionUnblockReqApprlState.initial() {
    DateTime currentDate = DateTime.now();
    DateTime startDate = DateTime(currentDate.year, currentDate.month, 1);
    return TransactionUnblockReqApprlState(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      tranansctionScreenDtl: [],
      tranansctionScreenHeadingList: null,
      transactionApprovalListview: null,
      actionTypes: [],
      branchObjList: [],
      notificationDetails: [],
      unreadList: [],
      branch: 0,
      statusCode: 0,
      historyData: null,
      isTransReqAppvl: false,
      notificationModel: null,
      isTransReqAppvlNotification: false,
      message: "",
      isAllBranchSelected: false,
      transactionUnblockRequestApprovalFailure: false,
      apprlSavemodel:
          ApprovalSaveModel(approvedDate: DateTime.now(), remarks: ""),
      model: PVFilterModel(
          dateRange: DateTimeRange(
            start: startDate,
            end: currentDate,
          ),
          fromDate: startDate,
          toDate: currentDate,
          reqNo: "",
          transNo: ""),
    );
  }
}
