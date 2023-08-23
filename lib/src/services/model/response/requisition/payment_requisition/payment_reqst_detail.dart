import 'package:base/services.dart';

import '../../../../../../utility.dart';

class PaymentDetailListModel extends BaseResponseModel {
  List<PaymentDetailViewList> paymentDetailViewList;
  int SOR_Id;
  int EOR_Id;
  int totalRecords;

  PaymentDetailListModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    paymentDetailViewList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => PaymentDetailViewList.fromJson(e))
        .toList();
    SOR_Id = json["SOR_Id"];
    EOR_Id = json["EOR_Id"];
    totalRecords = json["TotalRecords"];
  }
}

class PaymentDetailViewList {
  int Id;
  int amendedfromoptionid;
  String amendmentdate;
  int amendmentno;
  int analysiscodeid;
  int analysiscodetypeid;
  String analysisname;
  int approvedby;
  String approveddate;
  int companyid;
  String createddate;
  int createduserid;
  String docapprvlstatus;
  String isblockedyn;
  int optionid;
  String paidto;
  String paymenttype;
  int paymenttypebccid;
  String recordstatus;
  String reftransadate;
  String reftransno;
  String remarks;
  String requestdate;
  double requestedamount;
  String requestno;
  String settlebefore;
  int tableid;
  int transactionuniqueid;
  int transreftabledataid;
  int transreftableid;
  int transtypebccid;
  int transtypeoptionid;
  List<PaymentRequestDtlJson> requestDtlJson;

  PaymentDetailViewList.fromJson(Map parsedJson) {
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
    amendedfromoptionid =
        BaseJsonParser.goodInt(parsedJson, "amendedfromoptionid");
    amendmentdate = BaseJsonParser.goodString(parsedJson, "amendmentdate");
    amendmentno = BaseJsonParser.goodInt(parsedJson, "amendmentno");
    analysiscodeid = BaseJsonParser.goodInt(parsedJson, "analysiscodeid");
    analysiscodetypeid =
        BaseJsonParser.goodInt(parsedJson, "analysiscodetypeid");
    analysisname = BaseJsonParser.goodString(parsedJson, "analysisname");
    approvedby = BaseJsonParser.goodInt(parsedJson, "approvedby");
    approveddate = BaseJsonParser.goodString(parsedJson, "approveddate");
    companyid = BaseJsonParser.goodInt(parsedJson, "companyid");
    createddate = BaseJsonParser.goodString(parsedJson, "createddate");
    createduserid = BaseJsonParser.goodInt(parsedJson, "createduserid");
    docapprvlstatus = BaseJsonParser.goodString(parsedJson, "docapprvlstatus");
    isblockedyn = BaseJsonParser.goodString(parsedJson, "isblockedyn");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    paidto = BaseJsonParser.goodString(parsedJson, "paidto");
    paymenttype = BaseJsonParser.goodString(parsedJson, "paymenttype");
    paymenttypebccid = BaseJsonParser.goodInt(parsedJson, "paymenttypebccid");
    recordstatus = BaseJsonParser.goodString(parsedJson, "recordstatus");
    reftransadate = BaseJsonParser.goodString(parsedJson, "reftransadate");
    reftransno = BaseJsonParser.goodString(parsedJson, "reftransno");
    remarks = BaseJsonParser.goodString(parsedJson, "remarks");
    requestdate = BaseJsonParser.goodString(parsedJson, "requestdate");
    requestedamount = BaseJsonParser.goodDouble(parsedJson, "requestedamount");
    requestno = BaseJsonParser.goodString(parsedJson, "requestno");
    settlebefore = BaseJsonParser.goodString(parsedJson, "settlebefore");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    transactionuniqueid =
        BaseJsonParser.goodInt(parsedJson, "transactionuniqueid");
    transreftabledataid =
        BaseJsonParser.goodInt(parsedJson, "transreftabledataid");
    transreftableid = BaseJsonParser.goodInt(parsedJson, "transreftableid");
    transtypebccid = BaseJsonParser.goodInt(parsedJson, "transtypebccid");
    transtypeoptionid = BaseJsonParser.goodInt(parsedJson, "transtypeoptionid");
    requestDtlJson =
        BaseJsonParser.goodList(parsedJson, "paymentrequestdtljson")
            .map((e) => PaymentRequestDtlJson.fromJson(e))
            .toList();
  }
}

class BudgtDtlJson {
  int accountid;
  double actual;
  int branchid;
  String budgetdate;
  double budgeted;
  int departmentid;
  int id;
  double inprocess;
  double remaining;
  int tableid;
  int totalvalue;
  BudgtDtlJson.fromJson(Map parsedJson) {
    accountid = BaseJsonParser.goodInt(parsedJson, "accountid");
    actual = BaseJsonParser.goodDouble(parsedJson, "actual");
    branchid = BaseJsonParser.goodInt(parsedJson, "branchid");
    budgetdate = BaseJsonParser.goodString(parsedJson, "budgetdate");
    budgeted = BaseJsonParser.goodDouble(parsedJson, "budgeted");
    departmentid = BaseJsonParser.goodInt(parsedJson, "departmentid");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    inprocess = BaseJsonParser.goodDouble(parsedJson, "inprocess");
    remaining = BaseJsonParser.goodDouble(parsedJson, "remaining");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    totalvalue = BaseJsonParser.goodInt(parsedJson, "totalvalue");
  }
}

class PaymentRequestDtlJson {
  int accountid;
  String accountname;
  double amount;
  int attributeid;
  int attributevaluerefid;
  int dtlapprovedby;
  String dtlapproveddate;
  String dtldocapprovalstatus;
  String dtlisblockedyn;
  int id;
  int parenttabledataid;
  int parenttableid;
  int tableid;
  String value;
  List<PaymentReqsourceJson> paymentReqsourceJson;
  List<BudgtDtlJson> budgetDtl;
  PaymentRequestDtlJson.fromJson(Map parsedJson) {
    accountid = BaseJsonParser.goodInt(parsedJson, "accountid");
    accountname = BaseJsonParser.goodString(parsedJson, "accountname");
    amount = BaseJsonParser.goodDouble(parsedJson, "amount");
    attributeid = BaseJsonParser.goodInt(parsedJson, "attributeid");
    attributevaluerefid =
        BaseJsonParser.goodInt(parsedJson, "attributevaluerefid");
    dtlapprovedby = BaseJsonParser.goodInt(parsedJson, "dtlapprovedby");
    dtlapproveddate = BaseJsonParser.goodString(parsedJson, "dtlapproveddate");
    dtldocapprovalstatus =
        BaseJsonParser.goodString(parsedJson, "dtldocapprovalstatus");
    dtlisblockedyn = BaseJsonParser.goodString(parsedJson, "dtlisblockedyn");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    parenttabledataid = BaseJsonParser.goodInt(parsedJson, "parenttabledataid");
    parenttableid = BaseJsonParser.goodInt(parsedJson, "parenttableid");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    value = BaseJsonParser.goodString(parsedJson, "value");
    paymentReqsourceJson =
        BaseJsonParser.goodList(parsedJson, "paymentreqsourcejson")
            .map((e) => PaymentReqsourceJson.fromJson(e))
            .toList();
    budgetDtl = BaseJsonParser.goodList(parsedJson, "budgetdtljson")
        .map((e) => BudgtDtlJson.fromJson(e))
        .toList();
  }
}

class PaymentReqsourceJson {
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
  PaymentReqsourceJson.fromJson(Map parsedJson) {
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
