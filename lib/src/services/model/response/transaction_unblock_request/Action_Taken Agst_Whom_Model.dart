
import 'package:base/services.dart';

import '../../../../../utility.dart';


class ActionTakenAgainstwhomm extends BaseResponseModel {
  List<ActionTakenAgainstwhom> actionTakenAgainstwhom;

  ActionTakenAgainstwhomm.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    actionTakenAgainstwhom = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => ActionTakenAgainstwhom.fromJson(e))
        .toList();
  }
}

class ActionTakenAgainstwhom{
  String description;
  int limit;
  String personnelcode;
  int personnelid;
  int rowno;
  int start;
  int totalrecords;
  String type;
  ActionTakenAgainstwhom.fromJson(Map parsedJson) {
    description = BaseJsonParser.goodString(parsedJson, "description");
    limit = BaseJsonParser.goodInt(parsedJson, "limit");
    personnelcode = BaseJsonParser.goodString(parsedJson, "personnelcode");
    personnelid = BaseJsonParser.goodInt(parsedJson, "personnelid");
    rowno = BaseJsonParser.goodInt(parsedJson, "rowno");
    start = BaseJsonParser.goodInt(parsedJson, "start");
    totalrecords = BaseJsonParser.goodInt(parsedJson, "totalrecords");
    type = BaseJsonParser.goodString(parsedJson, "type");
  }
}