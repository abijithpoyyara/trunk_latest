import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class TransactionUnblockReqInitType extends BaseResponseModel {
  List<TransactionUnblockReqInitModelList> transactionUnblockReqInitModelList;

  TransactionUnblockReqInitType.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    transactionUnblockReqInitModelList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => TransactionUnblockReqInitModelList.fromJson(e))
        .toList();
  }
}

class TransactionUnblockReqInitModelList {
  String acknowledgementreqyn;
  String code;
  int count;
  String imagephysicalname;
  int id;
  String optioncode;
  int reportengineformatid;
  String screepanelname;
  int tableid;
  String title;
  TransactionUnblockReqInitModelList.fromJson(Map parsedJson) {
    acknowledgementreqyn = BaseJsonParser.goodString(parsedJson, "acknowledgementreqyn");
    code = BaseJsonParser.goodString(parsedJson, "code");
    count = BaseJsonParser.goodInt(parsedJson, "count");
    imagephysicalname = BaseJsonParser.goodString(parsedJson, "imagephysicalname");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    optioncode = BaseJsonParser.goodString(parsedJson, "optioncode");
    reportengineformatid = BaseJsonParser.goodInt(parsedJson, "reportengineformatid");
    screepanelname = BaseJsonParser.goodString(parsedJson, "screepanelname");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    title = BaseJsonParser.goodString(parsedJson, "title");
  }
}
