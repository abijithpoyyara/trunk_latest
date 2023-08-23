import 'package:base/services.dart';

import '../../../../../utility.dart';

class GINViewListDataListModel extends BaseResponseModel {
  List<GINViewListDataList> ginSavedViewList;

  GINViewListDataListModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    ginSavedViewList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => GINViewListDataList.fromJson(e))
        .toList();
  }
}

class GINViewListDataList {
  int rowno;
  int previd;
  int nextid;
  int tableid;
  String grndate;
  String grnno;
  String name;
  int businesslocationtableid;
  int businesslocationtabledataid;
  int businesslocationlevelno;
  int totalvalue;
  String supplier;
  String grnaddress1;
  String grnaddress2;
  String grnaddress3;
  String supllierinvno;
  String supllierinvdate;
  int start;
  int limit;
  int totalrecords;
  String purorderno;
  String purorderdate;
  String status;
  int Id;
  GINViewListDataList.fromJson(Map parsedJson) {
    rowno = BaseJsonParser.goodInt(parsedJson, "rowno");
    previd = BaseJsonParser.goodInt(parsedJson, "previd");
    nextid = BaseJsonParser.goodInt(parsedJson, "nextid");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    grndate = BaseJsonParser.goodString(parsedJson, "grndate");
    grnno = BaseJsonParser.goodString(parsedJson, "grnno");
    name = BaseJsonParser.goodString(parsedJson, "name");
    businesslocationtableid =
        BaseJsonParser.goodInt(parsedJson, "businesslocationtableid");
    businesslocationtabledataid =
        BaseJsonParser.goodInt(parsedJson, "businesslocationtabledataid");
    businesslocationlevelno =
        BaseJsonParser.goodInt(parsedJson, "businesslocationlevelno");
    totalvalue = BaseJsonParser.goodInt(parsedJson, "totalvalue");
    supplier = BaseJsonParser.goodString(parsedJson, "supplier");
    grnaddress1 = BaseJsonParser.goodString(parsedJson, "grnaddress1");
    grnaddress2 = BaseJsonParser.goodString(parsedJson, "grnaddress2");
    grnaddress3 = BaseJsonParser.goodString(parsedJson, "grnaddress3");
    supllierinvno = BaseJsonParser.goodString(parsedJson, "supllierinvno");
    supllierinvdate = BaseJsonParser.goodString(parsedJson, "supllierinvdate");
    start = BaseJsonParser.goodInt(parsedJson, "start");
    limit = BaseJsonParser.goodInt(parsedJson, "limit");
    totalrecords = BaseJsonParser.goodInt(parsedJson, "totalrecords");
    purorderno = BaseJsonParser.goodString(parsedJson, "purorderno");
    purorderdate = BaseJsonParser.goodString(parsedJson, "purorderdate");
    status = BaseJsonParser.goodString(parsedJson, "status");
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
  }
}
