import 'package:base/services.dart';

import '../../../../../utility.dart';

class PurchaseOderProcessFillModel extends BaseResponseModel {
  List<PurchaseOrderProcessFill> purchaseOderProcessFillList;

  PurchaseOderProcessFillModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    purchaseOderProcessFillList =
        BaseJsonParser.goodList(parsedJson, "resultObject")
            .map((json) => PurchaseOrderProcessFill.fromJson(json))
            .toList();
  }
}

class PurchaseOrderProcessFill {
  int analysiscodeid;
  int analysiscodetypeid;
  int dtlid;
  String accountfilterflag;
  String paidto;
  int dtltableid;
  int optionid;
  double requestedamount;
  String paidtotypename;
  PurchaseDtlModel dtljson;
  int grnvoucherhdrid;
  int supplieraccountid;
  int supplierid;
  int transtypebccid;

  PurchaseOrderProcessFill.fromJson(Map<String, dynamic> json) {
    analysiscodeid = BaseJsonParser.goodInt(json, "analysiscodeid");
    analysiscodetypeid = BaseJsonParser.goodInt(json, "analysiscodetypeid");
    dtlid = BaseJsonParser.goodInt(json, "dtlid");
    dtltableid = BaseJsonParser.goodInt(json, "dtltableid");
    optionid = BaseJsonParser.goodInt(json, "optionid");
    dtlid = BaseJsonParser.goodInt(json, "dtlid");
    accountfilterflag = BaseJsonParser.goodString(json, "accountfilterflag");
    paidto = BaseJsonParser.goodString(json, "paidto");
    grnvoucherhdrid = BaseJsonParser.goodInt(json, "grnvoucherhdrid");
    supplieraccountid = BaseJsonParser.goodInt(json, "supplieraccountid");
    supplierid = BaseJsonParser.goodInt(json, "supplierid");
    transtypebccid = BaseJsonParser.goodInt(json, "transtypebccid");
    requestedamount = BaseJsonParser.goodDouble(json, "requestedamount");
    paidtotypename = BaseJsonParser.goodString(json, "paidtotypename");
    var pDtls = BaseJsonParser.goodList(json, "dtljson")
        .map((e) => PurchaseDtlModel.fromJson(e))
        .toList();

    dtljson = pDtls.isNotEmpty ? pDtls?.first : null;
  }
}

class PurchaseDtlModel {
  int accountid;
  int id;
  int tableid;
  int parenttabledataid;
  int parenttableid;
  int serviceid;
  String amount;
  String accountname;
  String servicename;
  BudgetDtlModel budgetdtljson;

  PurchaseDtlModel.fromJson(Map<String, dynamic> json) {
    accountid = BaseJsonParser.goodInt(json, "accountid");
    id = BaseJsonParser.goodInt(json, "id");
    tableid = BaseJsonParser.goodInt(json, "tableid");
    parenttabledataid = BaseJsonParser.goodInt(json, "parenttabledataid");
    parenttableid = BaseJsonParser.goodInt(json, "parenttableid");
    serviceid = BaseJsonParser.goodInt(json, "serviceid");
    amount = BaseJsonParser.goodString(json, "amount");
    accountname = BaseJsonParser.goodString(json, "accountname");
    servicename = BaseJsonParser.goodString(json, "servicename");
    budgetdtljson = BaseJsonParser.goodList(json, "budgetdtljson")
        .map((e) => BudgetDtlModel.fromJson(e))
        ?.first;
  }
}

// class CartTaxDtlModel {
//   int itemId;
//   int taxAccountId;
//   double taxPerc;
//   int attachmentId;
//   String attachmentCode;
//   String attachmentDesc;
//   String calculateOn;
//   int sortOrder;
//   int effectOnParty;
//   double taxAppAmt;
//   double taxAmt;
//   double deductedTax;
//
//   CartTaxDtlModel.fromJson(Map<String, dynamic> json) {
//     itemId = BaseJsonParser.goodInt(json, "itemid");
//     taxAccountId = BaseJsonParser.goodInt(json, "taxaccountid");
//     taxPerc = BaseJsonParser.goodDouble(json, "taxperc");
//     attachmentId = BaseJsonParser.goodInt(json, "attachmentid");
//     attachmentCode = BaseJsonParser.goodString(json, "attachmentcode");
//     attachmentDesc = BaseJsonParser.goodString(json, "attachmentdesc");
//     calculateOn = BaseJsonParser.goodString(json, "calculateon");
//     sortOrder = BaseJsonParser.goodInt(json, "sortorder");
//     effectOnParty = BaseJsonParser.goodInt(json, "effectonparty");
//   }
// }

class BudgetDtlModel {
  int accountid;
  int branchid;
  String budgetdate;
  String accountname;
  double actual;
  double budgeted;
  int departmentid;
  double inprocess;
  double remaining;
  bool budgetreqyn;
  int itemid;
  double itemcost;
  int id;

  BudgetDtlModel(
      {this.accountid,
      this.branchid,
      this.budgetdate,
      this.actual,
      this.remaining,
      this.inprocess,
      this.budgeted,
      this.departmentid,
      this.itemid,
      this.itemcost,
      this.id});

  BudgetDtlModel.fromJson(Map<String, dynamic> json) {
    accountid = BaseJsonParser.goodInt(json, "accountid");
    branchid = BaseJsonParser.goodInt(json, "branchid");
    itemid = BaseJsonParser.goodInt(json, "itemid");
    itemcost = BaseJsonParser.goodDouble(json, "itemcost");
    actual = BaseJsonParser.goodDouble(json, "actual");
    budgeted = BaseJsonParser.goodDouble(json, "budgeted");
    departmentid = BaseJsonParser.goodInt(json, "departmentid");
    inprocess = BaseJsonParser.goodDouble(json, "inprocess");
    remaining = BaseJsonParser.goodDouble(json, "remaining");
    budgetreqyn = BaseJsonParser.goodBoolean(json, "budgetreqyn");
  }
}
