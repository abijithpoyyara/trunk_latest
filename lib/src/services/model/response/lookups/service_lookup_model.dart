import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class ServiceLookupModel extends LookupModel {
  ServiceLookupModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      lookupItems = new List<ServiceLookupItem>();
      parsedJson['resultObject'].forEach((mod) {
        lookupItems.add(new ServiceLookupItem.fromJson(mod));
      });
    } else {
      lookupItems = List<ServiceLookupItem>();
    }
  }
}

class ServiceLookupItem extends LookupItems {
  String name;
  int rowno;
  int tableid;
  int requestFromTypeBccId;
  ServiceLookupItem(this.name);
  ServiceLookupItem.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    code = BaseJsonParser.goodString(json, "code");
    id = BaseJsonParser.goodInt(json, "id");
    requestFromTypeBccId = BaseJsonParser.goodInt(json, "requestfromtypebccid");
    limit = BaseJsonParser.goodInt(json, "limit");
    name = BaseJsonParser.goodString(json, "name");
    rowno = BaseJsonParser.goodInt(json, "rowno");
    start = BaseJsonParser.goodInt(json, "start");
    tableid = BaseJsonParser.goodInt(json, "tableid");
    totalrecords = BaseJsonParser.goodInt(json, "totalrecords");
  }
}
