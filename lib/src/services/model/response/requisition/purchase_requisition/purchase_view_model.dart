import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class PurchaseViewListModel extends BaseResponseModel {
  List<PurchaseViewList> purchaseViewList;
  int SOR_Id;
  int EOR_Id;
  int totalRecords;

  PurchaseViewListModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    purchaseViewList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => PurchaseViewList.fromJson(e))
        .toList();
    SOR_Id = json["SOR_Id"];
    EOR_Id = json["EOR_Id"];
    totalRecords = json["TotalRecords"];
  }
}

class PurchaseViewList {
  int rowno;
  int nextrowno;
  int prevrowno;
  int nextid;
  int previd;
  int tableid;
  String requestdate;
  String requestno;
  String blcode;
  String location;
  String status;
  String createddate;
  String createduser;
  int start;
  int limit;
  int totalrecords;
  int Id;
  int EOR_Id;
  int SOR_Id;
  int TotalRecords;
  PurchaseViewList.fromJson(Map parsedJson) {
    rowno = BaseJsonParser.goodInt(parsedJson, "rowno");
    nextrowno = BaseJsonParser.goodInt(parsedJson, "nextrowno");
    prevrowno = BaseJsonParser.goodInt(parsedJson, "prevrowno");
    nextid = BaseJsonParser.goodInt(parsedJson, "nextid");
    previd = BaseJsonParser.goodInt(parsedJson, "previd");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    requestdate = BaseJsonParser.goodString(parsedJson, "requestdate");
    requestno = BaseJsonParser.goodString(parsedJson, "requestno");
    blcode = BaseJsonParser.goodString(parsedJson, "blcode");
    location = BaseJsonParser.goodString(parsedJson, "location");
    status = BaseJsonParser.goodString(parsedJson, "status");
    createddate = BaseJsonParser.goodString(parsedJson, "createddate");
    createduser = BaseJsonParser.goodString(parsedJson, "createduser");
    start = BaseJsonParser.goodInt(parsedJson, "start");
    limit = BaseJsonParser.goodInt(parsedJson, "limit");
    totalrecords = BaseJsonParser.goodInt(parsedJson, "totalrecords");
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
    EOR_Id = BaseJsonParser.goodInt(parsedJson, "EOR_Id");
    SOR_Id = BaseJsonParser.goodInt(parsedJson, "SOR_Id");
    TotalRecords = BaseJsonParser.goodInt(parsedJson, "TotalRecords");
  }
}
