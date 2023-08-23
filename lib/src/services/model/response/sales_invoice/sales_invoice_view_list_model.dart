import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class SalesInvoiceViewListModel extends BaseResponseModel {
  List<SalesInvoiceSavedViewList> salesInvoicelist;
  int SOR_Id;
  int EOR_Id;
  int totalRecords;

  SalesInvoiceViewListModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    salesInvoicelist = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => SalesInvoiceSavedViewList.fromJson(e))
        .toList();
    SOR_Id = json["SOR_Id"];
    EOR_Id = json["EOR_Id"];
    totalRecords = json["TotalRecords"];
  }
}

class SalesInvoiceSavedViewList {
  int Id;
  int customerid;
  String customername;
  String deliveryadd1;
  int limit;
  double nettotal;
  int nextrowno;
  int prevrowno;
  int rowno;
  int start;
  String status;
  int totalrecords;
  String transdate;
  String transno;
  SalesInvoiceSavedViewList.fromJson(Map parsedJson) {
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
    customerid = BaseJsonParser.goodInt(parsedJson, "customerid");
    customername = BaseJsonParser.goodString(parsedJson, "customername");
    deliveryadd1 = BaseJsonParser.goodString(parsedJson, "deliveryadd1");
    limit = BaseJsonParser.goodInt(parsedJson, "limit");
    nettotal = BaseJsonParser.goodDouble(parsedJson, "nettotal");
    nextrowno = BaseJsonParser.goodInt(parsedJson, "nextrowno");
    prevrowno = BaseJsonParser.goodInt(parsedJson, "prevrowno");
    rowno = BaseJsonParser.goodInt(parsedJson, "rowno");
    start = BaseJsonParser.goodInt(parsedJson, "start");
    status = BaseJsonParser.goodString(parsedJson, "status");
    totalrecords = BaseJsonParser.goodInt(parsedJson, "totalrecords");
    transdate = BaseJsonParser.goodString(parsedJson, "transdate");
    transno = BaseJsonParser.goodString(parsedJson, "transno");
  }
}
