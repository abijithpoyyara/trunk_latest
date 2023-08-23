import 'package:base/services.dart';

import '../../../../../utility.dart';

class AddOptionModel extends BaseResponseModel {
  List<AddOptionList> addOptionList;

  AddOptionModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    addOptionList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => AddOptionList.fromJson(e))
        .toList();
  }
}

class AddOptionList {
  String childgroupkey;
  String optioncode;
  String optionname;
  int id;
  int limit;
  int refoptionId;
  AddOptionList({this.optionname, this.id, this.refoptionId});
  AddOptionList.fromJson(Map parsedJson) {
    id = BaseJsonParser.goodInt(parsedJson, "id");
    limit = BaseJsonParser.goodInt(parsedJson, "limit");
    childgroupkey = BaseJsonParser.goodString(parsedJson, "childgroupkey");
    optioncode = BaseJsonParser.goodString(parsedJson, "optioncode");
    optionname = BaseJsonParser.goodString(parsedJson, "optionname");
  }
}
