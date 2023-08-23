import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class PaymentViewListModel extends BaseResponseModel {
  List<PaymentViewList> paymentViewList;

  PaymentViewListModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    paymentViewList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => PaymentViewList.fromJson(e))
        .toList();
  }
}

class PaymentViewList {
  int rowno;
  int nextrowno;
  int prevrowno;
  String requestno;
  String requestdate;
  int analysiscodeid;
  String analysisname;
  int requestedamount;
  int paymenttypebccid;
  String paymenttype;
  String status;
  int start;
  int limit;
  int totalrecords;
  int Id;
  PaymentViewList.fromJson(Map parsedJson) {
    rowno = BaseJsonParser.goodInt(parsedJson, "rowno");
    nextrowno = BaseJsonParser.goodInt(parsedJson, "nextrowno");
    prevrowno = BaseJsonParser.goodInt(parsedJson, "prevrowno");
    requestno = BaseJsonParser.goodString(parsedJson, "requestno");
    requestdate = BaseJsonParser.goodString(parsedJson, "requestdate");
    analysiscodeid = BaseJsonParser.goodInt(parsedJson, "analysiscodeid");
    analysisname = BaseJsonParser.goodString(parsedJson, "analysisname");
    requestedamount = BaseJsonParser.goodInt(parsedJson, "requestedamount");
    paymenttypebccid = BaseJsonParser.goodInt(parsedJson, "paymenttypebccid");
    paymenttype = BaseJsonParser.goodString(parsedJson, "paymenttype");
    status = BaseJsonParser.goodString(parsedJson, "status");
    start = BaseJsonParser.goodInt(parsedJson, "start");
    limit = BaseJsonParser.goodInt(parsedJson, "limit");
    totalrecords = BaseJsonParser.goodInt(parsedJson, "totalrecords");
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
  }
}
