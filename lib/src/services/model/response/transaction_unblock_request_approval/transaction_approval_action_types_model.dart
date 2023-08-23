import 'package:base/services.dart';

import '../../../../../utility.dart';

class ActionModel extends BaseResponseModel {
  List<ActionTaken> actonTaken;

  ActionModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    actonTaken = BaseJsonParser.goodList(json, "appTypeDetails")
        .map((e) => ActionTaken.fromJson(e))
        .toList();
  }
}

class ActionTaken {
  String code;
  String description;
  String fieldcodename;
  int id;
  int slno;
  int sortorder;
  String tablecode;
  int tableid;
  ActionTaken.fromJson(Map parsedJson) {
    code = BaseJsonParser.goodString(parsedJson, "code");
    description = BaseJsonParser.goodString(parsedJson, "description");
    fieldcodename = BaseJsonParser.goodString(parsedJson, "fieldcodename");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    slno = BaseJsonParser.goodInt(parsedJson, "slno");
    sortorder = BaseJsonParser.goodInt(parsedJson, "sortorder");
    tablecode = BaseJsonParser.goodString(parsedJson, "tablecode");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
  }
}
