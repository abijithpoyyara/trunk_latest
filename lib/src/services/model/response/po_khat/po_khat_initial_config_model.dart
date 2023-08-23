import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class POkhatConfigModel extends BaseResponseModel {
  List<BCCModel> transportModeTypes;
  List<KhatPurchasers> purchaserObj;

  POkhatConfigModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    transportModeTypes = BaseJsonParser.goodList(parsedJson, "trasportmodeObj")
        .map((e) => BCCModel.fromJson(e))
        .toList();
    purchaserObj = BaseJsonParser.goodList(parsedJson, "purchaserObject")
        .map((e) => KhatPurchasers.fromJson(e))
        .toList();
  }
}

class PurchaserModel {
  int customerid;
  int limit;
  int personnelid;
  int personneltableid;
  int rowno;
  int start;
  int totalrecords;
  int userid;
  String description;
  String mobile;
  String personnelcode;
  PurchaserModel({this.personnelid, this.userid, this.description});
  PurchaserModel.fromJson(Map<String, dynamic> json) {
    customerid = BaseJsonParser.goodInt(json, "customerid");
    limit = BaseJsonParser.goodInt(json, "limit");
    personnelid = BaseJsonParser.goodInt(json, "personnelid");
    personneltableid = BaseJsonParser.goodInt(json, "personneltableid");
    rowno = BaseJsonParser.goodInt(json, "rowno");
    start = BaseJsonParser.goodInt(json, "start");
    totalrecords = BaseJsonParser.goodInt(json, "totalrecords");
    userid = BaseJsonParser.goodInt(json, "userid");
    userid = BaseJsonParser.goodInt(json, "userid");
    description = BaseJsonParser.goodString(json, "description");
    mobile = BaseJsonParser.goodString(json, "mobile");
    personnelcode = BaseJsonParser.goodString(json, "personnelcode");
  }
}

class KhatPurchasers {
  int customerid;
  int limit;
  int personnelid;
  int personneltableid;
  int rowno;
  int start;
  int totalrecords;
  int userid;
  String description;
  String mobile;
  String personnelcode;
  KhatPurchasers.purchaser({this.description});
  KhatPurchasers({this.personnelid, this.description});
  KhatPurchasers.fromJson(Map<String, dynamic> json) {
    customerid = BaseJsonParser.goodInt(json, "customerid");
    limit = BaseJsonParser.goodInt(json, "limit");
    personnelid = BaseJsonParser.goodInt(json, "personnelid");
    personneltableid = BaseJsonParser.goodInt(json, "personneltableid");
    rowno = BaseJsonParser.goodInt(json, "rowno");
    start = BaseJsonParser.goodInt(json, "start");
    totalrecords = BaseJsonParser.goodInt(json, "totalrecords");
    userid = BaseJsonParser.goodInt(json, "userid");
    userid = BaseJsonParser.goodInt(json, "userid");
    description = BaseJsonParser.goodString(json, "description");
    mobile = BaseJsonParser.goodString(json, "mobile");
    personnelcode = BaseJsonParser.goodString(json, "personnelcode");
  }
}
