import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class PaymentListModel extends BaseResponseModel {
  List<PaymentListview> paymentReqViewList;
  int SOR_Id;
  int EOR_Id;
  int totalRecords;

  PaymentListModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    paymentReqViewList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => PaymentListview.fromJson(e))
        .toList();
    SOR_Id = json["SOR_Id"];
    EOR_Id = json["EOR_Id"];
    totalRecords = json["TotalRecords"];
  }
}


class PaymentListview {
  int rowno;
  int analysiscodeid;
  int prevrowno;
  int nextid;
  int previd;
  double requestedamount;
  String requestdate;
  String requestno;
  String paymenttype;
  String analysisname;
  String status;
  int start;
  int limit;
  int totalrecords;
  int Id;
  int EOR_Id;
  int SOR_Id;
  int TotalRecords;
  PaymentListview.fromJson(Map parsedJson) {
    rowno = BaseJsonParser.goodInt(parsedJson, "rowno");
    analysiscodeid = BaseJsonParser.goodInt(parsedJson, "analysiscodeid");
    prevrowno = BaseJsonParser.goodInt(parsedJson, "prevrowno");
    nextid = BaseJsonParser.goodInt(parsedJson, "nextid");
    previd = BaseJsonParser.goodInt(parsedJson, "previd");
    requestedamount = BaseJsonParser.goodDouble(parsedJson, "requestedamount");
    requestdate = BaseJsonParser.goodString(parsedJson, "requestdate");
    requestno = BaseJsonParser.goodString(parsedJson, "requestno");
    paymenttype = BaseJsonParser.goodString(parsedJson, "paymenttype");
    analysisname = BaseJsonParser.goodString(parsedJson, "analysisname");
    status = BaseJsonParser.goodString(parsedJson, "status");
    start = BaseJsonParser.goodInt(parsedJson, "start");
    limit = BaseJsonParser.goodInt(parsedJson, "limit");
    totalrecords = BaseJsonParser.goodInt(parsedJson, "totalrecords");
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
    EOR_Id = BaseJsonParser.goodInt(parsedJson, "EOR_Id");
    SOR_Id = BaseJsonParser.goodInt(parsedJson, "SOR_Id");
    TotalRecords = BaseJsonParser.goodInt(parsedJson, "TotalRecords");
  }
}
