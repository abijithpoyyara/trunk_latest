import 'package:base/redux.dart';
import 'package:redstars/src/services/model/response/document_approval/document_attachments.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_approvals.dart';
import 'package:redstars/src/services/repository/document_approval/document_approval_repository.dart';

import 'document_approval_action.dart';

class AttachmentsFetchSuccessAction {
  List<Attachments> attachments;

  AttachmentsFetchSuccessAction(this.attachments);
}

ThunkAction fetchDocumentAttachments(TransactionDetails transaction) {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
          status: LoadingStatus.loading,
          message: "Getting Transations",
          type: DocumentApprovalAction.VIEWER_SCREEN));
      DocumentApprovalRepository().getAttachments(
          optionId: transaction.optionId,
          tableId: transaction.refTableId,
          transactionId: transaction.refTableDataId,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error,
              message: exception.toString(),
              type: DocumentApprovalAction.VIEWER_SCREEN)),
          onRequestSuccess: (response) =>
              store.dispatch(AttachmentsFetchSuccessAction(response)));
    });
  };
}
