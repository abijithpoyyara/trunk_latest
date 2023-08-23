import 'package:base/services.dart';

import '../../../../../utility.dart';

class SalesInvoiceDtlListModel extends BaseResponseModel {
  List<SalesInvoiceDetailList> salesInvoiceDtlList;
  int SOR_Id;
  int EOR_Id;
  int totalRecords;

  SalesInvoiceDtlListModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    salesInvoiceDtlList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => SalesInvoiceDetailList.fromJson(e))
        .toList();
    SOR_Id = json["SOR_Id"];
    EOR_Id = json["EOR_Id"];
    totalRecords = json["TotalRecords"];
  }
}

class SalesInvoiceDetailList {
  int Id;
  int accountid;
  int amendedfromoptionid;
  String amendmentdate;
  int amendmentno;
  int analysiscodeid;
  String analysiscodename;
  int analysiscodetypeid;
  String analysiscodetypename;
  int approvedby;
  String approveddate;
  int branchid;
  int businesslevelcodeid;
  int companyid;
  String createddate;
  int createduserid;
  int customerid;
  String customername;
  int customertypebccid;
  String delduedate;
  String deliveryadd1;
  String deliveryadd2;
  String deliveryadd3;
  String deliveryadd4;
  String docapprvlstatus;
  double exchrate;
  int fccurrencyid;
  int finyearid;
  String fsno;
  String isblockedyn;
  int lccurrencyid;
  String location;
  int optionid;
  String paymentmode;
  String processfrom;
  String recordstatus;
  String referenceno;
  String refinvoicedate;
  String refinvoiceno;
  int reftabledataid;
  int reftableid;
  String remarks;
  int salesmanid;
  int statusbccid;
  String statuswefdate;
  int tableid;
  int transactionuniqueid;
  String transdate;
  String transno;
  List<SalesInvcDtlJson> dtlJson;
  List<VoucherDtlJson> voucherDtl;

  SalesInvoiceDetailList.fromJson(Map parsedJson) {
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
    accountid = BaseJsonParser.goodInt(parsedJson, "accountid");
    amendedfromoptionid =
        BaseJsonParser.goodInt(parsedJson, "amendedfromoptionid");
    amendmentdate = BaseJsonParser.goodString(parsedJson, "amendmentdate");
    amendmentno = BaseJsonParser.goodInt(parsedJson, "amendmentno");
    analysiscodeid = BaseJsonParser.goodInt(parsedJson, "analysiscodeid");
    analysiscodename =
        BaseJsonParser.goodString(parsedJson, "analysiscodename");
    analysiscodetypeid =
        BaseJsonParser.goodInt(parsedJson, "analysiscodetypeid");
    analysiscodetypename =
        BaseJsonParser.goodString(parsedJson, "analysiscodetypename");
    approvedby = BaseJsonParser.goodInt(parsedJson, "approvedby");
    approveddate = BaseJsonParser.goodString(parsedJson, "approveddate");
    branchid = BaseJsonParser.goodInt(parsedJson, "branchid");
    businesslevelcodeid =
        BaseJsonParser.goodInt(parsedJson, "businesslevelcodeid");
    companyid = BaseJsonParser.goodInt(parsedJson, "companyid");
    createddate = BaseJsonParser.goodString(parsedJson, "createddate");
    createduserid = BaseJsonParser.goodInt(parsedJson, "createduserid");
    customerid = BaseJsonParser.goodInt(parsedJson, "customerid");
    customername = BaseJsonParser.goodString(parsedJson, "customername");
    customertypebccid = BaseJsonParser.goodInt(parsedJson, "customertypebccid");
    delduedate = BaseJsonParser.goodString(parsedJson, "delduedate");
    deliveryadd1 = BaseJsonParser.goodString(parsedJson, "deliveryadd1");
    deliveryadd2 = BaseJsonParser.goodString(parsedJson, "deliveryadd2");
    deliveryadd3 = BaseJsonParser.goodString(parsedJson, "deliveryadd3");
    deliveryadd4 = BaseJsonParser.goodString(parsedJson, "deliveryadd4");
    docapprvlstatus = BaseJsonParser.goodString(parsedJson, "docapprvlstatus");
    exchrate = BaseJsonParser.goodDouble(parsedJson, "exchrate");
    fccurrencyid = BaseJsonParser.goodInt(parsedJson, "fccurrencyid");
    finyearid = BaseJsonParser.goodInt(parsedJson, "finyearid");
    fsno = BaseJsonParser.goodString(parsedJson, "fsno");
    isblockedyn = BaseJsonParser.goodString(parsedJson, "isblockedyn");
    lccurrencyid = BaseJsonParser.goodInt(parsedJson, "lccurrencyid");
    location = BaseJsonParser.goodString(parsedJson, "location");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    paymentmode = BaseJsonParser.goodString(parsedJson, "paymentmode");
    processfrom = BaseJsonParser.goodString(parsedJson, "processfrom");
    recordstatus = BaseJsonParser.goodString(parsedJson, "recordstatus");
    referenceno = BaseJsonParser.goodString(parsedJson, "referenceno");
    refinvoicedate = BaseJsonParser.goodString(parsedJson, "refinvoicedate");
    refinvoiceno = BaseJsonParser.goodString(parsedJson, "refinvoiceno");
    reftabledataid = BaseJsonParser.goodInt(parsedJson, "reftabledataid");
    reftableid = BaseJsonParser.goodInt(parsedJson, "reftableid");
    remarks = BaseJsonParser.goodString(parsedJson, "remarks");
    salesmanid = BaseJsonParser.goodInt(parsedJson, "salesmanid");
    statusbccid = BaseJsonParser.goodInt(parsedJson, "statusbccid");
    statuswefdate = BaseJsonParser.goodString(parsedJson, "statuswefdate");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    transactionuniqueid =
        BaseJsonParser.goodInt(parsedJson, "transactionuniqueid");
    transdate = BaseJsonParser.goodString(parsedJson, "transdate");
    transno = BaseJsonParser.goodString(parsedJson, "transno");
    dtlJson = BaseJsonParser.goodList(parsedJson, "salesinvoicedtljson")
        .map((e) => SalesInvcDtlJson.fromJson(e))
        .toList();
    voucherDtl = BaseJsonParser.goodList(parsedJson, "voucherdtljson")
        .map((e) => VoucherDtlJson.fromJson(e))
        .toList();
  }
}

