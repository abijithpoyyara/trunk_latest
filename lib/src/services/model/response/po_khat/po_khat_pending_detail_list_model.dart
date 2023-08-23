import 'package:base/services.dart';

import '../../../../../utility.dart';

class POKhatDetailListModel extends BaseResponseModel {
  List<POKhatDetailList> pokhatPendingDetailList;

  POKhatDetailListModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    pokhatPendingDetailList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => POKhatDetailList.fromJson(e))
        .toList();
  }
}

class POKhatDetailList {
  int purchaserid;
  String purchasername;
  int optionid;
  int tableid;
  int transactionuniqueid;
  int amendmentno;
  String amendmentdate;
  int amendedfromoptionid;
  int companyid;
  int branchid;
  int finyearid;
  String purchaseorderno;
  String purchaseorderdate;
  int supplierid;
  String duedate;
  String remarks;
  int statusbccid;
  String statuswefdate;
  String recordstatus;
  int lastmoduserid;
  String lastmoddate;
  String interstateyn;
  String isblockedyn;
  int fccurrencyid;
  String fccurrency;
  int lccurrencyid;
  String lccurrency;
  double exchrate;
  int ordertypebccid;
  String paymentmode;
  int createduserid;
  String createddate;
  String ordertype;
  String supplier;
  String purchaseorderaddress1;
  String purchaseorderaddress2;
  String purchaseorderaddress3;
  String location;

  int id;
  List<DetailData> detailsDtls;
  POKhatDetailList.fromJson(Map parsedJson) {
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    transactionuniqueid =
        BaseJsonParser.goodInt(parsedJson, "transactionuniqueid");
    amendmentno = BaseJsonParser.goodInt(parsedJson, "amendmentno");
    amendmentdate = BaseJsonParser.goodString(parsedJson, "amendmentdate");
    amendedfromoptionid =
        BaseJsonParser.goodInt(parsedJson, "amendedfromoptionid");
    companyid = BaseJsonParser.goodInt(parsedJson, "companyid");
    branchid = BaseJsonParser.goodInt(parsedJson, "branchid");
    finyearid = BaseJsonParser.goodInt(parsedJson, "finyearid");
    purchaseorderno = BaseJsonParser.goodString(parsedJson, "purchaseorderno");
    purchaseorderdate =
        BaseJsonParser.goodString(parsedJson, "purchaseorderdate");
    supplierid = BaseJsonParser.goodInt(parsedJson, "supplierid");
    duedate = BaseJsonParser.goodString(parsedJson, "duedate");
    remarks = BaseJsonParser.goodString(parsedJson, "remarks");
    statusbccid = BaseJsonParser.goodInt(parsedJson, "statusbccid");
    statuswefdate = BaseJsonParser.goodString(parsedJson, "statuswefdate");
    recordstatus = BaseJsonParser.goodString(parsedJson, "recordstatus");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    interstateyn = BaseJsonParser.goodString(parsedJson, "interstateyn");
    isblockedyn = BaseJsonParser.goodString(parsedJson, "isblockedyn");
    fccurrencyid = BaseJsonParser.goodInt(parsedJson, "fccurrencyid");
    fccurrency = BaseJsonParser.goodString(parsedJson, "fccurrency");
    lccurrencyid = BaseJsonParser.goodInt(parsedJson, "lccurrencyid");
    lccurrency = BaseJsonParser.goodString(parsedJson, "lccurrency");
    exchrate = BaseJsonParser.goodDouble(parsedJson, "exchrate");
    ordertypebccid = BaseJsonParser.goodInt(parsedJson, "ordertypebccid");
    paymentmode = BaseJsonParser.goodString(parsedJson, "paymentmode");
    createduserid = BaseJsonParser.goodInt(parsedJson, "createduserid");
    createddate = BaseJsonParser.goodString(parsedJson, "createddate");
    ordertype = BaseJsonParser.goodString(parsedJson, "ordertype");
    supplier = BaseJsonParser.goodString(parsedJson, "supplier");
    purchaseorderaddress1 =
        BaseJsonParser.goodString(parsedJson, "purchaseorderaddress1");
    purchaseorderaddress2 =
        BaseJsonParser.goodString(parsedJson, "purchaseorderaddress2");
    purchaseorderaddress3 =
        BaseJsonParser.goodString(parsedJson, "purchaseorderaddress3");
    location = BaseJsonParser.goodString(parsedJson, "location");
    purchaserid = BaseJsonParser.goodInt(parsedJson, "purchaserid");
    purchasername = BaseJsonParser.goodString(parsedJson, "purchasername");
    id = BaseJsonParser.goodInt(parsedJson, "Id");
    detailsDtls = BaseJsonParser.goodList(parsedJson, "detailsdtllist")
        .map((e) => DetailData.fromJson(e))
        .toList();
  }
}

