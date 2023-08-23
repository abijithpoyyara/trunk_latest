import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class BranchUserListModel extends BaseResponseModel {
  List<UserObject> userObjectlist;
  List<BranchesList> branchesList;

  BranchUserListModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    userObjectlist = BaseJsonParser.goodList(json, "userObj")
        .map((e) => UserObject.fromJson(e))
        .toList();
    branchesList = BaseJsonParser.goodList(json, "branchObj")
        .map((e) => BranchesList.fromJson(e))
        .toList();
    var branchesList1 = BaseJsonParser.goodList(json, "branchObj")
        .map((e) => BranchesList.fromJson(e))
        .toList();

    var idSet = <String>{};
    var distinct = <BranchesList>[];
    for (var d in branchesList1) {
      if (idSet.add(d.name)) {
        distinct.add(d);
      }
    }
    distinct.add(BranchesList(name: "All Branches"));
    branchesList = distinct;
  }
}

class UserObject {
  String code;
  int id;
  String name;
  UserObject.fromJson(Map parsedJson) {
    code = BaseJsonParser.goodString(parsedJson, "code");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    name = BaseJsonParser.goodString(parsedJson, "name");
  }
}

class BranchesList{
  int branchid;
  int businesslevelcodeid;
  String code;
  int id;
  String levelcode;
  String name;
  int rowno;
  int tableid;
  BranchesList({this.code, this.branchid, this.name});
  BranchesList.fromJson(Map parsedJson) {
    branchid = BaseJsonParser.goodInt(parsedJson, "branchid");
    businesslevelcodeid = BaseJsonParser.goodInt(parsedJson, "businesslevelcodeid");
    code = BaseJsonParser.goodString(parsedJson, "code");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    levelcode = BaseJsonParser.goodString(parsedJson, "levelcode");
    name = BaseJsonParser.goodString(parsedJson, "name");
    rowno = BaseJsonParser.goodInt(parsedJson, "rowno");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
  }
}
