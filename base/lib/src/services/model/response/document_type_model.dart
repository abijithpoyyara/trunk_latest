import 'package:base/services.dart';
import 'package:base/utility.dart';

class DocumentTypeModel extends BaseResponseModel {
  List<DocumentTypes> documentTypes;

  DocumentTypeModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      documentTypes = new List<DocumentTypes>();
      parsedJson['resultObject'].forEach((mod) {
        documentTypes.add(new DocumentTypes.fromJson(mod));
      });
    } else
      documentTypes = List<DocumentTypes>();
  }
}

class DocumentTypes {
  String documentName;
  int id;
  int documentId;


  bool isLeaf;
  int levelId;
  int optionId;
  String parentDoc;
  int parentDocumentId;
  int sortOrder;
  int tableId;

  DocumentTypes.fromJson(Map<String, dynamic> json) {
    documentName = BaseJsonParser.goodString(json, "documentname");
    documentId = BaseJsonParser.goodInt(json, "documentid");
    id = BaseJsonParser.goodInt(json, "id");
    isLeaf = BaseJsonParser.goodBoolean(json, "leafyn");
    levelId = BaseJsonParser.goodInt(json, "levelid");
    optionId = BaseJsonParser.goodInt(json, "optionid");
    parentDoc = BaseJsonParser.goodString(json, "parentdoc");
    parentDocumentId = BaseJsonParser.goodInt(json, "parentdocumentid");
    sortOrder = BaseJsonParser.goodInt(json, "sortorder");
    tableId = BaseJsonParser.goodInt(json, "tableid");
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DocumentTypes &&
              runtimeType == other.runtimeType &&
              documentName == other.documentName &&
              id == other.id &&
              isLeaf == other.isLeaf &&
              levelId == other.levelId &&
              optionId == other.optionId &&
              parentDoc == other.parentDoc &&
              parentDocumentId == other.parentDocumentId;

  @override
  int get hashCode =>
      documentName.hashCode ^
      id.hashCode ^
      isLeaf.hashCode ^
      levelId.hashCode ^
      optionId.hashCode ^
      parentDoc.hashCode ^
      parentDocumentId.hashCode;

  @override
  String toString() {
    return 'DocumentTypes{documentName: $documentName, id: $id, documentId: $documentId, isLeaf: $isLeaf, levelId: $levelId, optionId: $optionId, parentDoc: $parentDoc, parentDocumentId: $parentDocumentId, sortOrder: $sortOrder, tableId: $tableId}';
  }
}