class LocationDtl {
  int id;
  int tableid;
  String dellocation;
  int deliverylocationtableid;
  int deliverylocationtabledataid;
  double qty;
  LocationDtl(
      {this.id,
      this.tableid,
      this.qty,
      this.deliverylocationtabledataid,
      this.deliverylocationtableid,
      this.dellocation});
  LocationDtl.fromJson(Map parsedJson) {
    id = BaseJsonParser.goodInt(parsedJson, "id");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    dellocation = BaseJsonParser.goodString(parsedJson, "dellocation");
    deliverylocationtableid =
        BaseJsonParser.goodInt(parsedJson, "deliverylocationtableid");
    deliverylocationtabledataid =
        BaseJsonParser.goodInt(parsedJson, "deliverylocationtabledataid");
    qty = BaseJsonParser.goodDouble(parsedJson, "qty");
  }
}

class PosrcmappingDtl {
  int id;
  int optionid;
  int tableid;
  int parenttableid;
  int parenttabledataid;
  int reftableid;
  int reftabledataid;
  int generateduomid;
  int generateduomtypebccid;
  int generatedqty;
  int lastmoduserid;
  String lastmoddate;
  int refhdrtableid;
  int refhdrtabledataid;
  PosrcmappingDtl.fromJson(Map parsedJson) {
    id = BaseJsonParser.goodInt(parsedJson, "id");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    parenttableid = BaseJsonParser.goodInt(parsedJson, "parenttableid");
    parenttabledataid = BaseJsonParser.goodInt(parsedJson, "parenttabledataid");
    reftableid = BaseJsonParser.goodInt(parsedJson, "reftableid");
    reftabledataid = BaseJsonParser.goodInt(parsedJson, "reftabledataid");
    generateduomid = BaseJsonParser.goodInt(parsedJson, "generateduomid");
    generateduomtypebccid =
        BaseJsonParser.goodInt(parsedJson, "generateduomtypebccid");
    generatedqty = BaseJsonParser.goodInt(parsedJson, "generatedqty");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    refhdrtableid = BaseJsonParser.goodInt(parsedJson, "refhdrtableid");
    refhdrtabledataid = BaseJsonParser.goodInt(parsedJson, "refhdrtabledataid");
  }
}

class DiscData {
  int itemid;
  String itemname;
  int uomid;
  String uomname;
  int attachmentid;
  String attachmentdescription;
  int attachmentsortorder;
  String discapplicableyn;
  DiscData.fromJson(Map parsedJson) {
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    itemname = BaseJsonParser.goodString(parsedJson, "itemname");
    uomid = BaseJsonParser.goodInt(parsedJson, "uomid");
    uomname = BaseJsonParser.goodString(parsedJson, "uomname");
    attachmentid = BaseJsonParser.goodInt(parsedJson, "attachmentid");
    attachmentdescription =
        BaseJsonParser.goodString(parsedJson, "attachmentdescription");
    attachmentsortorder =
        BaseJsonParser.goodInt(parsedJson, "attachmentsortorder");
    discapplicableyn =
        BaseJsonParser.goodString(parsedJson, "discapplicableyn");
  }
}

class DetailData {
  int optionid;
  int tableid;
  int parenttableid;
  int parenttabledataid;
  int itemid;
  int uomid;
  int uomtypebccid;
  double qty;
  int rate;
  int totalvalue;
  String deliveryduedate;
  int statusbccid;
  String statuswefdate;
  String remarks;
  int lastmoduserid;
  String lastmoddate;
  int totaldiscount;
  int subtotal;
  int tax;
  int nettotal;
  int discaftertax;
  int grosstotal;
  int roundoff;
  int purordaftrrndoff;
  String itemaccessedcode;
  int itemaccessedcodetypebccid;
  int fccurrencyid;
  double exchrate;
  int lcpurordaftrrndoff;
  int approvedqty;
  String dtlisblockedyn;
  int deductedtax;
  int uom;
  String edityn;
  String itemname;
  String itemcode;
  int usedqty;
  int shortcloseqty;
  int balanceqty;
  int reftableid;
  String budgetreqyn;
  int Id;
  DiscData discData;
  List<PosrcmappingDtl> posrcmapDtl;
  List<LocationDtl> location;

