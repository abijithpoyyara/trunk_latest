import 'package:base/utility.dart';

class BCCModel {
  String code;
  String description;
  String extra;
  String fieldCodeName;
  int id;
  int tableId;
  String tableCode;
  String refType;
  String name;
  int bankaccountid;
  int bookaccountid;
  int currencyid;
  int rightsbccid;
  int typebccid;
  String bookaccountname;
  String currencycode;
  String effectonbookaccount;
  String effetonbookac;
  String typebcccode;
  int vouchercodeid;
  int accountid;

  BCCModel({this.name, this.id, this.description, this.code});
  BCCModel.fromJson(Map<String, dynamic> json) {
    code = BaseJsonParser.goodString(json, "code");
    description = BaseJsonParser.goodString(json, "description");
    extra = BaseJsonParser.goodString(json, "extra");
    fieldCodeName = BaseJsonParser.goodString(json, "fieldcodename");
    id = BaseJsonParser.goodInt(json, "id");

    tableCode = BaseJsonParser.goodString(json, "tablecode");
    tableId = BaseJsonParser.goodInt(json, "tableid");
    name = BaseJsonParser.goodString(json, "name");
    refType = BaseJsonParser.goodString(json, "reftype");
    bankaccountid = BaseJsonParser.goodInt(json, "bankaccountid");
    bookaccountid = BaseJsonParser.goodInt(json, "bookaccountid");
    currencyid = BaseJsonParser.goodInt(json, "currencyid");
    rightsbccid = BaseJsonParser.goodInt(json, "rightsbccid");
    typebccid = BaseJsonParser.goodInt(json, "typebccid");
    vouchercodeid = BaseJsonParser.goodInt(json, "vouchercodeid");
    accountid = BaseJsonParser.goodInt(json, "accountid");
    bookaccountname = BaseJsonParser.goodString(json, "bookaccountname");
    currencycode = BaseJsonParser.goodString(json, "currencycode");
    effectonbookaccount =
        BaseJsonParser.goodString(json, "effectonbookaccount");
    effetonbookac = BaseJsonParser.goodString(json, "effetonbookac");

    typebcccode = BaseJsonParser.goodString(json, "typebcccode");
  }

  @override
  String toString() {
    return 'BCCModel{code: $code, description: $description, extra: $extra, fieldCodeName: $fieldCodeName, id: $id, tableId: $tableId, tableCode: $tableCode}';
  }
}

class BSCModel {
  int optionId;
  int companyId;
  String constantGroup;
  String constantCode;
  String constantDescription;
  int constantDataTypeBccid;
  int constantValue;
  int maxLength;
  String recordType;
  bool isEditable;
  bool isHidden;
  bool isMandatory;
  int displayOrder;
  int id;
  int tableId;
  int lastModUserId;
  bool docAttachReqYN;
  String docAttachXml;
  String serialNoCol;
  String transDateCol;

  BSCModel.fromJson(Map<String, dynamic> json) {
    optionId = BaseJsonParser.goodInt(json, "optionid");
    companyId = BaseJsonParser.goodInt(json, "companyid");
    constantGroup = BaseJsonParser.goodString(json, "constantgroup");
    constantCode = BaseJsonParser.goodString(json, "constantcode");
    constantDescription =
        BaseJsonParser.goodString(json, "constantdescription");
    constantDataTypeBccid =
        BaseJsonParser.goodInt(json, "constantdatatypebccid");
    constantValue = BaseJsonParser.goodInt(json, "constantvalue");
    maxLength = BaseJsonParser.goodInt(json, "maxlength");
    recordType = BaseJsonParser.goodString(json, "recordtype");
    isEditable = BaseJsonParser.goodBoolean(json, "iseditable");
    isHidden = BaseJsonParser.goodBoolean(json, "ishidden");
    isMandatory = BaseJsonParser.goodBoolean(json, "ismandatory");
    displayOrder = BaseJsonParser.goodInt(json, "displayorder");
    id = BaseJsonParser.goodInt(json, "Id");
    tableId = BaseJsonParser.goodInt(json, "tableid");
    lastModUserId = BaseJsonParser.goodInt(json, "LastModUserId");
    docAttachReqYN = BaseJsonParser.goodBoolean(json, "docAttachReqYN");
    docAttachXml = BaseJsonParser.goodString(json, "docAttachXml");
    serialNoCol = BaseJsonParser.goodString(json, "SerialNoCol");
    transDateCol = BaseJsonParser.goodString(json, "TransDateCol");
    docAttachReqYN = BaseJsonParser.goodBoolean(json, "docAttachReqYN");
    docAttachXml = BaseJsonParser.goodString(json, "docAttachXml");
    serialNoCol = BaseJsonParser.goodString(json, "SerialNoCol");
    transDateCol = BaseJsonParser.goodString(json, "TransDateCol");
  }

  @override
  String toString() {
    return 'BSCModel{optionId: $optionId, companyId: $companyId, constantGroup: $constantGroup, constantCode: $constantCode, constantDescription: $constantDescription, constantDataTypeBccid: $constantDataTypeBccid, constantValue: $constantValue, maxLength: $maxLength, recordType: $recordType, isEditable: $isEditable, isHidden: $isHidden, isMandatory: $isMandatory, displayOrder: $displayOrder, id: $id, tableId: $tableId, lastModUserId: $lastModUserId, docAttachReqYN: $docAttachReqYN, docAttachXml: $docAttachXml, serialNoCol: $serialNoCol, transDateCol: $transDateCol}';
  }
}
