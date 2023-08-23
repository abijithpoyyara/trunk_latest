import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class BranchListModel extends BaseResponseModel {
  List<BranchList> branchList;

  BranchListModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    branchList = BaseJsonParser.goodList(json, "branchDetails")
        .map((e) => BranchList.fromJson(e))
        .toList();
  }
}

class BranchList {
  int id;
  String code;
  String isactive;
  String name;
  int companyid;
  int optionid;
  int tableid;
  BranchList({this.id,this.name,this.tableid,this.code,this.companyid,this.isactive,this.optionid});

  BranchList.fromJson(Map<String, dynamic> json) {
    isactive = BaseJsonParser.goodString(json, "isactive");
    companyid = BaseJsonParser.goodInt(json, "companyid");
    optionid = BaseJsonParser.goodInt(json, "optionid");
    code = BaseJsonParser.goodString(json, "code");
    id = BaseJsonParser.goodInt(json, "Id");
    name = BaseJsonParser.goodString(json, "name");
    tableid = BaseJsonParser.goodInt(json, "tableid");
  }


}
