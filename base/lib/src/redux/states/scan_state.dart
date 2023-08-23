import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:base/src/services/model/response/document_type_model.dart';
import 'package:base/src/services/model/response/scanner_model.dart';
import 'package:base/src/widgets/screens/item_attachment/_model/item_attachment_model.dart';
import 'package:meta/meta.dart';

@immutable
class ScanState {
  final ModuleListModel optionDetail;
  final LoadingStatus loadingStatus;
  final String loadingMessage;
  final String error;

  final List<ItemAttachmentModel> scannedDocuments;
  final ItemAttachmentModel selectedAttachment;

  final List<DocumentTypes> documentTypes;

  final List<DocOption> docOptions;
  final List<FileFormatsModel> fileFormats;

  final DocOption selectedOption;

  ScanState({
    this.scannedDocuments,
    this.loadingStatus,
    this.error,
    this.loadingMessage,
    this.documentTypes,
    this.selectedAttachment,
    this.optionDetail,
    this.docOptions,
    this.fileFormats,
    this.selectedOption,
  });

  ScanState copyWith(
      {LoadingStatus loadingStatus,
      List<ItemAttachmentModel> documents,
      List<DocumentTypes> documentTypes,
      ItemAttachmentModel selectedAttachment,
      String error,
      String loadingMessage,
      ModuleListModel optionDetail,
      List<DocOption> options,
      List<FileFormatsModel> fileFormats,
      DocOption selectedOption}) {
    return new ScanState(
        optionDetail: optionDetail ?? this.optionDetail,
        loadingStatus: loadingStatus ?? this.loadingStatus,
        scannedDocuments: documents ?? this.scannedDocuments,
        selectedAttachment: documents != null
            ? null
            : selectedAttachment ?? this.selectedAttachment,
        documentTypes: documentTypes ?? this.documentTypes,
        error: error ?? this.error,
        loadingMessage: loadingMessage ?? this.loadingMessage,
        docOptions: options ?? this.docOptions,
        fileFormats: fileFormats ?? this.fileFormats,
        selectedOption: selectedOption ?? this.selectedOption);
  }

  factory ScanState.initial() {
    return new ScanState(
      loadingStatus: LoadingStatus.success,
      scannedDocuments: List(),
      selectedAttachment: null,
      documentTypes: List(),
      error: "",
      loadingMessage: "",
      optionDetail: null,
      docOptions: [],
      fileFormats: [],
      selectedOption: null,
    );
  }
}