class SalesInvcDtlJson {
  int costrate;
  int discaftertax;
  int exchrate;
  int fccurrencyid;
  int freightcharges;
  int grosstotal;
  int id;
  String ishidden;
  String itemcode;
  int itemid;
  String itemname;
  String itemnametoprint;
  int lccurrencyid;
  int lctotalafterroundoff;
  int nettotal;
  int orginalrate;
  int othercharges;
  int parenttabledataid;
  int parenttableid;
  int qty;
  double rate;
  int rateafterdisc;
  int rateincldtax;
  int ratetypebccid;
  int roundoff;
  int statucbccid;
  String statuswefdate;
  double subtotal;
  int tableid;
  double totalafterroundoff;
  double totalcost;
  int totaldisc;
  int totaltax;
  double totalvalue;
  int uomid;
  int uomtypebccid;
  List<SalesItemBatchDtlJson> batchDtl;
  List<SalesInvoiceSourceDtlJson> sourceDtl;
  SalesInvcDtlJson.fromJson(Map parsedJson) {
    costrate = BaseJsonParser.goodInt(parsedJson, "costrate");
    discaftertax = BaseJsonParser.goodInt(parsedJson, "discaftertax");
    exchrate = BaseJsonParser.goodInt(parsedJson, "exchrate");
    fccurrencyid = BaseJsonParser.goodInt(parsedJson, "fccurrencyid");
    freightcharges = BaseJsonParser.goodInt(parsedJson, "freightcharges");
    grosstotal = BaseJsonParser.goodInt(parsedJson, "grosstotal");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    ishidden = BaseJsonParser.goodString(parsedJson, "ishidden");
    itemcode = BaseJsonParser.goodString(parsedJson, "itemcode");
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    itemname = BaseJsonParser.goodString(parsedJson, "itemname");
    itemnametoprint = BaseJsonParser.goodString(parsedJson, "itemnametoprint");
    lccurrencyid = BaseJsonParser.goodInt(parsedJson, "lccurrencyid");
    lctotalafterroundoff =
        BaseJsonParser.goodInt(parsedJson, "lctotalafterroundoff");
    nettotal = BaseJsonParser.goodInt(parsedJson, "nettotal");
    orginalrate = BaseJsonParser.goodInt(parsedJson, "orginalrate");
    othercharges = BaseJsonParser.goodInt(parsedJson, "othercharges");
    parenttabledataid = BaseJsonParser.goodInt(parsedJson, "parenttabledataid");
    parenttableid = BaseJsonParser.goodInt(parsedJson, "parenttableid");
    qty = BaseJsonParser.goodInt(parsedJson, "qty");
    rate = BaseJsonParser.goodDouble(parsedJson, "rate");
    rateafterdisc = BaseJsonParser.goodInt(parsedJson, "rateafterdisc");
    rateincldtax = BaseJsonParser.goodInt(parsedJson, "rateincldtax");
    ratetypebccid = BaseJsonParser.goodInt(parsedJson, "ratetypebccid");
    roundoff = BaseJsonParser.goodInt(parsedJson, "roundoff");
    statucbccid = BaseJsonParser.goodInt(parsedJson, "statucbccid");
    statuswefdate = BaseJsonParser.goodString(parsedJson, "statuswefdate");
    subtotal = BaseJsonParser.goodDouble(parsedJson, "subtotal");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    totalafterroundoff =
        BaseJsonParser.goodDouble(parsedJson, "totalafterroundoff");
    totalcost = BaseJsonParser.goodDouble(parsedJson, "totalcost");
    totaldisc = BaseJsonParser.goodInt(parsedJson, "totaldisc");
    totaltax = BaseJsonParser.goodInt(parsedJson, "totaltax");
    totalvalue = BaseJsonParser.goodDouble(parsedJson, "totalvalue");
    uomid = BaseJsonParser.goodInt(parsedJson, "uomid");
    uomtypebccid = BaseJsonParser.goodInt(parsedJson, "uomtypebccid");
    batchDtl = BaseJsonParser.goodList(parsedJson, "salesinvoicedtljson")
        .map((e) => SalesItemBatchDtlJson.fromJson(e))
        .toList();
    sourceDtl = BaseJsonParser.goodList(parsedJson, "voucherdtljson")
        .map((e) => SalesInvoiceSourceDtlJson.fromJson(e))
        .toList();
  }
}

