import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/services/model/response/document_approval/branch_list.dart';
import 'package:redstars/src/services/model/response/document_approval/document_approval_init_model.dart';
import 'package:redstars/src/services/model/response/document_approval/document_attachments.dart';
import 'package:redstars/src/services/model/response/document_approval/document_report_model.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_approvals.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_transaction_dtl.dart';
import 'package:redstars/src/services/model/response/document_approval/transaction_history.dart';
import 'package:redstars/utility.dart';

@immutable
class DocumentApprovalState {
  final DASummaryState summaryState;
  final DADetailState detailState;
  final DAHistoryState historyState;
  final DocumentViewerState viewerState;

  DocumentApprovalState({
    this.summaryState,
    this.detailState,
    this.historyState,
    this.viewerState,
  });

  DocumentApprovalState copyWith({
    DASummaryState summaryState,
    DADetailState detailState,
    DAHistoryState historyState,
    DocumentViewerState viewerState,
  }) {
    return DocumentApprovalState(
      summaryState: summaryState ?? this.summaryState,
      detailState: detailState ?? this.detailState,
      historyState: historyState ?? this.historyState,
      viewerState: viewerState ?? this.viewerState,
    );
  }

  factory DocumentApprovalState.initial() {
    return DocumentApprovalState(
      summaryState: DASummaryState.initial(),
      detailState: DADetailState.initial(),
      historyState: DAHistoryState.initial(),
      viewerState: DocumentViewerState.initial(),
    );
  }
}

@immutable
class DASummaryState extends BaseState {
  final bool isSuperUser;
  final List<TransactionTypes> transactionTypeList;
  final TransactionTypes selectedOption;
  final List<ApprovalsTypes> approvalTypes;
  final List<BranchList> branchList;
  final BranchListModel branchListModel;
  final BranchList selectedBranch;
  final List<NotificationCountDetails> notificationDetails;
  final int statusCode;

  ///
  int branchId;

  DASummaryState({
    LoadingStatus loadingStatus,
      String loadingError,
      String loadingMessage,
      this.approvalTypes,
      this.transactionTypeList,
      this.isSuperUser,
      this.branchList,
      this.branchListModel,
      this.selectedBranch,
      this.selectedOption,
      this.notificationDetails,
    this.statusCode,
    this.branchId
  }) : super(
            loadingStatus: loadingStatus,
            loadingError: loadingError,
            loadingMessage: loadingMessage);

  DASummaryState copyWith(
      {LoadingStatus loadingStatus,
      String loadingError,
      String loadingMessage,
      List<TransactionTypes> transactionTypes,
      List<BranchList> branchList,
      BranchList selectedBranch,
      BranchListModel branchListModel,
      bool isSuperUser,
      List<ApprovalsTypes> approvalTypeList,
      TransactionTypes selectedOption,
      List<NotificationCountDetails> notificationDetails,
      int statusCode,
        int branchId

      }) {
    return DASummaryState(
        loadingStatus: loadingStatus ?? this.loadingStatus,
        loadingError: loadingError ?? this.loadingError,
        loadingMessage: loadingMessage ?? this.loadingMessage,
        selectedOption: selectedOption ?? this.selectedOption,
        approvalTypes: approvalTypeList ?? this.approvalTypes,
        branchList: branchList ?? this.branchList,
        selectedBranch: selectedBranch ?? this.selectedBranch,
        branchListModel: branchListModel ?? this.branchListModel,
        isSuperUser: isSuperUser ?? this.isSuperUser,
      statusCode: statusCode ?? this.statusCode,
        transactionTypeList: transactionTypes ?? this.transactionTypeList,
      notificationDetails: notificationDetails ?? this.notificationDetails,
      branchId:branchId??this.branchId
    );
  }

