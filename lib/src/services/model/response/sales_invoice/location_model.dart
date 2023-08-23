import 'package:base/services.dart';

import '../../../../../utility.dart';

class LocationListModel extends BaseResponseModel {
  List<LocationModel> branchList;

  LocationListModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    branchList = BaseJsonParser.goodList(json, "branchDetails")
        .map((e) => LocationModel.fromJson(e))
        .toList();
  }
}

class LocationModel {
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

  LocationModel.fromJson(Map<String, dynamic> json) {
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
}
