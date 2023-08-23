import 'package:base/services.dart';

import '../../../../../utility.dart';

class AddBranchModel extends BaseResponseModel{
  List<AddBranchList> addBranchList;

  AddBranchModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    addBranchList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => AddBranchList.fromJson(e))
        .toList();
  }
}

class AddBranchList{
  String code;
  String name;
  int id;
  int limit;
  int slno;
  int start;
  int tableid;
  AddBranchList({this.id, this.name});
  AddBranchList.fromJson(Map parsedJson) {
    id = BaseJsonParser.goodInt(parsedJson, "id");
    limit = BaseJsonParser.goodInt(parsedJson, "limit");
    slno = BaseJsonParser.goodInt(parsedJson, "slno");
    start = BaseJsonParser.goodInt(parsedJson, "start");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    code = BaseJsonParser.goodString(parsedJson, "code");
    name = BaseJsonParser.goodString(parsedJson, "name");
  }
}