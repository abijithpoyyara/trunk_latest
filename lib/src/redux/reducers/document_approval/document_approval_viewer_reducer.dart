import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_action.dart';
import 'package:redstars/src/redux/actions/document_approval/document_approval_viewer_action.dart';
import 'package:redstars/src/redux/states/document_approval/document_approval_state.dart';

final documentApprViewerReducer = combineReducers<DocumentViewerState>([
  TypedReducer<DocumentViewerState, LoadingAction>(_changeLoadingStatusAction),
  TypedReducer<DocumentViewerState, AttachmentsFetchSuccessAction>(
      _attachmentsFetchSuccess),
  TypedReducer<DocumentViewerState, SetFilePathAction>(_changeFilePathAction),
]);

DocumentViewerState _changeLoadingStatusAction(
        DocumentViewerState state, LoadingAction action) {
  bool isScreen = action.type == DocumentApprovalAction.VIEWER_SCREEN;
  return state.copyWith(
      loadingStatus: isScreen ? action.status : state.loadingStatus,
      loadingMessage: isScreen ? action.message : state.loadingMessage,
      loadingError: isScreen ? action.message : state.loadingError);
}

DocumentViewerState _attachmentsFetchSuccess(
        DocumentViewerState state, AttachmentsFetchSuccessAction action) =>
    state.copyWith(
      attachments: action.attachments,
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
    );

DocumentViewerState _changeFilePathAction(
        DocumentViewerState state, SetFilePathAction action) =>
    state.copyWith(filePath: action.filePath);