  DetailData.fromJson(Map parsedJson) {
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    parenttableid = BaseJsonParser.goodInt(parsedJson, "parenttableid");
    parenttabledataid = BaseJsonParser.goodInt(parsedJson, "parenttabledataid");
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    uomid = BaseJsonParser.goodInt(parsedJson, "uomid");
    uomtypebccid = BaseJsonParser.goodInt(parsedJson, "uomtypebccid");
    qty = BaseJsonParser.goodDouble(parsedJson, "qty");
    rate = BaseJsonParser.goodInt(parsedJson, "rate");
    totalvalue = BaseJsonParser.goodInt(parsedJson, "totalvalue");
    deliveryduedate = BaseJsonParser.goodString(parsedJson, "deliveryduedate");
    statusbccid = BaseJsonParser.goodInt(parsedJson, "statusbccid");
    statuswefdate = BaseJsonParser.goodString(parsedJson, "statuswefdate");
    remarks = BaseJsonParser.goodString(parsedJson, "remarks");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    totaldiscount = BaseJsonParser.goodInt(parsedJson, "totaldiscount");
    subtotal = BaseJsonParser.goodInt(parsedJson, "subtotal");
    tax = BaseJsonParser.goodInt(parsedJson, "tax");
    nettotal = BaseJsonParser.goodInt(parsedJson, "nettotal");
    discaftertax = BaseJsonParser.goodInt(parsedJson, "discaftertax");
    grosstotal = BaseJsonParser.goodInt(parsedJson, "grosstotal");
    roundoff = BaseJsonParser.goodInt(parsedJson, "roundoff");
    purordaftrrndoff = BaseJsonParser.goodInt(parsedJson, "purordaftrrndoff");
    itemaccessedcode =
        BaseJsonParser.goodString(parsedJson, "itemaccessedcode");
    itemaccessedcodetypebccid =
        BaseJsonParser.goodInt(parsedJson, "itemaccessedcodetypebccid");
    fccurrencyid = BaseJsonParser.goodInt(parsedJson, "fccurrencyid");
    exchrate = BaseJsonParser.goodDouble(parsedJson, "exchrate");
    lcpurordaftrrndoff =
        BaseJsonParser.goodInt(parsedJson, "lcpurordaftrrndoff");
    approvedqty = BaseJsonParser.goodInt(parsedJson, "approvedqty");
    dtlisblockedyn = BaseJsonParser.goodString(parsedJson, "dtlisblockedyn");
    deductedtax = BaseJsonParser.goodInt(parsedJson, "deductedtax");
    uom = BaseJsonParser.goodInt(parsedJson, "uom");
    edityn = BaseJsonParser.goodString(parsedJson, "edityn");
    itemname = BaseJsonParser.goodString(parsedJson, "itemname");
    itemcode = BaseJsonParser.goodString(parsedJson, "itemcode");
    usedqty = BaseJsonParser.goodInt(parsedJson, "usedqty");
    shortcloseqty = BaseJsonParser.goodInt(parsedJson, "shortcloseqty");
    balanceqty = BaseJsonParser.goodInt(parsedJson, "balanceqty");
    reftableid = BaseJsonParser.goodInt(parsedJson, "reftableid");
    budgetreqyn = BaseJsonParser.goodString(parsedJson, "budgetreqyn");
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
    location = BaseJsonParser.goodList(parsedJson, "locationdtl")
        .map((e) => LocationDtl.fromJson(e))
        .toList();
    posrcmapDtl = BaseJsonParser.goodList(parsedJson, "posrcmappingdtl")
        .map((e) => PosrcmappingDtl.fromJson(e))
        .toList();
    var discDataDtls = BaseJsonParser.goodList(parsedJson, "discdata")
        .map((e) => DiscData.fromJson(e))
        .toList();
    discData = discDataDtls.isNotEmpty ? discDataDtls?.first : null;
  }
}
