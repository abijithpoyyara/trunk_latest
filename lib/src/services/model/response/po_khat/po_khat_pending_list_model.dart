import 'package:base/services.dart';

import '../../../../../utility.dart';

class POKhatPendingListModel extends BaseResponseModel {
  List<POKhatPendingListModelList> pokhatPendingList;

  POKhatPendingListModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    pokhatPendingList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => POKhatPendingListModelList.fromJson(e))
        .toList();
  }
}

class POKhatPendingListModelList {
  int rowno;
  int previd;
  int nextid;
  int tableid;
  String purchaseorderdate;
  String purchaseorderno;
  String name;
  String remarks;
  int businesslocationtableid;
  int businesslocationtabledataid;
  int businesslocationlevelno;
  int totalvalue;
  String status;
  String supplier;
  String purchaseorderaddress1;
  String purchaseorderaddress2;
  String purchaseorderaddress3;
  String createddate;
  String createduser;
  String apprvlstatus;
  int start;
  int limit;
  int totalrecords;
  int Id;
  int purchaserid;
  String purchasername;
  String paymentmode;
  POKhatPendingListModelList.fromJson(Map parsedJson) {
    rowno = BaseJsonParser.goodInt(parsedJson, "rowno");
    purchaserid = BaseJsonParser.goodInt(parsedJson, "purchaserid");
    previd = BaseJsonParser.goodInt(parsedJson, "previd");
    nextid = BaseJsonParser.goodInt(parsedJson, "nextid");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    purchaseorderdate =
        BaseJsonParser.goodString(parsedJson, "purchaseorderdate");
    purchasername = BaseJsonParser.goodString(parsedJson, "purchasername");
    paymentmode = BaseJsonParser.goodString(parsedJson, "paymentmode");
    purchaseorderno = BaseJsonParser.goodString(parsedJson, "purchaseorderno");
    name = BaseJsonParser.goodString(parsedJson, "name");
    remarks = BaseJsonParser.goodString(parsedJson, "remarks");
    businesslocationtableid =
        BaseJsonParser.goodInt(parsedJson, "businesslocationtableid");
    businesslocationtabledataid =
        BaseJsonParser.goodInt(parsedJson, "businesslocationtabledataid");
    businesslocationlevelno =
        BaseJsonParser.goodInt(parsedJson, "businesslocationlevelno");
    totalvalue = BaseJsonParser.goodInt(parsedJson, "totalvalue");
    status = BaseJsonParser.goodString(parsedJson, "status");
    supplier = BaseJsonParser.goodString(parsedJson, "supplier");
    purchaseorderaddress1 =
        BaseJsonParser.goodString(parsedJson, "purchaseorderaddress1");
    purchaseorderaddress2 =
        BaseJsonParser.goodString(parsedJson, "purchaseorderaddress2");
    purchaseorderaddress3 =
        BaseJsonParser.goodString(parsedJson, "purchaseorderaddress3");
    createddate = BaseJsonParser.goodString(parsedJson, "createddate");
    createduser = BaseJsonParser.goodString(parsedJson, "createduser");
    apprvlstatus = BaseJsonParser.goodString(parsedJson, "apprvlstatus");
    start = BaseJsonParser.goodInt(parsedJson, "start");
    limit = BaseJsonParser.goodInt(parsedJson, "limit");
    totalrecords = BaseJsonParser.goodInt(parsedJson, "totalrecords");
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
  }
}
