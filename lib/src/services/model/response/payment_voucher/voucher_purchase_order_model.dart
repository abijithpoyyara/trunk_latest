import 'package:base/services.dart';

import '../../../../../utility.dart';

class VoucherPurchaseOderModel extends BaseResponseModel {
  List<VoucherPurchaseOder> voucherPurchaseOrderList;

  VoucherPurchaseOderModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    voucherPurchaseOrderList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => VoucherPurchaseOder.fromJson(e))
        .toList();
  }
}

class VoucherPurchaseOder {
  int dtlid;
  int dtltableid;
  int limit;
  int optionid;
  int paymenttypebccid;
  int reftabledataid;
  int reftableid;
  int rowno;
  int start;
  int totalrecords;
  int totalvalue;
  String accountfilterflag;
  String paymenttype;
  String processfromfillyn;
  String referenceno;
  String servicereqyn;
  String suppliername;
  String transactiondate;
  String transno;

  VoucherPurchaseOder.fromJson(Map<String, dynamic> json) {
    dtlid = BaseJsonParser.goodInt(json, "dtlid");
    dtltableid = BaseJsonParser.goodInt(json, "dtltableid");
    limit = BaseJsonParser.goodInt(json, "limit");
    optionid = BaseJsonParser.goodInt(json, "optionid");
    paymenttypebccid = BaseJsonParser.goodInt(json, "paymenttypebccid");
    reftabledataid = BaseJsonParser.goodInt(json, "reftabledataid");
    reftableid = BaseJsonParser.goodInt(json, "reftableid");
    rowno = BaseJsonParser.goodInt(json, "rowno");
    start = BaseJsonParser.goodInt(json, "start");
    totalrecords = BaseJsonParser.goodInt(json, "totalrecords");
    totalvalue = BaseJsonParser.goodInt(json, "totalvalue");
    servicereqyn = BaseJsonParser.goodString(json, "servicereqyn");
    accountfilterflag = BaseJsonParser.goodString(json, "accountfilterflag");
    paymenttype = BaseJsonParser.goodString(json, "paymenttype");
    processfromfillyn = BaseJsonParser.goodString(json, "processfromfillyn");
    referenceno = BaseJsonParser.goodString(json, "referenceno");
    suppliername = BaseJsonParser.goodString(json, "suppliername");
    transactiondate = BaseJsonParser.goodString(json, "transactiondate");
    transno = BaseJsonParser.goodString(json, "transno");
  }
}
