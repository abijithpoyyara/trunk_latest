import 'package:base/services.dart';

import '../../../../../utility.dart';

class AnalysisCodeUserModel extends LookupModel {
  AnalysisCodeUserModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      lookupItems = new List<AnalysisCodeModelItem>();
      parsedJson["resultObject"].forEach((mod) {
        lookupItems.add(AnalysisCodeModelItem.fromJson(mod));
      });
    } else {
      lookupItems = new List<AnalysisCodeModelItem>();
    }
  }
}

class AnalysisCodeModelItem extends LookupItems {
  String code;
  String name;
  int id;
  int limit;
  int rowno;
  int start;
  int tableid;
  int totalrecords;

  AnalysisCodeModelItem({this.name, this.code});

  AnalysisCodeModelItem.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    code = BaseJsonParser.goodString(json, "code");
    name = BaseJsonParser.goodString(json, "name");
    id = BaseJsonParser.goodInt(json, "id");
    limit = BaseJsonParser.goodInt(json, "limit");
    rowno = BaseJsonParser.goodInt(json, "rowno");
    start = BaseJsonParser.goodInt(json, "start");
    tableid = BaseJsonParser.goodInt(json, "tableid");
    totalrecords = BaseJsonParser.goodInt(json, "totalrecords");
  }
}
