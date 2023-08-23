import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_userList_model.dart';

import '../../../../../utility.dart';

class BackDateEntryDetailModel extends BaseResponseModel {
  List<BackDateEntryDetailList> viewList;

  BackDateEntryDetailModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    viewList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => BackDateEntryDetailList.fromJson(e))
        .toList();
  }
}

class BackDateEntryDetailList {
  String branchname;
  String createddate;
  String lastmoddate;
  String optionname;
  String periodfrom;
  String periodto;
  String recordstatus;
  String transno;
  String validupto;
  int Id;
  int branchid;
  int createduserid;
  int lastmoduserid;
  int optionid;
  int refoptionid;
  int tableid;
  List<AddUserList> userList;
  BackDateEntryDetailList({this.optionname, this.branchname, this.userList});
  BackDateEntryDetailList.fromJson(Map parsedJson) {
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    branchid = BaseJsonParser.goodInt(parsedJson, "branchid");
    createduserid = BaseJsonParser.goodInt(parsedJson, "createduserid");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    refoptionid = BaseJsonParser.goodInt(parsedJson, "refoptionid");
    branchname = BaseJsonParser.goodString(parsedJson, "branchname");
    validupto = BaseJsonParser.goodString(parsedJson, "validupto");
    transno = BaseJsonParser.goodString(parsedJson, "transno");
    createddate = BaseJsonParser.goodString(parsedJson, "createddate");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    optionname = BaseJsonParser.goodString(parsedJson, "optionname");
    periodfrom = BaseJsonParser.goodString(parsedJson, "periodfrom");
    periodto = BaseJsonParser.goodString(parsedJson, "periodto");
    recordstatus = BaseJsonParser.goodString(parsedJson, "recordstatus");
    userList = BaseJsonParser.goodList(parsedJson, "userlists")
        .map((e) => AddUserList.fromJson(e))
        .toList();
  }
}

class UserListModel {
  String code;
  String name;
  int id;
  UserListModel.fromJson(Map parsedJson) {
    code = BaseJsonParser.goodString(parsedJson, "code");
    name = BaseJsonParser.goodString(parsedJson, "name");
    id = BaseJsonParser.goodInt(parsedJson, "userid");
  }
}
