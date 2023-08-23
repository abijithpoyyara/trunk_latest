import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class StockViewListModel extends BaseResponseModel {
  List<StockViewList> stockViewList;
  int EOR_Id;
  int SOR_Id;
  int TotalRecords;

  StockViewListModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    stockViewList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => StockViewList.fromJson(e))
        .toList();
    SOR_Id = json["SOR_Id"];
    EOR_Id = json["EOR_Id"];
    TotalRecords = json["TotalRecords"];
  }
}

class StockViewList {
  int rowno;
  int nextrowno;
  int prevrowno;
  int nextid;
  int previd;
  int id;
  int tableid;
  String requestdate;
  String requestno;
  String blcode;
  String sourcelocationlevelcode;
  String sourcelocation;
  String targetlocationlevelcode;
  String targetlocation;
  int statusbccid;
  String status;
  int start;
  int limit;
  int EOR_Id;
  int SOR_Id;
  int TotalRecords;
  StockViewList.fromJson(Map parsedJson) {
    rowno = BaseJsonParser.goodInt(parsedJson, "rowno");
    nextrowno = BaseJsonParser.goodInt(parsedJson, "nextrowno");
    prevrowno = BaseJsonParser.goodInt(parsedJson, "prevrowno");
    nextid = BaseJsonParser.goodInt(parsedJson, "nextid");
    previd = BaseJsonParser.goodInt(parsedJson, "previd");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    requestdate = BaseJsonParser.goodString(parsedJson, "requestdate");
    requestno = BaseJsonParser.goodString(parsedJson, "requestno");
    blcode = BaseJsonParser.goodString(parsedJson, "blcode");
    sourcelocationlevelcode =
        BaseJsonParser.goodString(parsedJson, "sourcelocationlevelcode");
    sourcelocation = BaseJsonParser.goodString(parsedJson, "sourcelocation");
    targetlocationlevelcode =
        BaseJsonParser.goodString(parsedJson, "targetlocationlevelcode");
    targetlocation = BaseJsonParser.goodString(parsedJson, "targetlocation");
    statusbccid = BaseJsonParser.goodInt(parsedJson, "statusbccid");
    status = BaseJsonParser.goodString(parsedJson, "status");
    start = BaseJsonParser.goodInt(parsedJson, "start");
    limit = BaseJsonParser.goodInt(parsedJson, "limit");
    TotalRecords = BaseJsonParser.goodInt(parsedJson, "totalrecords");
    EOR_Id = BaseJsonParser.goodInt(parsedJson, "EOR_Id");
    SOR_Id = BaseJsonParser.goodInt(parsedJson, "SOR_Id");
  }
}