class SalesItemBatchDtlJson {
  int amendmentno;
  String batchcode;
  int batchcreatedoptionid;
  String batchdate;
  String batchdescription;
  String createddate;
  int createduserid;
  int id;
  int itembatchid;
  int itemid;
  int itemotheridentificationtabledataid;
  int itemotheridentificationtableid;
  String lastmoddate;
  int lastmoduserid;
  int mrp;
  int nlc;
  int optionid;
  int parenttabledataid;
  int parenttableid;
  String pdiyn;
  int qty;
  String recordstatus;
  int reftabledataid;
  int reftableid;
  int tableid;
  int transactionuniqueid;
  String vehiclebatchyn;
  SalesItemBatchDtlJson.fromJson(Map parsedJson) {
    amendmentno = BaseJsonParser.goodInt(parsedJson, "amendmentno");
    batchcode = BaseJsonParser.goodString(parsedJson, "batchcode");
    batchcreatedoptionid =
        BaseJsonParser.goodInt(parsedJson, "batchcreatedoptionid");
    batchdate = BaseJsonParser.goodString(parsedJson, "batchdate");
    batchdescription =
        BaseJsonParser.goodString(parsedJson, "batchdescription");
    createddate = BaseJsonParser.goodString(parsedJson, "createddate");
    createduserid = BaseJsonParser.goodInt(parsedJson, "createduserid");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    itembatchid = BaseJsonParser.goodInt(parsedJson, "itembatchid");
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    itemotheridentificationtabledataid = BaseJsonParser.goodInt(
        parsedJson, "itemotheridentificationtabledataid");
    itemotheridentificationtableid =
        BaseJsonParser.goodInt(parsedJson, "itemotheridentificationtableid");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    mrp = BaseJsonParser.goodInt(parsedJson, "mrp");
    nlc = BaseJsonParser.goodInt(parsedJson, "nlc");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    parenttabledataid = BaseJsonParser.goodInt(parsedJson, "parenttabledataid");
    parenttableid = BaseJsonParser.goodInt(parsedJson, "parenttableid");
    pdiyn = BaseJsonParser.goodString(parsedJson, "pdiyn");
    qty = BaseJsonParser.goodInt(parsedJson, "qty");
    recordstatus = BaseJsonParser.goodString(parsedJson, "recordstatus");
    reftabledataid = BaseJsonParser.goodInt(parsedJson, "reftabledataid");
    reftableid = BaseJsonParser.goodInt(parsedJson, "reftableid");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    transactionuniqueid =
        BaseJsonParser.goodInt(parsedJson, "transactionuniqueid");
    vehiclebatchyn = BaseJsonParser.goodString(parsedJson, "vehiclebatchyn");
  }
}

class SalesInvoiceSourceDtlJson {
  int generatedqty;
  int generateduomid;
  int generateduomtypebccid;
  int id;
  String lastmoddate;
  int lastmoduserid;
  int optionid;
  int parenttabledataid;
  int parenttableid;
  int refhdrtabledataid;
  int refhdrtableid;
  int reftabledataid;
  int reftableid;
  int tableid;
  SalesInvoiceSourceDtlJson.fromJson(Map parsedJson) {
    generatedqty = BaseJsonParser.goodInt(parsedJson, "generatedqty");
    generateduomid = BaseJsonParser.goodInt(parsedJson, "generateduomid");
    generateduomtypebccid =
        BaseJsonParser.goodInt(parsedJson, "generateduomtypebccid");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    parenttabledataid = BaseJsonParser.goodInt(parsedJson, "parenttabledataid");
    parenttableid = BaseJsonParser.goodInt(parsedJson, "parenttableid");
    refhdrtabledataid = BaseJsonParser.goodInt(parsedJson, "refhdrtabledataid");
    refhdrtableid = BaseJsonParser.goodInt(parsedJson, "refhdrtableid");
    reftabledataid = BaseJsonParser.goodInt(parsedJson, "reftabledataid");
    reftableid = BaseJsonParser.goodInt(parsedJson, "reftableid");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
  }
}

class VoucherDtlJson {
  int vchhdrid;
  int vchhdrtableid;
  VoucherDtlJson.fromJson(Map parsedJson) {
    vchhdrid = BaseJsonParser.goodInt(parsedJson, "vchhdrid");
    vchhdrtableid = BaseJsonParser.goodInt(parsedJson, "vchhdrtableid");
  }
}
