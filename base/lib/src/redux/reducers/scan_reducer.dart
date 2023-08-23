import 'package:base/redux.dart';
import 'package:base/src/redux/actions/scan_actions.dart';
import 'package:base/src/redux/states/scan_state.dart';
import 'package:base/src/services/model/response/scanner_model.dart';
import 'package:base/src/widgets/screens/item_attachment/_model/item_attachment_model.dart';

final scanReducer = combineReducers<ScanState>([
  TypedReducer<ScanState, DocumentFetchAction>(_getDocumentTypeAction),
  TypedReducer<ScanState, ConfigFetchSuccessAction>(_getConfigurationSuccess),
  TypedReducer<ScanState, DocumentFetchSuccessAction>(_getDocumentSuccess),
  TypedReducer<ScanState, AddNewDocAction>(_addNewDocumentSuccess),
  TypedReducer<ScanState, LoadingAction>(_changeLoadingStatusAction),
  TypedReducer<ScanState, ValidateSaveAction>(_validateSaveAction),
  TypedReducer<ScanState, OnClearAction>(_clearState),
  TypedReducer<ScanState, AttachedItemEditAction>(_onAttachmentEdit),
  TypedReducer<ScanState, OptionSelectedAction>(_onOptionInitAction),
]);

ScanState _onOptionInitAction(ScanState state, OptionSelectedAction action) =>
    state.copyWith(optionDetail: action.option);

ScanState _onAttachmentEdit(ScanState state, AttachedItemEditAction action) =>
    state.copyWith(selectedAttachment: action.selectedAttachment);

ScanState _changeLoadingStatusAction(ScanState state, LoadingAction action) =>
    state.copyWith(
        loadingStatus: action.type == ScanOption.ItemAttachmentScreen
            ? action.status
            : state.loadingStatus,
        loadingMessage: action.type == ScanOption.ItemAttachmentScreen
            ? action.message
            : state.loadingMessage,
        error: action.type == ScanOption.ItemAttachmentScreen
            ? action.message
            : state.error);

ScanState _getDocumentTypeAction(ScanState state, DocumentFetchAction action) =>
    state.copyWith(
        loadingStatus: LoadingStatus.loading,
        error: "",
        loadingMessage: "Loading Document Types",
        documentTypes: List());

ScanState _clearState(ScanState state, OnClearAction action) {
  print("clearing state");
  return ScanState.initial();
}

ScanState _addNewDocumentSuccess(ScanState state, AddNewDocAction action) {
  List<ItemAttachmentModel> items = state.scannedDocuments;

  int position = items.indexOf(action.documents);
  print("position : $position");

  if (items.contains(action.documents)) {
    ItemAttachmentModel oldItem = items[items.indexOf(action.documents)];
    ItemAttachmentModel doc = oldItem.merge(action.documents);
    items.remove(doc);
    items.add(doc);
    return state.copyWith(
        loadingStatus: LoadingStatus.success, error: "", documents: items);
  } else {
    ItemAttachmentModel doc = action.documents;
    doc.mappingId = items.length + 1;
    items.add(doc);
    return state.copyWith(
        loadingStatus: LoadingStatus.success, error: "", documents: items);
  }
}

ScanState _getConfigurationSuccess(
    ScanState state, ConfigFetchSuccessAction action) {
  var optionId = state?.optionDetail?.optionId;

  DocOption option = action.options.firstWhere(
      (element) => element.documentsattachedoptionid == optionId,
      orElse: () => null);
  return state.copyWith(
      fileFormats: action.fileFormats,
      options: action.options,
      selectedOption: option,
      loadingStatus: LoadingStatus.success,
      error: "");
}

ScanState _getDocumentSuccess(
    ScanState state, DocumentFetchSuccessAction action) {
  return state.copyWith(
      documentTypes: action.documentTypes,
      loadingStatus: LoadingStatus.success,
      error: "");
}

//ScanState _saveDocsAction(
//    ScanState state, DocumentSaveSuccessAction action) {
//  return state.copyWith(
//      savedDocument: action.documentResponse,
//      loadingStatus: LoadingStatus.success,
//      error: "");
//}

ScanState _validateSaveAction(ScanState state, ValidateSaveAction action) {
  return state.copyWith();
}

//ScanState _documentSaveAction(
//    ScanState state, DocumentSaveAction action) {
//  return state.copyWith(
//      isPdfGenerate: action.isGenerated, generatedPdf: action.generatedFile);
//}
