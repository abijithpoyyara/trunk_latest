import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';

import '../../../../../../utility.dart';

class SelectedStockViewModel extends BaseResponseModel {
  List<SelectedStockViewList> stockViewList;

  SelectedStockViewModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    stockViewList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => SelectedStockViewList.fromJson(e))
        .toList();
  }
}

class SelectedStockViewList {
  int id;
  int optionid;
  int tableid;
  int transactionuniqeid;
  int amendmentno;
  int finyearid;
  String requestno;
  String requestdate;
  int sourcebusinesslevelcodeid;
  int sourcebusinessleveltableid;
  int sourcebusinessleveltabledataid;
  int targetbusinesslevelcodeid;
  int targetbusinessleveltableid;
  int targetbusinessleveltabledataid;
  String remarks;
  int createduserid;
  String recordstatus;
  int lastmoduserid;
  String lastmoddate;
  int statusbccid;
  int approvedby;
  String approveddate;
  String isblockedyn;
  String docapprvlstatus;
  String createddate;
  int departmentid;
  String preparedusername;
  List<DetailDtlListModel> detailDtl;

  SelectedStockViewList.fromJson(Map parsedJson) {
    id = BaseJsonParser.goodInt(parsedJson, "id");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    transactionuniqeid =
        BaseJsonParser.goodInt(parsedJson, "transactionuniqeid");
    amendmentno = BaseJsonParser.goodInt(parsedJson, "amendmentno");
    finyearid = BaseJsonParser.goodInt(parsedJson, "finyearid");
    requestno = BaseJsonParser.goodString(parsedJson, "requestno");
    requestdate = BaseJsonParser.goodString(parsedJson, "requestdate");
    sourcebusinesslevelcodeid =
        BaseJsonParser.goodInt(parsedJson, "sourcebusinesslevelcodeid");
    sourcebusinessleveltableid =
        BaseJsonParser.goodInt(parsedJson, "sourcebusinessleveltableid");
    sourcebusinessleveltabledataid =
        BaseJsonParser.goodInt(parsedJson, "sourcebusinessleveltabledataid");
    targetbusinesslevelcodeid =
        BaseJsonParser.goodInt(parsedJson, "targetbusinesslevelcodeid");
    targetbusinessleveltableid =
        BaseJsonParser.goodInt(parsedJson, "targetbusinessleveltableid");
    targetbusinessleveltabledataid =
        BaseJsonParser.goodInt(parsedJson, "targetbusinessleveltabledataid");
    remarks = BaseJsonParser.goodString(parsedJson, "remarks");
    createduserid = BaseJsonParser.goodInt(parsedJson, "createduserid");
    recordstatus = BaseJsonParser.goodString(parsedJson, "recordstatus");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    statusbccid = BaseJsonParser.goodInt(parsedJson, "statusbccid");
    approvedby = BaseJsonParser.goodInt(parsedJson, "approvedby");
    approveddate = BaseJsonParser.goodString(parsedJson, "approveddate");
    isblockedyn = BaseJsonParser.goodString(parsedJson, "isblockedyn");
    docapprvlstatus = BaseJsonParser.goodString(parsedJson, "docapprvlstatus");
    createddate = BaseJsonParser.goodString(parsedJson, "createddate");
    departmentid = BaseJsonParser.goodInt(parsedJson, "departmentid");
    preparedusername =
        BaseJsonParser.goodString(parsedJson, "preparedusername");
    detailDtl = BaseJsonParser.goodList(parsedJson, "detailsdtllist")
        .map((e) => DetailDtlListModel.fromJson(e))
        .toList();
  }
}

class DetailDtlListModel {
  int id;
  int optionid;
  int tableid;
  int parenttableid;
  int parenttabledataid;
  int itemid;
  int uomtypebccid;
  int uomid;
  double qty;
  int statusbccid;
  String statusdate;
  int lastmoduserid;
  String lastmoddate;
  int approvedqty;
  int dtlapprovedby;
  String dtlapproveddate;
  String dtlisblockedyn;
  String dtldocapprovalstatus;
  int uom;
  String status;
  int usedqty;
  int shortcloseqty;
  int balanceqty;
  String itemcode;
  String itemname;
  Budjetdtljson budjetdtljson;
  UomTypes uomTypes;

