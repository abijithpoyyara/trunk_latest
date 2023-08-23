import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class TransTypeLookupModel extends LookupModel {
  TransTypeLookupModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      lookupItems = new List<TransTypeLookupItem>();
      parsedJson['resultObject'].forEach((mod) {
        lookupItems.add(new TransTypeLookupItem.fromJson(mod));
      });
    } else {
      lookupItems = List<TransTypeLookupItem>();
    }
  }
}

class TransTypeLookupItem extends LookupItems {
  int id;
  int limit;
  double nettotal;
  int optionid;
  String purchaseorderdate;
  String purchaseorderno;
  int rowno;
  int start;
  int supplierid;
  String suppliername;
  int tableid;
  int totalrecords;
  TransTypeLookupItem(this.purchaseorderno, this.nettotal, this.id);

  TransTypeLookupItem.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    id = BaseJsonParser.goodInt(json, "id");
    limit = BaseJsonParser.goodInt(json, "limit");
    nettotal = BaseJsonParser.goodDouble(json, "nettotal");
    optionid = BaseJsonParser.goodInt(json, "optionid");
    purchaseorderdate = BaseJsonParser.goodString(json, "purchaseorderdate");
    purchaseorderno = BaseJsonParser.goodString(json, "purchaseorderno");
    rowno = BaseJsonParser.goodInt(json, "rowno");
    start = BaseJsonParser.goodInt(json, "start");
    supplierid = BaseJsonParser.goodInt(json, "supplierid");
    suppliername = BaseJsonParser.goodString(json, "suppliername");
    tableid = BaseJsonParser.goodInt(json, "tableid");
    totalrecords = BaseJsonParser.goodInt(json, "totalrecords");
  }
}