  factory DASummaryState.initial() {
    return DASummaryState(
      loadingStatus: LoadingStatus.success,
      loadingError: "",
      loadingMessage: "",
      selectedBranch: null,
      transactionTypeList: null,
      selectedOption: null,
      approvalTypes: null,
      isSuperUser: false,
      statusCode: 0,
      branchListModel: null,
      notificationDetails: null,
      branchId: null,
      branchList: List(),
    );
  }
}

@immutable
class DADetailState extends BaseState {
  final ReportFormatModel reportDtlFormat;
  final ReportFormatModel reportSummaryFormat;
  final TransactionTypes selectedOption;
  final bool multiDocumentSave;
  final bool documentSave;
  final bool selectAll;
  final List<TransactionDtlApproval> transactionApprDTL;
  final List<ApprovalsTypes> approvalTypes;

  final List<DocumentConfigDtl> documentConfigDtl;
  final String tableName;
  final String transactionDtlTableName;

  final List<TransactionDetails> transactionDtl;
  final List<TransactionDetails> transList;
  final List<UnreadNotificationListModel> unreadList;
  final TransactionDetails selectedTransactionDetails;
  final bool isSummaryApproval;

  final int refOptionId;
  final int useractionid;
  final bool isMultiTransactionSubmitted;
  final int statusCode;
  ///update
  String message;
  bool documentApprovalFailure;

  DADetailState({
    this.reportDtlFormat,
    this.reportSummaryFormat,
    this.isMultiTransactionSubmitted,
    this.selectedOption,
    this.transactionDtl,
    this.transList,
    this.unreadList,
    this.selectedTransactionDetails,
    this.isSummaryApproval,
    this.multiDocumentSave,
    this.documentSave,
    this.selectAll,
    this.transactionApprDTL,
    this.documentConfigDtl,
    this.tableName,
    this.useractionid,
    this.transactionDtlTableName,
    this.approvalTypes,
    this.statusCode,
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    this.refOptionId,
    ///update
    this.message,
    this.documentApprovalFailure
  }) : super(
            loadingStatus: loadingStatus,
            loadingError: loadingError,
            loadingMessage: loadingMessage);

  DADetailState copyWith(
      {LoadingStatus loadingStatus,
      String loadingError,
      String loadingMessage,
      TransactionTypes selectedOption,
      bool documentSave,
      bool selectAll,
      PendingItems pendingList,
      int statusCode,
      List<TransactionDtlApproval> transactionApprDTL,
      List<TransactionDetails> transactionDtl,
      List<TransactionDetails> transList,
      List<UnreadNotificationListModel> unreadList,
      bool isSummaryApproval,
      ReportFormatModel reportDtlFormat,
      ReportFormatModel reportSummaryFormat,
      List<ApprovalsTypes> approvalTypes,
      bool onNewOption = false,
      bool multiDocumentSave,
      bool isMultiTransactionSubmitted,
        ///update
      String message,
      bool documentApprovalFailure}) {
    return DADetailState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingError: loadingError ?? this.loadingError,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      documentSave: documentSave ?? this.documentSave,
      selectAll: selectAll ?? this.selectAll,
      unreadList: unreadList ?? this.unreadList,
      multiDocumentSave: multiDocumentSave ?? this.multiDocumentSave,
      transactionApprDTL: transactionApprDTL ?? this.transactionApprDTL,
      isMultiTransactionSubmitted:
          isMultiTransactionSubmitted ?? this.isMultiTransactionSubmitted,
      documentConfigDtl: onNewOption
          ? pendingList?.documentConfigDtl
          : pendingList?.documentConfigDtl ?? this.documentConfigDtl,
      tableName: onNewOption
          ? pendingList?.tableName
          : pendingList?.tableName ?? this.tableName,
      transactionDtlTableName: onNewOption
          ? pendingList?.transactionDtlTableName
          : pendingList?.transactionDtlTableName ??
              this.transactionDtlTableName,
      refOptionId: onNewOption
          ? pendingList?.optionId
          : pendingList?.optionId ?? this.refOptionId,
      transactionDtl: transactionDtl ?? this.transactionDtl,
      transList: transList ?? this.transList,
        selectedOption: onNewOption
            ? selectedOption
            : selectedOption ?? this.selectedOption,
      isSummaryApproval: onNewOption
          ? isSummaryApproval
          : isSummaryApproval ?? this.isSummaryApproval,
      reportDtlFormat: onNewOption
          ? reportDtlFormat
          : reportDtlFormat ?? this.reportDtlFormat,
      reportSummaryFormat: onNewOption
          ? reportSummaryFormat
          : reportSummaryFormat ?? this.reportSummaryFormat,
      approvalTypes:
          onNewOption ? approvalTypes : approvalTypes ?? this.approvalTypes,
	  statusCode: statusCode ?? this.statusCode,
      ///update
      message: message??this.message,
      documentApprovalFailure: documentApprovalFailure ??this.documentApprovalFailure

    );
  }

  factory DADetailState.initial() {
    return new DADetailState(
        loadingStatus: LoadingStatus.success,
        loadingError: "",
        loadingMessage: "",
        documentConfigDtl: null,
        statusCode: 0,
        tableName: null,
        transactionDtlTableName: null,
        selectedOption: null,
        transList: [],
        unreadList: [],
        documentSave: false,
        selectAll: false,
        refOptionId: null,
        multiDocumentSave: false,
        isMultiTransactionSubmitted: false,
        ///update
        documentApprovalFailure: false,
        message: ""
    );
  }
}

