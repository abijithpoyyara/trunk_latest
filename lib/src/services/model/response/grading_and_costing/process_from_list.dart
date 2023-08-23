import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class ProcessFromGINListModel extends BaseResponseModel {
  List<ProcessFromGinList> processFromGinList;

  ProcessFromGINListModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    processFromGinList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => ProcessFromGinList.fromJson(e))
        .toList();
  }
}

class ProcessFromGinList {
  int rowno;
  int ginid;
  int gintableid;
  int supplierid;
  int start;
  int limit;
  int totalrecords;
  String suppliername;
  String ginno;
  String gindate;
  String purchaseOderNo;
  String purchaseOderDate;

  ProcessFromGinList.fromJson(Map<String, dynamic> json) {
    ginid = BaseJsonParser.goodInt(json, "ginid");
    gintableid = BaseJsonParser.goodInt(json, "gintableid");
    supplierid = BaseJsonParser.goodInt(json, "supplierid");
    start = BaseJsonParser.goodInt(json, "start");
    limit = BaseJsonParser.goodInt(json, "limit");
    totalrecords = BaseJsonParser.goodInt(json, "totalrecords");
    rowno = BaseJsonParser.goodInt(json, "rowno");
    suppliername = BaseJsonParser.goodString(json, "suppliername");
    ginno = BaseJsonParser.goodString(json, "ginno");
    gindate = BaseJsonParser.goodString(json, "gindate");
    purchaseOderNo = BaseJsonParser.goodString(json, "pono");
    purchaseOderDate = BaseJsonParser.goodString(json, "podate");
  }
}
