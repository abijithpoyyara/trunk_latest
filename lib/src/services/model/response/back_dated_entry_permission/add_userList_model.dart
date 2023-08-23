import 'package:base/services.dart';

import '../../../../../utility.dart';

class AddUserListModel extends BaseResponseModel {
  List<AddUserList> addUserList;

  AddUserListModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    addUserList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => AddUserList.fromJson(e))
        .toList();
  }
}

class AddUserList {
  String code;
  String name;
  int id;
  int userid;
  int limit;
  int slno;
  int start;
  int totalrecords;
  bool isSelected = false;

  AddUserList({this.id, this.name, this.isSelected});

  AddUserList.fromJson(Map parsedJson) {
    id = BaseJsonParser.goodInt(parsedJson, "id");
    userid = BaseJsonParser.goodInt(parsedJson, "userid");
    limit = BaseJsonParser.goodInt(parsedJson, "limit");
    slno = BaseJsonParser.goodInt(parsedJson, "slno");
    totalrecords = BaseJsonParser.goodInt(parsedJson, "totalrecords");
    start = BaseJsonParser.goodInt(parsedJson, "start");
    code = BaseJsonParser.goodString(parsedJson, "code");
    name = BaseJsonParser.goodString(parsedJson, "name");
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AddUserList &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          userid == other.userid;

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ userid.hashCode;
}
