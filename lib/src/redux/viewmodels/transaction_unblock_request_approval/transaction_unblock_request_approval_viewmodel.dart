import 'dart:developer';

import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/actions/transaction_unblock_request_approval/transaction_unblock_request_approval_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/states/transaction_unblock_request_approval/transaction_unblock_request_approval_state.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_approval_action_types_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_approval_history_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_approval_mainscreen_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_list_head_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_list_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_unblock_notification_model.dart';
import 'package:redstars/src/widgets/screens/payment_voucher/model/filter_model.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/model/branch_model.dart';
import 'package:redstars/src/widgets/screens/transaction_unblock_request_approval/model/transaction_save_model.dart';

class TransactionUnblockReqApprlViewModel extends BaseViewModel {
  final List<TransactionUnblockReqApprlCountList> tranansctionScreenDetl;
  final TransactionUnblockListHead tranansctionScreenHeadingList;
  final TransactionUnblockListHead1 transactionApprovalListview;
  final Function(int rptFormatId, int id) getReportFormatHeaderDtl;
  final Function(PVFilterModel model) onFilter;
  final Function({int branchId, int optionId, int flg}) filterByBranch;
  final Function(int branchId,bool isAllBranchSelected,String branchName) changeBranch;
  final PVFilterModel model;
  final List<BranchesList> branchObjList;
  final List<HistoryModel> historyData;
  final int statusCode;
  final List<NotificationCountDetails> unreadCount;
  final List<UnreadNotificationListModel> unreadList;
  final Function(PVFilterModel result, int id, int reportFormatId, int optionId,
      bool isBranchBlocked, int branchId) listByFilter;
final Function() clearFilter;
  final Function(
      {int optionId,
int transTableId,
int transId,
      int notificationId,int branchId}) setNotificationAsReadFunction;
  final Function(
    int transId,
    int transTableId,
  ) onNotificationClick;
  final List<ActionTaken> actionTypes;
  final bool isTransReqAppvl;
  final bool isTransReqAppvlNotification;
  final String loginedUserName;

  final Function(
    DateTime approveddate,
    String docapprvlremarks,
    String docapprvlstatus,
    DateTime extendeddate,
    int Id,
    int reftableId,
    int reftableDataId,
  ) onSave;
  final Function(
    DateTime approveddate,
    String docapprvlremarks,
    String docapprvlstatus,
    DateTime extendeddate,
    int Id,
    int reftableId,
    int reftableDataId,
  ) onSaveFromNotification;
  final int optionId;
  final int optionId2;
  final int optionId3;
  final int idOption;
  final Function(ApprovalSaveModel) onApprvalModelSave;
  final Function() onTransactionApprlReqClearAction;
  final Function() onRefreshCountData;
  final Function({int branchId, bool allBranchYN}) fetchUnreadCountFunction;
  final TransactionUnblockNotificationModel notificationModel;
final Function({bool isBranchBlocked,int optionId,int branchId}) Refresh;
  final int branch;
//  final TransactionUnblockListView mapData;

  ///update
  String message;
  final bool transactionUnblockRequestApprovalFailure;
  VoidCallback resetTUApprovalFailure;
  bool isAllBranchSelected;
  String branchName;


