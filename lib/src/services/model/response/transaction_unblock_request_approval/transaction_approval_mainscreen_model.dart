import 'package:base/services.dart';

import '../../../../../utility.dart';

class TransactionUnblockReqApprlModel extends BaseResponseModel {
  List<TransactionUnblockReqApprlCountList> transactionUnblockReqApprlCountList;

  TransactionUnblockReqApprlModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    transactionUnblockReqApprlCountList =
        BaseJsonParser.goodList(json, "resultObject")
            .map((e) => TransactionUnblockReqApprlCountList.fromJson(e))
            .toList();
  }
}

class TransactionUnblockReqApprlCountList {
  String code;
  int count;
  int id;
  String reportengineformatcode;
  int reportengineformatid;
  int tableid;
  String title;
  TransactionUnblockReqApprlCountList.fromJson(Map parsedJson) {
    code = BaseJsonParser.goodString(parsedJson, "code");
    count = BaseJsonParser.goodInt(parsedJson, "count");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    reportengineformatcode =
        BaseJsonParser.goodString(parsedJson, "reportengineformatcode");
    reportengineformatid =
        BaseJsonParser.goodInt(parsedJson, "reportengineformatid");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    title = BaseJsonParser.goodString(parsedJson, "title");
  }
}
