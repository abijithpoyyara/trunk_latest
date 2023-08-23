import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_viewer_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/redux/states/document_approval/document_approval_state.dart';
import 'package:redstars/src/services/model/response/document_approval/document_attachments.dart';
import 'package:redstars/src/services/model/response/document_approval/pending_approvals.dart';

class DocumentApprViewerViewModel extends BaseViewModel {
  final Function(TransactionDetails transaction) onViewDocuments;
  final List<Attachments> attachments;
  final Function() attchDoc;

  final String filePath;

  DocumentApprViewerViewModel({
    this.onViewDocuments,
    this.attachments,
    this.filePath,
    this.attchDoc,
    LoadingStatus loadingStatus,
    String loadingMessage,
    String errorMessage,
  }) : super(
          loadingStatus: loadingStatus,
          loadingMessage: loadingMessage,
          loadingError: errorMessage,
        );

  factory DocumentApprViewerViewModel.fromStore(Store<AppState> store) {
    DocumentViewerState state = store.state.docApprovalState.viewerState;

    return DocumentApprViewerViewModel(
      attachments: state.attachments,
      loadingStatus: state.loadingStatus,
      loadingMessage: state.loadingMessage,
      errorMessage: state.loadingError,
      filePath: state.filePath,
      attchDoc: () {
        print("cslled1234");
        return store.dispatch(InitFilePathAction(
            hasTokenCallback: (path) =>
                store.dispatch(SetFilePathAction(filePath: path))));
      },
      onViewDocuments: (transaction) =>
          store.dispatch(fetchDocumentAttachments(transaction)),
    );
  }
}
