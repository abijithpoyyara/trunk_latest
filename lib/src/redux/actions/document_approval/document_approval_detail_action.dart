import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:redstars/src/redux/viewmodels/document_approval/da_detail_viewmodel.dart';
import 'package:redstars/src/services/model/response/document_approval/branch_list.dart';
import 'package:redstars/src/services/model/response/document_approval/document_approval_init_model.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_approvals.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_transaction_dtl.dart';
import 'package:redstars/src/services/repository/document_approval/document_approval_repository.dart';
import 'package:redstars/src/widgets/screens/document_approval/_model/document_approval_model.dart';
import 'package:redstars/src/widgets/screens/document_approval/_partials/document_approval_list_item.dart';

import 'document_approval_action.dart';

class PendingListFetchSuccessAction {
  final PendingItems documentResponse;
  final String documentTypeKey;
  final int statusCode;

  PendingListFetchSuccessAction(
      {this.documentResponse, this.documentTypeKey, this.statusCode});
}

///update...

class DocumentSubmissionSuccessAction {
  bool documentSave;
  DocumentSubmissionSuccessAction({this.documentSave});
}


class DocumentApproveFailureAction {
  String message;
  bool documentApprovalFailure;
  DocumentApproveFailureAction({this.message,this.documentApprovalFailure});
}

///
class MultiDocumentSubmissionSuccessAction {
  bool multiDocumentSave;
  MultiDocumentSubmissionSuccessAction({this.multiDocumentSave});
}

class ClearStateAction {
  bool multiDocumentSave;
  bool documentSave;
  ClearStateAction({this.multiDocumentSave,this.documentSave});
}

class OnDispose {
  OnDispose();
}
class OnDisposeDetails {
  OnDisposeDetails();
}

class OnUpdateSuccessAction {
  OnUpdateSuccessAction();
}

class TransactionDetailsFetchSuccessAction {
  List<TransactionDtlApproval> documentResponse;

  TransactionDetailsFetchSuccessAction(this.documentResponse);
}

class AddTransList {
  List<TransactionDetails> transList;
  AddTransList(this.transList);
}

class AddTrans {
  TransactionDetails trans;
  AddTrans(this.trans);
}

class RemoveTrans {
  TransactionDetails trans;
  RemoveTrans(this.trans);
}

class GetUnreadNotificationList {
  List<UnreadNotificationListModel> unreadList;
  GetUnreadNotificationList(this.unreadList);
}

ThunkAction fetchDocumentDetails(
    {TransactionTypes transactionType, TransactionDetails transactionDetails}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
          status: LoadingStatus.loading,
          message: "Loading List",
          type: DocumentApprovalAction.DETAIL_SCREEN));
      DocumentApprovalRepository().getTransactionDetails(
        optionId: transactionDetails?.optionId,
        procName: transactionType?.reportDtlFormat?.procedurename,
        actionFlag: transactionType?.reportDtlFormat?.actionflg,
        subActionFlag: transactionType?.reportDtlFormat?.subflag,
        transactionId: transactionDetails.refTableDataId,
        onRequestSuccess: (pendingDtl) => store
            .dispatch(new TransactionDetailsFetchSuccessAction(pendingDtl)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
            status: LoadingStatus.error,
            message: error.toString(),
            type: DocumentApprovalAction.DETAIL_SCREEN)),
      );
    });
  };
}

ThunkAction setNotificationAsRead(
    {var optionId,
    var transTableId,
    var transId,
    var notificationId,
      int branchId,
    var subtypeId}) {
  return (Store store) async {
    new Future(() async {
      // store.dispatch(new LoadingAction(
      //   status: LoadingStatus.loading,
      //   message: "Loading List",
      // ));
      DocumentApprovalRepository().setNotificationAsRead(
        selectedBranchId: branchId,
          optionId: optionId,
          transId: transId,
          transTableId: transTableId,
          subtypeId: subtypeId,
          notificationId: notificationId,
          onRequestSuccess: () => print("Notification Seen"),
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
              )));
    });
  };
}

ThunkAction callWhenApproved() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading List",
      ));
      DocumentApprovalRepository().callWhenApproved(
          onRequestSuccess: () => print("Call When Approved"),
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
                status: LoadingStatus.error,
                message: exception.toString(),
              )));
    });
  };
}

