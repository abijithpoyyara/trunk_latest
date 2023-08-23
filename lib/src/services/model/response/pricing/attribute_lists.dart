import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class AttributesModel extends BaseResponseModel {
  List<Attributes> attributeList;

  AttributesModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    attributeList = BaseJsonParser.goodList(json, "attributeObj")
        .map((e) => Attributes.fromJson(e))
        .toList();
  }
}

class Attributes {
  int id;
  int lastModUserId;
  String serialNoCol;
  String transDateCol;
  String code;
  String description;
  bool docAttachReqYN;
  String docAttachXml;
  bool isuserdefined;
  int tableid;
  Attributes.fromJson(Map<String, dynamic> json) {
    id = BaseJsonParser.goodInt(json, "Id");
    lastModUserId = BaseJsonParser.goodInt(json, "LastModUserId");
    serialNoCol = BaseJsonParser.goodString(json, "SerialNoCol");
    code = BaseJsonParser.goodString(json, "code");
    transDateCol = BaseJsonParser.goodString(json, "TransDateCol");
    description = BaseJsonParser.goodString(json, "description");
    docAttachXml = BaseJsonParser.goodString(json, "docAttachXml");

    tableid = BaseJsonParser.goodInt(json, "tableid");

    docAttachReqYN = BaseJsonParser.goodBoolean(json, "docAttachReqYN");
    isuserdefined = BaseJsonParser.goodBoolean(json, "isuserdefined");
  }
}
