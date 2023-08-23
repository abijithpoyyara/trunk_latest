import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class GradingViewListModel extends BaseResponseModel {
  List<GardingViewList> gradingViewList;
  int SOR_Id;
  int EOR_Id;
  int totalRecords;

  GradingViewListModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    gradingViewList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => GardingViewList.fromJson(e))
        .toList();
    SOR_Id = json["SOR_Id"];
    EOR_Id = json["EOR_Id"];
    totalRecords = json["TotalRecords"];
  }
}

class GardingViewList {
  int rowno;
  int nextrowno;
  int prevrowno;
  int nextid;
  int previd;
  int supplierid;
  String gindate;
  String ginno;
  String suppliername;
  String status;
  String transdate;
  String transno;
  int start;
  int limit;
  int totalrecords;
  int Id;
  int EOR_Id;
  int SOR_Id;
  int TotalRecords;
  GardingViewList.fromJson(Map parsedJson) {
    rowno = BaseJsonParser.goodInt(parsedJson, "rowno");
    nextrowno = BaseJsonParser.goodInt(parsedJson, "nextrowno");
    prevrowno = BaseJsonParser.goodInt(parsedJson, "prevrowno");
    nextid = BaseJsonParser.goodInt(parsedJson, "nextid");
    previd = BaseJsonParser.goodInt(parsedJson, "previd");
    supplierid = BaseJsonParser.goodInt(parsedJson, "supplierid");
    gindate = BaseJsonParser.goodString(parsedJson, "gindate");
    ginno = BaseJsonParser.goodString(parsedJson, "ginno");
    status = BaseJsonParser.goodString(parsedJson, "status");
    transdate = BaseJsonParser.goodString(parsedJson, "transdate");
    suppliername = BaseJsonParser.goodString(parsedJson, "suppliername");
    transno = BaseJsonParser.goodString(parsedJson, "transno");
    start = BaseJsonParser.goodInt(parsedJson, "start");
    limit = BaseJsonParser.goodInt(parsedJson, "limit");
    totalrecords = BaseJsonParser.goodInt(parsedJson, "totalrecords");
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
    EOR_Id = BaseJsonParser.goodInt(parsedJson, "EOR_Id");
    SOR_Id = BaseJsonParser.goodInt(parsedJson, "SOR_Id");
    TotalRecords = BaseJsonParser.goodInt(parsedJson, "TotalRecords");
  }
}