@immutable
class DAHistoryState extends BaseState {
  final TransactionDetails transaction;
  final Map<int, List<AppTreeModel>> transactionStatus;
  final List<TransactionApprovalList> transactionApprovals;
  final List<TransactionHistoryList> transactionHistories;

  DAHistoryState({
    this.transaction,
    this.transactionStatus,
    this.transactionApprovals,
    this.transactionHistories,
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
  }) : super(
            loadingStatus: loadingStatus,
            loadingError: loadingError,
            loadingMessage: loadingMessage);

  DAHistoryState copyWith({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    List<TransactionTypes> transactionTypeList,
    TransactionTypes selectedOption,
    TransactionDetails transaction,
    Map<int, List<AppTreeModel>> transactionStatus,
    List<TransactionApprovalList> transactionApprovals,
    List<TransactionHistoryList> transactionHistories,
  }) {
    return DAHistoryState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingError: loadingError ?? this.loadingError,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      transaction: transaction ?? this.transaction,
      transactionStatus: transactionStatus ?? this.transactionStatus,
      transactionApprovals: transactionApprovals ?? this.transactionApprovals,
      transactionHistories: transactionHistories ?? this.transactionHistories,
    );
  }

  factory DAHistoryState.initial() {
    return new DAHistoryState(
      loadingStatus: LoadingStatus.success,
      loadingError: "",
      loadingMessage: "",
      transactionApprovals: List(),
      transactionHistories: List(),
      transactionStatus: null,
    );
  }
}

@immutable
class DocumentViewerState extends BaseState {
  final List<Attachments> attachments;
  final String filePath;

  DocumentViewerState({
    this.attachments,
    this.filePath,
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
  }) : super(
            loadingStatus: loadingStatus,
            loadingError: loadingError,
            loadingMessage: loadingMessage);

  DocumentViewerState copyWith(
      {LoadingStatus loadingStatus,
      String loadingError,
      String loadingMessage,
      List<Attachments> attachments,
      String filePath}) {
    return DocumentViewerState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingError: loadingError ?? this.loadingError,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      attachments: attachments ?? this.attachments,
      filePath: filePath ?? this.filePath,
    );
  }

  factory DocumentViewerState.initial() {
    return new DocumentViewerState(
      loadingStatus: LoadingStatus.success,
      filePath: "",
      loadingError: "",
      loadingMessage: "",
      attachments: [],
    );
  }
}
