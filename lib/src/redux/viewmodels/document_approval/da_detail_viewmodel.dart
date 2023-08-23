import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_detail_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/states/document_approval/document_approval_state.dart';
import 'package:redstars/src/services/model/response/document_approval/branch_list.dart';
import 'package:redstars/src/services/model/response/document_approval/document_approval_init_model.dart';
import 'package:redstars/src/services/model/response/document_approval/document_report_model.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_approvals.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_transaction_dtl.dart';
import 'package:redstars/src/utils/app_dates.dart';
import 'package:redstars/src/widgets/screens/company_listing_screen/company_detail_listing.dart';
import 'package:redstars/src/widgets/screens/document_approval/_model/document_approval_model.dart';

class DocumentApprDetailViewModel extends BaseViewModel {
  final TransactionTypes transaction;
  final List<DocumentConfigDtl> documentConfigDtl;
  final List<TransactionDetails> transactionDtl;
  final List<TransactionDetails> transList;
  final List<TransactionDtlApproval> transactionApprDTL;
  ///
  final bool isTransactionSubmitted;
  final bool isMultiTransactionSubmitted;
  ///
  final bool isSummaryApproval;
  final List<ApprovalsTypes> approvalTypes;
  final TransactionTypes selectedOption;
  final List<UnreadNotificationListModel> unreadList;
  final Function({
    TransactionTypes transactionType,
    int notificationId,
    int branchId,
  }) refreshPendingList;
  final Function(TransactionDetails) addTrans;
  final Function(TransactionDetails trans) addTransList;
  final Function(TransactionDetails trans) removeTransList;
  final VoidCallback onClear;
  final Function() clearState;
  final Function({
    int notificationId,
    int subtypeId,
    int branchId
  }) fetchUnreadList;
  final Function(bool) selectAllFunc;
  final bool selectAll;
  final Future<void> Function() refreshList;
  final Function(DocumentApprovalModel approvalModel) submitDocument;
  final Function(
      List<DocumentApprovalModel> approvalModel,
      DocumentApprDetailViewModel viewModel,
      ApprovalsTypes approvalsTypes,
      List<ApprovalsTypes> approvalsTypesList,
      int userApprSts,
      DocumentApprovalModel saveModel,
      List<TransactionDtlApproval> selectionReportData,
      int subtypeId) msubmitDocument;
  final Function(
      {int optionId,
      int transTableId,
      int transId,
      int notificationId,
      int subtypeId,
      int branchId}) setNotificationAsReadFunction;
  final Function() callWhenApprovedFunction;
  final ReportFormatModel reportSummaryFormat;
  final ReportFormatModel reportDtlFormat;
  final String tableName;
  final String transactionDtlTableName;
  final int optionId;
  final int refOptionId;
  final int statusCode;
  int useractionid;

  ///update
  String message;
  final bool documentApprovalFailure;
  VoidCallback resetDocumentApprovalFailure;

