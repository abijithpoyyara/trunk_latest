import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class GradeLookupModel extends LookupModel {
  GradeLookupModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      lookupItems = new List<GradeLookupItem>();
      parsedJson['resultObject'].forEach((mod) {
        lookupItems.add(new GradeLookupItem.fromJson(mod));
      });
    } else {
      lookupItems = List<GradeLookupItem>();
    }
  }
}

class GradeLookupItem extends LookupItems {
  int id;
  int start;
  int limit;
  int slno;
  int tableid;
  int totalrecords;
  String code;
  String name;
  bool isActive;
  GradeLookupItem({this.id, this.name});
  GradeLookupItem.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = BaseJsonParser.goodInt(json, "id");
    tableid = BaseJsonParser.goodInt(json, "tableid");
    limit = BaseJsonParser.goodInt(json, "limit");
    start = BaseJsonParser.goodInt(json, "start");
    slno = BaseJsonParser.goodInt(json, "slno");
    totalrecords = BaseJsonParser.goodInt(json, "totalrecords");
    code = BaseJsonParser.goodString(json, "code");
    name = BaseJsonParser.goodString(json, "description");
    isActive = BaseJsonParser.goodBoolean(json, "isactive");
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GradeLookupItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          code == other.code;

  @override
  int get hashCode => id.hashCode ^ code.hashCode;
}
