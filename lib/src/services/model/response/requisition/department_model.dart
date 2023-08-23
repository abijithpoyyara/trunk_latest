import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class DepartmentModel extends BaseResponseModel {
  List<DepartmentItem> departmentList;

  DepartmentModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    departmentList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => DepartmentItem.fromJson(e))
        .toList();
  }
}

class DepartmentItem {
  String code;
  String createddate;
  String description;
  String lastmoddate;
  String isactive;
  int branchid;
  int companyid;
  int createduserid;
  int lastmoduserid;
  int departmentid;

  DepartmentItem({this.departmentid});
  DepartmentItem.fromJson(Map<String, dynamic> json) {
    code = BaseJsonParser.goodString(json, "code");
    description = BaseJsonParser.goodString(json, "description");
    createddate = BaseJsonParser.goodString(json, "createddate");
    lastmoddate = BaseJsonParser.goodString(json, "lastmoddate");
    isactive = BaseJsonParser.goodString(json, "isactive");
    branchid = BaseJsonParser.goodInt(json, "branchid");
    companyid = BaseJsonParser.goodInt(json, "companyid");
    createduserid = BaseJsonParser.goodInt(json, "createduserid");
    lastmoduserid = BaseJsonParser.goodInt(json, "lastmoduserid");
    departmentid = BaseJsonParser.goodInt(json, "departmentid");
  }
}
