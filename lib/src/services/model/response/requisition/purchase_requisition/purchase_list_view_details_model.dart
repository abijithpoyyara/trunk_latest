import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/utility.dart';

class PurchaseDetailsViewModel extends BaseResponseModel {
  List<PurchaseDetailsViewList> purchaseDetailViewList;

  PurchaseDetailsViewModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    purchaseDetailViewList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => PurchaseDetailsViewList.fromJson(e))
        .toList();
  }
}

class PurchaseDetailsViewList {
  int Id;
  int amendedfromoptionid;
  String amendmentdate;
  int amendmentno;
  int approvedby;
  String approveddate;
  String createddate;
  int createduserid;
  int currstatusbccid;
  String curstatuswefdate;
  String docapprvlstatus;
  int finyearid;
  String isblockedyn;
  String lastmoddate;
  int lastmoduserid;
  int optionid;
  String recordstatus;
  String remarks;
  String reqdate;
  String reqno;
  int tableid;
  int transactionuniqueid;
  int EOR_Id;
  int SOR_Id;
  int TotalRecords;
  List<DetailDtlListModel> detailDtl;

  PurchaseDetailsViewList.fromJson(Map parsedJson) {
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
    amendedfromoptionid =
        BaseJsonParser.goodInt(parsedJson, "amendedfromoptionid");
    amendmentdate = BaseJsonParser.goodString(parsedJson, "amendmentdate");
    amendmentno = BaseJsonParser.goodInt(parsedJson, "amendmentno");
    approvedby = BaseJsonParser.goodInt(parsedJson, "approvedby");
    approveddate = BaseJsonParser.goodString(parsedJson, "approveddate");
    createddate = BaseJsonParser.goodString(parsedJson, "createddate");
    createduserid = BaseJsonParser.goodInt(parsedJson, "createduserid");
    currstatusbccid = BaseJsonParser.goodInt(parsedJson, "currstatusbccid");
    curstatuswefdate =
        BaseJsonParser.goodString(parsedJson, "curstatuswefdate");
    docapprvlstatus = BaseJsonParser.goodString(parsedJson, "docapprvlstatus");
    finyearid = BaseJsonParser.goodInt(parsedJson, "finyearid");
    isblockedyn = BaseJsonParser.goodString(parsedJson, "isblockedyn");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    recordstatus = BaseJsonParser.goodString(parsedJson, "recordstatus");
    remarks = BaseJsonParser.goodString(parsedJson, "remarks");
    reqdate = BaseJsonParser.goodString(parsedJson, "reqdate");
    reqno = BaseJsonParser.goodString(parsedJson, "reqno");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    transactionuniqueid =
        BaseJsonParser.goodInt(parsedJson, "transactionuniqueid");
    EOR_Id = BaseJsonParser.goodInt(parsedJson, "EOR_Id");
    SOR_Id = BaseJsonParser.goodInt(parsedJson, "SOR_Id");
    TotalRecords = BaseJsonParser.goodInt(parsedJson, "TotalRecords");
    detailDtl = BaseJsonParser.goodList(parsedJson, "detailsdtllist")
        .map((e) => DetailDtlListModel.fromJson(e))
        .toList();
  }
}

class DetailDtlListModel {
  int Id;
  int balanceqty;
  String budgetreqyn;
  int curstatusbccid;
  String curstatuswefdate;
  String dtlisblockedyn;
  String edityn;
  String itemcode;
  int itemid;
  String itemname;
  String lastmoddate;
  int lastmoduserid;
  int optionid;
  int parenttabledataid;
  int parenttableid;
  double qty;
  int shortcloseqty;
  int tableid;
  int uomid;
  int uomtypebccid;
  int usedqty;
  DepartmentList departmentDtl;
  UomTypes uomDtl;
  DetailDtlListModel.fromJson(Map parsedJson) {
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
    balanceqty = BaseJsonParser.goodInt(parsedJson, "balanceqty");
    budgetreqyn = BaseJsonParser.goodString(parsedJson, "budgetreqyn");
    curstatusbccid = BaseJsonParser.goodInt(parsedJson, "curstatusbccid");
    curstatuswefdate =
        BaseJsonParser.goodString(parsedJson, "curstatuswefdate");
    dtlisblockedyn = BaseJsonParser.goodString(parsedJson, "dtlisblockedyn");
    edityn = BaseJsonParser.goodString(parsedJson, "edityn");
    itemcode = BaseJsonParser.goodString(parsedJson, "itemcode");
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    itemname = BaseJsonParser.goodString(parsedJson, "itemname");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    parenttabledataid = BaseJsonParser.goodInt(parsedJson, "parenttabledataid");
    parenttableid = BaseJsonParser.goodInt(parsedJson, "parenttableid");
    qty = BaseJsonParser.goodDouble(parsedJson, "qty");
    shortcloseqty = BaseJsonParser.goodInt(parsedJson, "shortcloseqty");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    uomid = BaseJsonParser.goodInt(parsedJson, "uomid");
    uomtypebccid = BaseJsonParser.goodInt(parsedJson, "uomtypebccid");
    usedqty = BaseJsonParser.goodInt(parsedJson, "usedqty");
    var departmentDtls = BaseJsonParser.goodList(parsedJson, "departmentlist")
        .map((e) => DepartmentList.fromJson(e))
        .toList();
    var uomDtls = BaseJsonParser.goodList(parsedJson, "uomratedetails")
        .map((e) => UomTypes.fromJson(e))
        .toList();
    departmentDtl = departmentDtls.isNotEmpty ? departmentDtls?.first : null;
    uomDtl = uomDtls.isNotEmpty ? uomDtls?.first : null;
  }
}

class DepartmentList {
  double actual;
  int branchid;
  String budgetdate;
  double budgeted;
  int departmentid;
  int id;
  double inprocess;
  String itemcode;
  int itemid;
  String itemname;
  int qty;
  double rate;
  double remaining;
  int tableid;
  double totalvalue;
  DepartmentList.fromJson(Map parsedJson) {
    actual = BaseJsonParser.goodDouble(parsedJson, "actual");
    branchid = BaseJsonParser.goodInt(parsedJson, "branchid");
    budgetdate = BaseJsonParser.goodString(parsedJson, "budgetdate");
    budgeted = BaseJsonParser.goodDouble(parsedJson, "budgeted");
    departmentid = BaseJsonParser.goodInt(parsedJson, "departmentid");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    inprocess = BaseJsonParser.goodDouble(parsedJson, "inprocess");
    itemcode = BaseJsonParser.goodString(parsedJson, "itemcode");
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    itemname = BaseJsonParser.goodString(parsedJson, "itemname");
    qty = BaseJsonParser.goodInt(parsedJson, "qty");
    rate = BaseJsonParser.goodDouble(parsedJson, "rate");
    remaining = BaseJsonParser.goodDouble(parsedJson, "remaining");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    totalvalue = BaseJsonParser.goodDouble(parsedJson, "totalvalue");
  }
}

class UomRateDetails {
  int uombccid;
  int uomid;
  String uomname;
  UomRateDetails.fromJson(Map parsedJson) {
    uombccid = BaseJsonParser.goodInt(parsedJson, "uombccid");
    uomid = BaseJsonParser.goodInt(parsedJson, "uomid");
    uomname = BaseJsonParser.goodString(parsedJson, "uomname");
  }
}
