
import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class PendingTransactionReqDetailModel extends BaseResponseModel {
  List<TransUnblockReqDtlModel> transUnblockReqDtlModel = List();

    PendingTransactionReqDetailModel.fromJson(Map<String, dynamic> json)
    : super.fromJson(json) {
    if (json.containsKey("resultObject") && json["resultObject"] != null) {
    json["resultObject"].forEach((data) =>
    transUnblockReqDtlModel.add(TransUnblockReqDtlModel.fromJson(data)));
    }

  }
}



class TransUnblockReqDtlModel {
  Map<String, dynamic> data;
  String chequeto;
  double requestedamount;
  String requestno;
  String settledate;
  String transactiondate;
  String voucherdate;
  String voucherno;
  String unblockrequestno;
  int amount;
  String blockedyn;
  int branchid;
  int companyid;
  String description;
  String duedate;
  int id;
  int notificationid;
  String optioncode;
  String paymenttype;
  int rowno;
  int tableid;
  int transunblockrequestid;
  int unblockrequestreftableid;
  int unblockrequestreftabledataid;
  String transactionno;
  String blockagedate;
  String requestdate;
  String requestedperson;
  String requesteddatetime;
  String transno;
  String acccode;
  String accname;
  String blockdate;
  double closingbal;
  double openingbal;
  String periodfrom;
  String periodto;
  String reconciledate;
  String status;
  String actiontaken;
  String blockedreason;
  String actiontakenagainst;
  String transreqyn;

  TransUnblockReqDtlModel.fromJson(Map parsedJson) {
    chequeto = BaseJsonParser.goodString(parsedJson, "chequeto");
    unblockrequestno =
        BaseJsonParser.goodString(parsedJson, "unblockrequestno");
    requestdate = BaseJsonParser.goodString(parsedJson, "requestdate");
    blockagedate = BaseJsonParser.goodString(parsedJson, "blockagedate");
    requestedperson = BaseJsonParser.goodString(parsedJson, "requestedperson");
    requesteddatetime =
        BaseJsonParser.goodString(parsedJson, "requesteddatetime");
    actiontaken = BaseJsonParser.goodString(parsedJson, "actiontaken");
    blockedreason = BaseJsonParser.goodString(parsedJson, "blockedreason");
    actiontakenagainst =
        BaseJsonParser.goodString(parsedJson, "actiontakenagainst");
    requestedamount = BaseJsonParser.goodDouble(parsedJson, "requestedamount");
    requestno = BaseJsonParser.goodString(parsedJson, "requestno");
    settledate = BaseJsonParser.goodString(parsedJson, "settledate");
    transactiondate = BaseJsonParser.goodString(parsedJson, "transactiondate");
    voucherdate = BaseJsonParser.goodString(parsedJson, "voucherdate");
    voucherno = BaseJsonParser.goodString(parsedJson, "voucherno");
    amount = BaseJsonParser.goodInt(parsedJson, "amount");
    blockedyn = BaseJsonParser.goodString(parsedJson, "blockedyn");
    branchid = BaseJsonParser.goodInt(parsedJson, "branchid");
    transunblockrequestid =
        BaseJsonParser.goodInt(parsedJson, "transunblockrequestid");
    unblockrequestreftableid =
        BaseJsonParser.goodInt(parsedJson, "unblockrequestreftableid");
    unblockrequestreftabledataid =
        BaseJsonParser.goodInt(parsedJson, "unblockrequestreftabledataid");
    companyid = BaseJsonParser.goodInt(parsedJson, "companyid");
    transreqyn = BaseJsonParser.goodString(parsedJson, "transreqyn");
    description = BaseJsonParser.goodString(parsedJson, "description");
    duedate = BaseJsonParser.goodString(parsedJson, "duedate");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    notificationid = BaseJsonParser.goodInt(parsedJson, "notificationid");
    optioncode = BaseJsonParser.goodString(parsedJson, "optioncode");
    paymenttype = BaseJsonParser.goodString(parsedJson, "paymenttype");
    rowno = BaseJsonParser.goodInt(parsedJson, "rowno");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    transactionno = BaseJsonParser.goodString(parsedJson, "transactionno");
    transno = BaseJsonParser.goodString(parsedJson, "transno");
    acccode = BaseJsonParser.goodString(parsedJson, "acccode");
    accname = BaseJsonParser.goodString(parsedJson, "accname");
    blockdate = BaseJsonParser.goodString(parsedJson, "blockdate");
    closingbal = BaseJsonParser.goodDouble(parsedJson, "closingbal");
    openingbal = BaseJsonParser.goodDouble(parsedJson, "openingbal");
    periodfrom = BaseJsonParser.goodString(parsedJson, "periodfrom");
    periodto = BaseJsonParser.goodString(parsedJson, "periodto");
    reconciledate = BaseJsonParser.goodString(parsedJson, "reconciledate");
    status = BaseJsonParser.goodString(parsedJson, "status");
    data = parsedJson;
  }
}
