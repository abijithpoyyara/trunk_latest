import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class LocationLookupModel extends LookupModel {
  LocationLookupModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      lookupItems = new List<LocationLookUpItem>();
      parsedJson['resultObject']?.forEach((mod) {
        lookupItems.add(new LocationLookUpItem.fromJson(mod));
      });
    } else {
      lookupItems = List<LocationLookUpItem>();
    }
  }
}

class LocationLookUpItem extends LookupItems {
  int stateid;
  int tableid;
  int branchid;
  int businesslevelcodeid;
  int id;
  bool hobranchyn;
  String levelcode;
  String name;
  String branchcode;
  String code;

  String phone;
  String email;
  String location;
  String icon;

  LocationLookUpItem.fromOther(
      {this.code,
      this.id,
      this.icon,
      this.name,
      this.phone,
      this.levelcode,
      this.businesslevelcodeid,
      this.tableid,
      this.branchid,
      this.location,
      this.branchcode,
      this.email,
      this.hobranchyn,
      this.stateid});

  LocationLookUpItem.fromJson(Map<String, dynamic> json) {
    stateid = BaseJsonParser.goodInt(json, "stateid");
    tableid = BaseJsonParser.goodInt(json, "tableid");
    branchid = BaseJsonParser.goodInt(json, "branchid");
    businesslevelcodeid = BaseJsonParser.goodInt(json, "businesslevelcodeid");
    id = BaseJsonParser.goodInt(json, "id");
    hobranchyn = BaseJsonParser.goodBoolean(json, "hobranchyn");
    levelcode = BaseJsonParser.goodString(json, "levelcode");
    name = BaseJsonParser.goodString(json, "name");
    branchcode = BaseJsonParser.goodString(json, "branchcode");
    code = BaseJsonParser.goodString(json, "code");
    phone = BaseJsonParser.goodString(json, "phone");
    email = BaseJsonParser.goodString(json, "email");
    var lat = BaseJsonParser.goodDouble(json, "latitude");
    var lng = BaseJsonParser.goodDouble(json, "longitude");
    location = (lat == null || lng == null)
        ? null
        : "google.navigation:q=$lat,$lng&mode=d";
    icon = BaseJsonParser.goodString(json, "icon");
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocationLookUpItem &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          id == other.id;

  @override
  int get hashCode => code.hashCode ^ id.hashCode;
}
