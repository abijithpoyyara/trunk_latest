import 'package:base/redux.dart';
import 'package:base/services.dart';
import 'package:base/src/services/model/response/document_type_model.dart';
import 'package:base/src/services/model/response/scanner_model.dart';
import 'package:base/src/services/repository/scan_repository.dart';
import 'package:base/src/widgets/screens/item_attachment/_model/item_attachment_model.dart';
import 'package:flutter/cupertino.dart';

enum ScanOption { ItemAttachmentScreen }

class AttachedItemEditAction {
  ItemAttachmentModel selectedAttachment;

  AttachedItemEditAction(this.selectedAttachment);
}

class AddNewDocAction {
  ItemAttachmentModel documents;

  AddNewDocAction(this.documents);
}

//class DocumentSaveSuccessAction {
//  List<Document> documentResponse;
//
//  DocumentSaveSuccessAction(this.documentResponse);
//}

class DocumentFetchAction {
  DocumentFetchAction();
}

class DocumentFetchSuccessAction {
  List<DocumentTypes> documentTypes;

  DocumentFetchSuccessAction(this.documentTypes);
}

class ConfigFetchSuccessAction {
  List<FileFormatsModel> fileFormats;
  List<DocOption> options;

  ConfigFetchSuccessAction(this.fileFormats, this.options);
}

class DocumentUploadSuccessAction {
  List<ImageModel> documents;

  DocumentUploadSuccessAction(this.documents);
}

class ValidateSaveAction {
  List<String> documentsScanned;
  DocumentTypes documentTypes;
  bool isValidated = false;

  ValidateSaveAction(this.documentsScanned, this.documentTypes);
}


ThunkAction fetchDocumentTypes({
  String procName,
  String actionFlag,
  String subActionFlag,
  int mappingId,
}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new DocumentFetchAction());
      ScanRepository().getDocumentTypes(
          actionFlag: actionFlag,
          mappingId: mappingId,
          procName: procName,
          subActionFlag: subActionFlag,
          onRequestFailure: (exception) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error, message: exception.toString())),
          onRequestSuccess: (documentResponse) =>
              store.dispatch(new DocumentFetchSuccessAction(documentResponse)));
    });
  };
}

ThunkAction fetchScannerConfigs() {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new DocumentFetchAction());
      ScanRepository().getFileFormats(
          onRequestFailure: (exception) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error, message: exception.toString())),
          onRequestSuccess: (fileFormats, options) {
            store.dispatch(ConfigFetchSuccessAction(fileFormats, options));
          });
    });
  };
}

ThunkAction saveDocuments(
    {@required DocumentTypes documentType,
    @required ModuleListModel selectedOption,
    @required List<ItemAttachmentModel> uploadedDocs}) {
  return (Store store) async {
    print("length :  ${uploadedDocs.length}");
    uploadedDocs.forEach((data) => print(data));
    print("end");

    new Future(() async {
      store.dispatch(new LoadingAction(
          status: LoadingStatus.loading, message: "Saving Documents"));

//      ScanRepository().saveDocuments(
//          documentType: documentType,
//          option: selectedOption,
//          documents: uploadedDocs,
//          onRequestFailure: (exception) => store.dispatch(new LoadingAction(
//              status: LoadingStatus.error, message: exception.toString())),
//          onRequestSuccess: (documentResponse) => {
//                if (documentResponse != null)
//                  {}
////                  store.dispatch(DocumentSaveSuccessAction(documentResponse))
//                else
//                  store.dispatch(new LoadingAction(
//                      status: LoadingStatus.error,
//                      message: Exception("Failed to save data").toString()))
//              });
    });
  };
}

ThunkAction uploadDocumentsAction(Function(String xml) onUploadSuccess) {
  return (Store store) async {
    new Future(() async {
      List docs = store.state.scanState.scannedDocuments;
      var docOption = store.state.scanState.selectedOption;
      List<FileFormatsModel> formats =
          store.state.scanState.fileFormats as List;
      int fileTypeBccId = formats
              .firstWhere((element) => element.code.contains("IMAGE"),
                  orElse: () => null)
              ?.id ??
          0;
      if (docs?.isNotEmpty ?? false) {
        store.dispatch(new LoadingAction(
            status: LoadingStatus.loading, message: "Uploading document"));
        FileUploadRepository(
          onRequestSuccess: (uploadResponse) => {
            ScanRepository()
                .generateXML(docs, docOption, fileTypeBccId, onUploadSuccess)
          },
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error, message: exception.toString())),
        ).uploadDocuments(docs,
            uploadProgress: (progress) => store.dispatch(LoadingAction(
                status: LoadingStatus.loading,
                message: "Uploading Document $progress %")));
      }
      else
        onUploadSuccess(null);
    });
  };
}