  TransactionUnblockReqApprlViewModel({
    LoadingStatus loadingStatus,
    String loadingMessage,
    String errorMessage,
    this.Refresh,
    this.unreadList,
    this.setNotificationAsReadFunction,
    this.tranansctionScreenDetl,
    this.getReportFormatHeaderDtl,
    this.actionTypes,
    this.unreadCount,
    this.tranansctionScreenHeadingList,
    this.transactionApprovalListview,
    this.onFilter,
    this.model,
    this.fetchUnreadCountFunction,
    this.listByFilter,
    this.idOption,
    this.branchObjList,
    this.historyData,
    this.filterByBranch,
    this.onSave,
      this.onSaveFromNotification,
    this.clearFilter,
    this.optionId,
    this.optionId2,
    this.optionId3,
    this.onApprvalModelSave,
    this.isTransReqAppvl,
      this.isTransReqAppvlNotification,
    this.onTransactionApprlReqClearAction,
    this.onRefreshCountData,
    this.loginedUserName,
    this.notificationModel,
    this.onNotificationClick,
    this.statusCode,

    this.transactionUnblockRequestApprovalFailure,
    this.message,
    this.resetTUApprovalFailure,
    this.changeBranch,
    this.branch,
    this.isAllBranchSelected,
    this.branchName

//    this.mapData,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: errorMessage,
        );

  factory TransactionUnblockReqApprlViewModel.fromStore(Store<AppState> store) {
    TransactionUnblockReqApprlState state =
        store.state.transactionUnblockReqApprlState;
    int optionId = store.state.homeState.selectedOption?.optionId;
    int idOption =  store.state.homeState.selectedOption?.id;
    int optionId2;
    int optionId3;

    optionId2 = store.state.homeState.menuItems.indexWhere(
        (element) => element.title == "Transaction Unblock Request Approval");
    if (optionId2 != null && optionId2 > 0) {
      optionId3 = store.state.homeState.menuItems[optionId2].module.optionId;
    }
    String loginUser = store.state.homeState.user.userName;
    return TransactionUnblockReqApprlViewModel(
      loadingStatus: state.loadingStatus,
      errorMessage: state.loadingError,
      loadingMessage: state.loadingMessage,
      tranansctionScreenDetl: state.tranansctionScreenDtl,
      unreadCount: state.notificationDetails,
      unreadList: state.unreadList,
      tranansctionScreenHeadingList: state.tranansctionScreenHeadingList,
      transactionApprovalListview: state.transactionApprovalListview,
      actionTypes: state.actionTypes,
      branchObjList: state.branchObjList,
      historyData: state.historyData,
      statusCode: state.statusCode,
      optionId: optionId,
      idOption: idOption,
      optionId2: optionId2,
      optionId3: optionId3,
      branch: state.branch,
      branchName: state.branchName,
      isAllBranchSelected: state.isAllBranchSelected,
      notificationModel: state.notificationModel,
      model: state.model,
      loginedUserName: loginUser,
      filterByBranch: ({branchId, optionId, flg}) {
        store.dispatch(fetchTransactionApprovalMainscreen(
          optionId: optionId,
          branchId: branchId,
          flg: 1,
        ));
      },
      fetchUnreadCountFunction: ({branchId, allBranchYN}) {
        store.dispatch(
            fetchUnreadCount(branchId2: branchId, allBranchYN: allBranchYN));
      },
      setNotificationAsReadFunction: (
          {int optionId, int transTableId, int transId, int notificationId,int branchId}) {
        store.dispatch(setNotificationAsRead(
          optionId: optionId,
          transTableId: transTableId,
          transId: transId,
            notificationId: notificationId,
        branchId: branchId));
      },
      Refresh: ({bool isBranchBlocked,int optionId,int branchId}){
        if(isBranchBlocked==true){
          store.dispatch(
            fetchTransactionApprovalMainscreen(
                optionId: optionId, branchId:branchId),
          );
          store.dispatch(fetchUnreadCount());
        } else {
          fetchTransactionApprovalMainscreen(optionId: optionId);
          store.dispatch(fetchUnreadCount());
        }
        store.dispatch(fetchUnreadCount());
        store.dispatch(fetchActionTypes());
        store.dispatch(fetchFilterBranches());
      },
      clearFilter: (){
        store.dispatch(clearFilterAction());
      },
        changeBranch: (branch,isAllBranchSelected,branchName) {

          store.dispatch(ChangeBranchId(branch: branch,isAllBranchSelected: isAllBranchSelected,branchName: branchName));
        },
      onNotificationClick: (
        transId,
        transTaleId,
      ) {
        store.dispatch(fetchTransactionUnblockApprovalNotificationClickAction(
            optionId: optionId, transId: transId, transTableId: transTaleId));
      },
      getReportFormatHeaderDtl: (rptFormatId, id) {
        store.dispatch(
            fetchTransactionApprovalHeading(rptFormatId: rptFormatId));
        store.dispatch(
            fetchTransactionApprovalReqList(id: id, optionId: optionId3));
      },
      onApprvalModelSave: (saveModel) {
        store.dispatch(TransactionSaveModelAction(saveModel));
      },
      onTransactionApprlReqClearAction: () {
        store.dispatch(TransactionReqApplClearAction(isTransReqAppvl: false));
      },
      onFilter: (model) {
        store.dispatch(SavingPaymentFilterAction(filterModel: model));
      },
      onRefreshCountData: () {
        store.dispatch(fetchTransactionApprovalMainscreen(optionId: optionId3,branchId: state.branch,allBranch: state.isAllBranchSelected));
      },
      isTransReqAppvl: state.isTransReqAppvl,
        isTransReqAppvlNotification: state.isTransReqAppvlNotification,
      listByFilter: (result, id, reportFormatId, apprvlOptionId,
          isBranchBlocked, branchId) {
        // store.dispatch(fetchTransactionApprovalHeading(rptFormatId: reportFormatId));
        store.dispatch(fetchTransactionApprovalReqFilterList(
          isBranchBlocked: isBranchBlocked,
            id: id,
            branchId:branchId,
            optionId: apprvlOptionId,
            //683,
            //optionId,
            filterModel: PVFilterModel(
                fromDate: result?.fromDate ??
                    DateTime(DateTime.now().year, DateTime.now().month, 1),
                toDate: result?.toDate ?? DateTime.now(),
                reqNo: result?.reqNo,
                transNo: result?.transNo)));
      },
      onSave: (approveddate, docapprvlremarks, docapprvlstatus, extendeddate,
          Id, reftableId, reftableDataId) {
        store.dispatch(saveTransactionUnblockReqAppl(
            approveddate: approveddate,
            docapprvlremarks: docapprvlremarks,
            docapprvlstatus: docapprvlstatus,
            extendeddate: extendeddate,
            Id: Id,
            reftabledataid: reftableDataId,
            reftableid: reftableId));
      },
	  onSaveFromNotification: (approveddate, docapprvlremarks,
            docapprvlstatus, extendeddate, Id, reftableId, reftableDataId) {
          store.dispatch(saveTransactionUnblockReqApplFromNotification(
              approveddate: approveddate,
              docapprvlremarks: docapprvlremarks,
              docapprvlstatus: docapprvlstatus,
              extendeddate: extendeddate,
              Id: Id,
              reftabledataid: reftableDataId,
              reftableid: reftableId));
        },

      transactionUnblockRequestApprovalFailure: state.transactionUnblockRequestApprovalFailure,
      message: state.message,
      resetTUApprovalFailure: (){
        store.dispatch(TransactionUnblockRequestApprovalFailureAction(TURequestApprovalFailure: false));
      }
    );
  }
}
