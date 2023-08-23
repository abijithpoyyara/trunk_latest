//import 'package:base/services.dart';
//import 'package:redstars/utility.dart';
//
//class PendingTransactionDetailModel extends BaseResponseModel {
//  List<PendingTransactionDetailModelList> pendingTransactionDetailModelList;
//
//  PendingTransactionDetailModel.fromJson(Map<String, dynamic> json)
//      : super.fromJson(json) {
//    pendingTransactionDetailModelList = BaseJsonParser.goodList(json, "resultObject")
//        .map((e) => PendingTransactionDetailModelList.fromJson(e))
//        .toList();
//  }
//}
//
//class PendingTransactionDetailModelList {
//  Map<String, dynamic> data;
//  String acccode;
//  String accname;
//  String blockdate;
//  String blockedyn;
//  int branchid;
//  int closingbal;
//  int companyid;
//  String chequeto;
//  int id;
//  int notificationid;
//  int openingbal;
//  double requestedamount;
//  String requestno;
//  String periodfrom;
//  String periodto;
//  String reconciledate;
//  String status;
//  int rowno;
//  String settledate;
//  int tableid;
//  String voucherdate;
//  String voucherno;
//  String transno;
//  String optioncode;
//  String paymenttype;
//  String description;
//  String duedate;
//  int amount;
//  PendingTransactionDetailModelList.fromJson(Map parsedJson) {
//    blockedyn = BaseJsonParser.goodString(parsedJson, "blockedyn");
//    branchid = BaseJsonParser.goodInt(parsedJson, "branchid");
//    chequeto = BaseJsonParser.goodString(parsedJson, "chequeto");
//    notificationid = BaseJsonParser.goodInt(parsedJson, "notificationid");
//    requestedamount = BaseJsonParser.goodDouble(parsedJson, "requestedamount");
//    requestno = BaseJsonParser.goodString(parsedJson, "requestno");
//    rowno = BaseJsonParser.goodInt(parsedJson, "rowno");
//    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
//    settledate = BaseJsonParser.goodString(parsedJson, "settledate");
//    voucherdate = BaseJsonParser.goodString(parsedJson, "voucherdate");
//    voucherno = BaseJsonParser.goodString(parsedJson, "voucherno");
//    companyid = BaseJsonParser.goodInt(parsedJson, "companyid");
//    id = BaseJsonParser.goodInt(parsedJson, "id");
//    acccode = BaseJsonParser.goodString(parsedJson, "acccode");
//    accname = BaseJsonParser.goodString(parsedJson, "acccode");
//    blockdate = BaseJsonParser.goodString(parsedJson, "blockdate");
//    blockedyn = BaseJsonParser.goodString(parsedJson, "blockedyn");
//    branchid = BaseJsonParser.goodInt(parsedJson, "branchid");
//    closingbal = BaseJsonParser.goodInt(parsedJson, "closingbal");
//    openingbal = BaseJsonParser.goodInt(parsedJson, "openingbal");
//    periodfrom = BaseJsonParser.goodString(parsedJson, "periodfrom");
//    periodto = BaseJsonParser.goodString(parsedJson, "periodto");
//    reconciledate = BaseJsonParser.goodString(parsedJson, "reconciledate");
//    status = BaseJsonParser.goodString(parsedJson, "status");
//    amount = BaseJsonParser.goodInt(parsedJson, "amount");
//    description = BaseJsonParser.goodString(parsedJson, "description");
//    duedate = BaseJsonParser.goodString(parsedJson, "duedate");
//    optioncode = BaseJsonParser.goodString(parsedJson, "optioncode");
//    paymenttype = BaseJsonParser.goodString(parsedJson, "paymenttype");
//    transno = BaseJsonParser.goodString(parsedJson, "transno");
//  }
//}