  DetailDtlListModel.fromJson(Map parsedJson) {
    id = BaseJsonParser.goodInt(parsedJson, "id");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    parenttableid = BaseJsonParser.goodInt(parsedJson, "parenttableid");
    parenttabledataid = BaseJsonParser.goodInt(parsedJson, "parenttabledataid");
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    uomtypebccid = BaseJsonParser.goodInt(parsedJson, "uomtypebccid");
    uomid = BaseJsonParser.goodInt(parsedJson, "uomid");
    qty = BaseJsonParser.goodDouble(parsedJson, "qty");
    statusbccid = BaseJsonParser.goodInt(parsedJson, "statusbccid");
    statusdate = BaseJsonParser.goodString(parsedJson, "statusdate");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    approvedqty = BaseJsonParser.goodInt(parsedJson, "approvedqty");
    dtlapprovedby = BaseJsonParser.goodInt(parsedJson, "dtlapprovedby");
    dtlapproveddate = BaseJsonParser.goodString(parsedJson, "dtlapproveddate");
    dtlisblockedyn = BaseJsonParser.goodString(parsedJson, "dtlisblockedyn");
    dtldocapprovalstatus =
        BaseJsonParser.goodString(parsedJson, "dtldocapprovalstatus");
    uom = BaseJsonParser.goodInt(parsedJson, "uom");
    status = BaseJsonParser.goodString(parsedJson, "status");
    usedqty = BaseJsonParser.goodInt(parsedJson, "usedqty");
    shortcloseqty = BaseJsonParser.goodInt(parsedJson, "shortcloseqty");
    balanceqty = BaseJsonParser.goodInt(parsedJson, "balanceqty");
    itemcode = BaseJsonParser.goodString(parsedJson, "itemcode");
    itemname = BaseJsonParser.goodString(parsedJson, "itemname");
    var budjetdtljsons = BaseJsonParser.goodList(parsedJson, "budgetdtljson")
        .map((e) => Budjetdtljson.fromJson(e))
        .toList();
    budjetdtljson = budjetdtljsons.isNotEmpty ? budjetdtljsons?.first : null;
    var uomTypess = BaseJsonParser.goodList(parsedJson, "uomratedetails")
        .map((e) => UomTypes.fromJson(e))
        .toList();
    uomTypes = uomTypess.isNotEmpty ? uomTypess?.first : null;
  }
}

class Budjetdtljson {
  int id;
  int tableid;
  int departmentid;
  int qty;
  double rate;
  int totalvalue;
  double budgeted;
  double inprocess;
  double actual;
  double remaining;
  int branchid;
  int itemid;
  String itemname;
  String itemcode;
  String budgetdate;
  Budjetdtljson.fromJson(Map parsedJson) {
    id = BaseJsonParser.goodInt(parsedJson, "id");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    departmentid = BaseJsonParser.goodInt(parsedJson, "departmentid");
    qty = BaseJsonParser.goodInt(parsedJson, "qty");
    rate = BaseJsonParser.goodDouble(parsedJson, "rate");
    totalvalue = BaseJsonParser.goodInt(parsedJson, "totalvalue");
    budgeted = BaseJsonParser.goodDouble(parsedJson, "budgeted");
    inprocess = BaseJsonParser.goodDouble(parsedJson, "inprocess");
    actual = BaseJsonParser.goodDouble(parsedJson, "actual");
    remaining = BaseJsonParser.goodDouble(parsedJson, "remaining");
    branchid = BaseJsonParser.goodInt(parsedJson, "branchid");
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    itemname = BaseJsonParser.goodString(parsedJson, "itemname");
    itemcode = BaseJsonParser.goodString(parsedJson, "itemcode");
    budgetdate = BaseJsonParser.goodString(parsedJson, "budgetdate");
  }
}

class Uomratedetail {
  int stockreqid;
  int stockreqtb;
  int itemid;
  int uomid;
  int uomtypebccid;
  String uomname;
  String uomvalue;
  int sortorder;
  Uomratedetail.fromJson(Map parsedJson) {
    stockreqid = BaseJsonParser.goodInt(parsedJson, "stockreqid");
    stockreqtb = BaseJsonParser.goodInt(parsedJson, "stockreqtb");
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    uomid = BaseJsonParser.goodInt(parsedJson, "uomid");
    uomtypebccid = BaseJsonParser.goodInt(parsedJson, "uomtypebccid");
    uomname = BaseJsonParser.goodString(parsedJson, "uomname");
    uomvalue = BaseJsonParser.goodString(parsedJson, "uomvalue");
    sortorder = BaseJsonParser.goodInt(parsedJson, "sortorder");
  }
}