ThunkAction saveDocumentApproval({
  DocumentApprovalModel inputModel,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
          status: LoadingStatus.loading,
          message: "Please Wait",
          type: DocumentApprovalAction.DETAIL_SCREEN));
      DocumentApprovalRepository().saveDocuments(
          approvalModel: inputModel,
          onRequestSuccess: () {
            store.dispatch(new DocumentSubmissionSuccessAction(documentSave: true));
          },
          onRequestFailure: (error) {
            // store.dispatch(new LoadingAction(
            //   status: LoadingStatus.error,
            //   message: error.toString(),
            //   type: DocumentApprovalAction.DETAIL_SCREEN));

            ///update

            store.dispatch(DocumentApproveFailureAction(message:error.toString(),documentApprovalFailure: true));

          });
    });
  };
}

ThunkAction multiSaveDocumentApproval({
  List<DocumentApprovalModel> inputModel,
  DocumentApprovalModel approvalModel,
  DocumentApprDetailViewModel viewModel,
  List<TransactionDtlApproval> selectionReportData,
  ApprovalsTypes approvalsTypes,
  DocumentApprovalModel saveModel,
  int subTypeId,
  //List<TransactionDetails> transList,
  int optionId,
  int userApprSts,
  List<ApprovalsTypes> approvalsTypesList,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
          status: LoadingStatus.loading,
          message: approvalsTypes.code == "APPROVED"
              ? "Approving Documents"
              : "Rejecting Documents",
          type: DocumentApprovalAction.DETAIL_SCREEN));
      DocumentApprovalRepository().multiSaveDocuments(
          approvalModel: approvalModel,
          multiSaveModel: inputModel,
          selectionReportData: selectionReportData,
          transList: transList,
          viewModel: viewModel,
          subTypeId: subTypeId,
          userApprSts: userApprSts,
          approvalsTypesList: approvalsTypesList,
          approvalsTypes: approvalsTypes,
          onRequestSuccess: () {
            store.dispatch(new MultiDocumentSubmissionSuccessAction(multiDocumentSave: true));
          },
          onRequestFailure: (error) {
            store.dispatch(DocumentApproveFailureAction(message: error.toString(),documentApprovalFailure: true));
            // store.dispatch(new LoadingAction(
            //   status: LoadingStatus.error,
            //   message: error.toString(),
            //   type: DocumentApprovalAction.DETAIL_SCREEN));
          });
    });
  };
}

ThunkAction fetchPendingDocuments(
    {TransactionTypes transactionType,
    int branchId,
    int notificationId,
    int optionId,
    int subtypeId}) {
  return (Store store) async {
    new Future(() async {
      int optionId = store.state.homeState.selectedOption.optionId;
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading List",
      ));
      DocumentApprovalRepository().getPendingItemList(
        optionId: transactionType.optionId,
        branchId: branchId,
        subtypeId: transactionType.subTypeId,
        onRequestSuccess: (documentResponse, statusCode) => store.dispatch(
            PendingListFetchSuccessAction(
                documentResponse: documentResponse,
                documentTypeKey: transactionType.optionName,
                statusCode: statusCode)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
            status: LoadingStatus.error,
            message: error.toString(),
            type: DocumentApprovalAction.DETAIL_SCREEN)),
      );
      DocumentApprovalRepository().getUnreadList(
        selectedBranchId: branchId,
        optionId: optionId,
        subtypeId: transactionType.subTypeId,
        notificationId: transactionType.optionId,
        onRequestSuccess: (response) =>
            store.dispatch(GetUnreadNotificationList(response)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
            status: LoadingStatus.error, message: error.toString())),
      );
    });
  };
}

ThunkAction fetchUnreadNotificationList({int notificationId, int subtypeId,int branchId}) {
  return (Store store) async {
    new Future(() async {
      int optionId = store.state.homeState.selectedOption.optionId;
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Loading List",
      ));
      DocumentApprovalRepository().getUnreadList(
        selectedBranchId: branchId,
        optionId: optionId,
        notificationId: notificationId,
        subtypeId: subtypeId,
        onRequestSuccess: (response) =>
            store.dispatch(GetUnreadNotificationList(response)),
        onRequestFailure: (error) => store.dispatch(new LoadingAction(
            status: LoadingStatus.error, message: error.toString())),
      );
    });
  };
}
