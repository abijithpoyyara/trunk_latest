import 'package:base/src/services/model/response/document_type_model.dart';
import 'package:base/src/services/model/response/image.dart';

class ItemAttachmentModel {
  DocumentTypes documentType;
  DocumentTypes mainDocType;
  ItemAttachmentModel mainDoc;
  String docNo;
  DateTime docDate;
  bool isActive;
  List<String> scannedDocuments;
  int mappingId;
  List<ImageModel> uploadedImages;


  ItemAttachmentModel(
      {this.documentType,
      this.mainDocType,
      this.mainDoc,
      this.docNo,
      this.docDate,
      this.isActive,
      this.scannedDocuments,
      this.mappingId,

      });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemAttachmentModel &&
          runtimeType == other.runtimeType &&
          docNo == other.docNo;


  @override
  int get hashCode =>
      docNo.hashCode;


  @override
  String toString() {
    return 'ItemAttachmentModel{documentType: $documentType, mainDocType: $mainDocType, mainDoc: $mainDoc, docNo: $docNo, docDate: $docDate, isActive: $isActive, scannedDocuments: $scannedDocuments}';
  }

  ItemAttachmentModel merge(ItemAttachmentModel copy) {
    return ItemAttachmentModel(
      documentType: copy.documentType ?? documentType,
      mainDocType: copy.mainDocType ?? mainDocType,
      mainDoc: copy.mainDoc ?? mainDoc,
      docNo: copy.docNo ?? docNo,
      docDate: copy.docDate ?? docDate,
      isActive: copy.isActive ?? isActive,
      scannedDocuments: copy.scannedDocuments ?? scannedDocuments,
      mappingId: copy.mappingId ?? mappingId,
//      mappingParentId: copy.mappingParentId ?? mappingParentId,
    );
  }
}