  DocumentApprDetailViewModel(
      {LoadingStatus loadingStatus,
      String loadingMessage,
      String errorMessage,
      this.msubmitDocument,
      this.statusCode,
      this.tableName,
      this.fetchUnreadList,
      this.setNotificationAsReadFunction,
      this.transactionDtlTableName,
      this.optionId,
      this.transaction,
      this.transactionDtl,
      this.unreadList,
      this.transList,
      this.removeTransList,
      this.addTransList,
      this.addTrans,
      this.isMultiTransactionSubmitted,
      this.isTransactionSubmitted,
      this.isSummaryApproval,
      this.refreshPendingList,
      this.onClear,
      this.clearState,
      this.refreshList,
      this.selectedOption,
      this.reportSummaryFormat,
      this.reportDtlFormat,
      this.transactionApprDTL,
      this.callWhenApprovedFunction,
      this.approvalTypes,
      this.documentConfigDtl,
      this.refOptionId,
      this.useractionid,
      this.selectAll,
      this.selectAllFunc,
      this.submitDocument,
      ///update
      this.message,
      this.documentApprovalFailure,
      this.resetDocumentApprovalFailure})
      : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: errorMessage,
        );

  factory DocumentApprDetailViewModel.fromStore(Store<AppState> store) {
    DADetailState state = store.state.docApprovalState.detailState;

    return DocumentApprDetailViewModel(
      optionId: store?.state?.homeState?.selectedOption?.optionId ?? 1,
      loadingStatus: state.loadingStatus,
      errorMessage: state.loadingError,
      loadingMessage: state.loadingMessage,
      transaction: state.selectedOption,
      transactionDtl: state.transactionDtl,
      transList: state.transList,
      unreadList: state.unreadList,
      approvalTypes: state.approvalTypes,
      selectedOption: state.selectedOption,
      refOptionId: state.refOptionId,
      statusCode: state.statusCode,
      isTransactionSubmitted: state.documentSave,
      isMultiTransactionSubmitted: state.multiDocumentSave,
      reportSummaryFormat: state.reportSummaryFormat,
      reportDtlFormat: state.reportDtlFormat,
      isSummaryApproval: state.isSummaryApproval,
      transactionApprDTL: state.transactionApprDTL,
      documentConfigDtl: state.documentConfigDtl,
      selectAll: state.selectAll,
      ///update
      message: state.message,
      documentApprovalFailure: state.documentApprovalFailure,
      removeTransList: (transactionListData) {
        store.dispatch(RemoveTrans(transactionListData));
      },
      setNotificationAsReadFunction: (
          {optionId, transTableId, transId, notificationId, subtypeId,branchId}) {
        store.dispatch(setNotificationAsRead(
            branchId: branchId,
            optionId: optionId,
            transTableId: transTableId,
            transId: transId,
            notificationId: notificationId,
            subtypeId: subtypeId));
      },
      callWhenApprovedFunction: () {
        store.dispatch(callWhenApproved());
      },
      fetchUnreadList: ({notificationId, subtypeId,branchId}) {
        store.dispatch(fetchUnreadNotificationList(
            notificationId: notificationId, subtypeId: subtypeId,branchId: branchId));
      },
      // refreshList: () => store.dispatch(fetchInitialList()),
      addTrans: (tran) => store.dispatch(AddTrans(tran)),
      // addTransList: ({trans}) => store.dispatch(AddTransList(trans: trans)),
      // selectAllFunc: (selected) => store.dispatch(SelectAll(selected)),

      msubmitDocument: (data, viewModel, approvalsTypes, approvalsTypesList,
          userApprSts, saveModel, selectionReportData, subtypeId) {
        store.dispatch(multiSaveDocumentApproval(
          approvalModel: saveModel,
          inputModel: data,
          selectionReportData: selectionReportData,
          viewModel: viewModel,
          userApprSts: userApprSts,
          subTypeId: subtypeId,
          approvalsTypes: approvalsTypes,
          approvalsTypesList: approvalsTypesList,
        ));
      },
      tableName: state.tableName,
      transactionDtlTableName: state.transactionDtlTableName,
      refreshPendingList: ({transactionType, notificationId, branchId}) =>
          store.dispatch(fetchPendingDocuments(
        transactionType: transactionType,
        branchId: branchId,
        subtypeId: transactionType.subTypeId,
        optionId: transactionType.optionId,
        notificationId: notificationId,
      )),
      submitDocument: (document) =>
          store.dispatch(saveDocumentApproval(inputModel: document)),
      resetDocumentApprovalFailure: (){
        store.dispatch(DocumentApproveFailureAction(documentApprovalFailure: false));
      },
      onClear: () => store.dispatch(OnUpdateSuccessAction()),
      clearState: () => store.dispatch(ClearStateAction(multiDocumentSave: false,documentSave: false)),
    );
  }

  ApprovalsTypes getApprovalType(int id) {
    ApprovalsTypes type;
    approvalTypes.forEach((element) {
      if (element.id == id) {
        type = element;
        return;
      }
    });
    return type;
  }

  DocumentConfigDtl getDocConfigByType({int bccId, int approveorrejectid}) {
    return documentConfigDtl?.firstWhere((element) {
      return element.levelNoBccid == bccId &&
          element.approvalRejectionBccId == approveorrejectid;
    }, orElse: () => null);
  }

  void approveDocument(
      {DocumentApprovalModel approvalModel,
      TransactionDetails transactionDtl,
      int approvalStsId,
      ApprovalsTypes approvalsTypes,
      int subtypeId,
      ReportFormatModel reportFormatModel,
      List<TransactionDtlApproval> dtlAppvl,
      List<Map<String, dynamic>> dtlApprovals}) {
    int maxlevelid = transactionDtl.maxLevelId;

    List<Map<String, dynamic>> jsonApprovalAry;

    ApprovalsTypes userApprovalStatus = getApprovalType(approvalStsId);
    DocumentConfigDtl docConfigDtl = getDocConfigByType(
        bccId: maxlevelid, approveorrejectid: userApprovalStatus.id);

    int lastapprovallevelbccid = transactionDtl.maxLevelId;
    int lastapprovallevelminipersontoapprove;

    ApprovalsTypes approvalRec = null;
    ApprovalsTypes rejectionRec = null;

    approvalTypes.forEach((element) {
      if (element.code == "APPROVED") {
        approvalRec = element;
      } else if (element.code == "REJECTED") rejectionRec = element;
    });
    if ((lastapprovallevelbccid == docConfigDtl?.levelNoBccid)) {
      lastapprovallevelminipersontoapprove = docConfigDtl.minPersonToApprove;
    }

    int userapprovalbccid = approvalRec != null ? approvalRec.id : null;
    int userrejectionbccid = rejectionRec != null ? rejectionRec.id : null;

    int minimumpersonstoapproveorreject =
        transactionDtl.levelTypeBccId == docConfigDtl?.levelNoBccid
            ? docConfigDtl.minPersonToApprove
            : 0;

    approvalModel.id = 0;
    approvalModel.subtypeId = subtypeId;
    approvalModel.isCancelled = "N";
    approvalModel.recordStatus = 'A';
    approvalModel.statusDate =
        AppDates(DateTime.now()).customFormat(format: "dd-mm-yyyy");
    approvalModel.optionId = optionId;

    approvalModel.refTableId = transactionDtl.refTableId;
    approvalModel.refTableDataId = transactionDtl.refTableDataId;
    approvalModel.levelNo = transactionDtl.levelTypeBccId;
    approvalModel.levelTypeBccid = transactionDtl.levelTypeBccId;
    approvalModel.transLastModDate = transactionDtl.transLastModDate;

    approvalModel.userActionBccId = userApprovalStatus.id;
    approvalModel.userRejectionBccId = userrejectionbccid;
    approvalModel.userApprovalBccId = userapprovalbccid;
    approvalModel.minimumPersonstoApproveorReject =
        minimumpersonstoapproveorreject;
    approvalModel.lastApprovalLevelBccId = lastapprovallevelbccid;
    approvalModel.lastApprovalLevelminiPersontoApprove =
        lastapprovallevelminipersontoapprove;

    approvalModel.tableName = tableName;
    approvalModel.dtlTableName = null;

    // transactionDtlTableName;
    approvalModel.refOptionId = refOptionId;

    approvalModel.dtlApprovals = dtlApprovals;
    approvalModel.emailOnApproval = selectedOption.emailOnApproval;
    approvalModel.smsOnApproval = selectedOption.smsOnApproval;

    submitDocument(approvalModel);
  }

  void multiApproveDocument(
      {DocumentApprDetailViewModel viewModel,
      DocumentApprovalModel approvalModel,
      TransactionDetails transactionDtl,
      int approvalStsId,
      int userApprSts,
      ApprovalsTypes approvalsTypes,
      List<ApprovalsTypes> approvalsTypesList,
      ReportFormatModel reportFormatModel,
      ReportFormatDtlModel editableColumn,
      List<TransactionDtlApproval> dtlAppvl,
      List<Map<String, dynamic>> dtlApprovals,
      List<TransactionDtlApproval> selectionReportData,
      int subTypeId,
      int subtypeId}) {
    print("list length---${transList.length}");
    List<DocumentApprovalModel> approvalmodeldatas = [];
    for (int i = 0; i < transList.length; i++) {
      print("${transList[i].transNo}");
      int maxlevelid = transList[i].maxLevelId;
      List<Map<String, dynamic>> jsonApprovalAry;

      ApprovalsTypes userApprovalStatus = getApprovalType(approvalStsId);
      DocumentConfigDtl docConfigDtl = getDocConfigByType(
        bccId: maxlevelid,
        approveorrejectid: userApprovalStatus.id,
      );

      int userApprSts = userApprovalStatus.id;

      int lastapprovallevelbccid = transList[i].maxLevelId;
      int lastapprovallevelminipersontoapprove;

      ApprovalsTypes approvalRec = null;
      ApprovalsTypes rejectionRec = null;

      approvalTypes.forEach((element) {
        if (element.code == "APPROVED") {
          approvalRec = element;
        } else if (element.code == "REJECTED") rejectionRec = element;
      });

      if ((lastapprovallevelbccid == docConfigDtl?.levelNoBccid)) {
        lastapprovallevelminipersontoapprove = docConfigDtl.minPersonToApprove;
      }

      int userapprovalbccid = approvalRec != null ? approvalRec.id : null;
      int userrejectionbccid = rejectionRec != null ? rejectionRec.id : null;

      int minimumpersonstoapproveorreject =
          transList[i].levelTypeBccId == docConfigDtl?.levelNoBccid
              ? docConfigDtl.minPersonToApprove
              : 0;

      // bool hasSelection = false;
      //
      // final mappedList = dtlAppvl.map((data) {
      //   Map<String, dynamic> _kMap = Map();
      //   hasSelection = hasSelection || data.selected;
      //   _kMap["table"] = data.table;
      //   _kMap["dtldataid"] = data.dtlDataId;
      //   _kMap["appyn"] = data.selected;
      //   _kMap["editcol"] = editableColumn?.dataIndex ?? "";
      //   if (editableColumn != null) {
      //     _kMap["editcolval"] = data.data[editableColumn.dataIndex];
      //   }
      //   return _kMap;
      // }).toList();
      //
      // hasSelection ? mappedList : null;

      approvalModel.id = 0;
      approvalModel.subtypeId = subTypeId;
      approvalModel.isCancelled = "N";
      approvalModel.recordStatus = 'A';
      approvalModel.statusDate =
          AppDates(DateTime.now()).customFormat(format: "dd-mm-yyyy");
      approvalModel.optionId = optionId;
      approvalModel.refTableId = transList[i].refTableId;
      approvalModel.refTableDataId = transList[i].refTableDataId;
      approvalModel.levelNo = transList[i].levelTypeBccId;
      approvalModel.levelTypeBccid = transList[i].levelTypeBccId;
      approvalModel.transLastModDate = transList[i].transLastModDate;

      approvalModel.userActionBccId = userApprovalStatus.id;
      approvalModel.userRejectionBccId = userrejectionbccid;
      approvalModel.userApprovalBccId = userapprovalbccid;
      approvalModel.minimumPersonstoApproveorReject =
          minimumpersonstoapproveorreject;
      approvalModel.lastApprovalLevelBccId = lastapprovallevelbccid;
      approvalModel.lastApprovalLevelminiPersontoApprove =
          lastapprovallevelminipersontoapprove;

      approvalModel.tableName = tableName;
      approvalModel.dtlTableName = transactionDtlTableName;
      approvalModel.refOptionId = refOptionId;

      approvalModel.dtlApprovals = dtlApprovals;
      approvalModel.emailOnApproval = selectedOption.emailOnApproval;
      approvalModel.smsOnApproval = selectedOption.smsOnApproval;

      approvalmodeldatas.add(approvalModel);
      print(approvalmodeldatas.length);
    }

    msubmitDocument(
        approvalmodeldatas,
        viewModel,
        approvalsTypes,
        approvalsTypesList,
        userApprSts,
        approvalModel,
        selectionReportData,
        subTypeId);
  }
}
