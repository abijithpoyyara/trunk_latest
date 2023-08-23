import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/back_dated_entry_permission/add_userList_model.dart';

import '../../../../../utility.dart';

class BackDateViewDetailsModel extends BaseResponseModel {
  List<BackDateViewDetails> viewList;

  BackDateViewDetailsModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    viewList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => BackDateViewDetails.fromJson(e))
        .toList();
  }
}

class BackDateViewDetails {
  int slno;
  int nextrowno;
  int prevrowno;
  int tableid;
  String transno;
  String periodfrom;
  String periodto;
  String validupto;
  int branchid;
  String branchname;
  String optionname;
  int optionid;
  int start;
  int limit;
  int totalrecords;
  int Id;
  List<AddUserList> userList;
  BackDateViewDetails.fromJson(Map parsedJson) {
    slno = BaseJsonParser.goodInt(parsedJson, "slno");
    nextrowno = BaseJsonParser.goodInt(parsedJson, "nextrowno");
    prevrowno = BaseJsonParser.goodInt(parsedJson, "prevrowno");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    transno = BaseJsonParser.goodString(parsedJson, "transno");
    periodfrom = BaseJsonParser.goodString(parsedJson, "periodfrom");
    periodto = BaseJsonParser.goodString(parsedJson, "periodto");
    validupto = BaseJsonParser.goodString(parsedJson, "validupto");
    branchid = BaseJsonParser.goodInt(parsedJson, "branchid");
    branchname = BaseJsonParser.goodString(parsedJson, "branchname");
    optionname = BaseJsonParser.goodString(parsedJson, "optionname");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    start = BaseJsonParser.goodInt(parsedJson, "start");
    limit = BaseJsonParser.goodInt(parsedJson, "limit");
    totalrecords = BaseJsonParser.goodInt(parsedJson, "totalrecords");
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
    userList = BaseJsonParser.goodList(parsedJson, "userlists")
        .map((e) => AddUserList.fromJson(e))
        .toList();
  }
}
