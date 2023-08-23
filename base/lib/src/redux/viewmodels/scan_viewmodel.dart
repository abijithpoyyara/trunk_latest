import 'package:base/redux.dart';
import 'package:base/src/redux/actions/scan_actions.dart';
import 'package:base/src/redux/states/app_state.dart';
import 'package:base/src/services/model/response/document_type_model.dart';
import 'package:base/src/services/model/response/scanner_model.dart';
import 'package:base/src/widgets/screens/item_attachment/_model/item_attachment_model.dart';

class ScanViewModel extends BaseViewModel {
  final LoadingStatus status;
  final String loadingMessage;
  final String error;

  final DocOption selectedOption;
  final List<DocumentTypes> documentTypes;
  final ItemAttachmentModel selectedAttachment;
  final bool isSelected;

  final List<ItemAttachmentModel> scannedDocuments;

  final Function(ItemAttachmentModel) onAttachmentEdit;
  final Function(String file) onImagePickSuccess;

  final Function(List<String> documents, DocumentTypes selectedType)
      onValidateSave;

  final Function() onClear;
  final Function(ItemAttachmentModel model) onAddNewAttachment;

  ScanViewModel({
    this.isSelected,
    this.scannedDocuments,
    this.status,
    this.documentTypes,
    this.selectedOption,
    this.error,
    this.onImagePickSuccess,
    this.onAttachmentEdit,
    this.selectedAttachment,
    this.loadingMessage,
    this.onClear,
    this.onValidateSave,
    this.onAddNewAttachment,
  });

  factory ScanViewModel.fromStore(Store<BaseAppState> store) {
    return ScanViewModel(
        status: store.state.scanState.loadingStatus,
        scannedDocuments: store.state.scanState.scannedDocuments,
        documentTypes: store.state.scanState.documentTypes,
        error: store.state.scanState.error,
        selectedOption: store.state.scanState.selectedOption,
        loadingMessage: store.state.scanState.loadingMessage,
        selectedAttachment: store.state.scanState.selectedAttachment,
        isSelected: store.state.scanState.selectedAttachment != null,
        onAttachmentEdit: (selected) =>
            store.dispatch(AttachedItemEditAction(selected)),
        onClear: () => store.dispatch(OnClearAction()),
        onAddNewAttachment: (model) {
          store.dispatch(AddNewDocAction(model));
        },
        onValidateSave: (files, selectedType) =>
            store.dispatch(ValidateSaveAction(files, selectedType)));
  }
}
