import 'package:base/services.dart';

import '../../../../../utility.dart';

class TransactonUnblockReportLIstModel extends BaseResponseModel {
  List<TransactonUnblockReportLIstView> transactonUnblockReportLIstView;

  TransactonUnblockReportLIstModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    transactonUnblockReportLIstView =
        BaseJsonParser.goodList(json, "resultObject")
            .map((e) => TransactonUnblockReportLIstView.fromJson(e))
            .toList();
  }
}

class TransactonUnblockReportLIstView {
  String blockeddate;
  String bussinesslevel;
  int color;
  String extendeddate;
  int groupheader;
  int groupid;
  String groupnodeyn;
  int id;
  String leafyn;
  int limit;
  String notificationitem;
  int parentid;
  int rowno;
  int sortorder;
  int start;
  int totalrecords;
  String transdate;
  String transno;
  String unblockrequestapprovalstatus;
  String unblockrequestapproveddate;
  String unblockrequestapproveduser;
  String unblockrequestdate;
  String unblockrequesteddatetime;
  String unblockrequesteduser;
  String unblockrequestno;

  TransactonUnblockReportLIstView.fromJson(Map parsedJson) {
    blockeddate = BaseJsonParser.goodString(parsedJson, "blockeddate");
    bussinesslevel = BaseJsonParser.goodString(parsedJson, "bussinesslevel");
    color = BaseJsonParser.goodInt(parsedJson, "color");
    extendeddate = BaseJsonParser.goodString(parsedJson, "extendeddate");
    groupheader = BaseJsonParser.goodInt(parsedJson, "groupheader");
    groupid = BaseJsonParser.goodInt(parsedJson, "groupid");
    groupnodeyn = BaseJsonParser.goodString(parsedJson, "groupnodeyn");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    leafyn = BaseJsonParser.goodString(parsedJson, "leafyn");
    limit = BaseJsonParser.goodInt(parsedJson, "limit");
    notificationitem =
        BaseJsonParser.goodString(parsedJson, "notificationitem");
    parentid = BaseJsonParser.goodInt(parsedJson, "parentid");
    rowno = BaseJsonParser.goodInt(parsedJson, "rowno");
    sortorder = BaseJsonParser.goodInt(parsedJson, "sortorder");
    start = BaseJsonParser.goodInt(parsedJson, "start");
    totalrecords = BaseJsonParser.goodInt(parsedJson, "totalrecords");
    transdate = BaseJsonParser.goodString(parsedJson, "transdate");
    transno = BaseJsonParser.goodString(parsedJson, "transno");
    unblockrequestapprovalstatus =
        BaseJsonParser.goodString(parsedJson, "unblockrequestapprovalstatus");
    unblockrequestapproveddate =
        BaseJsonParser.goodString(parsedJson, "unblockrequestapproveddate");
    unblockrequestapproveduser =
        BaseJsonParser.goodString(parsedJson, "unblockrequestapproveduser");
    unblockrequestdate =
        BaseJsonParser.goodString(parsedJson, "unblockrequestdate");
    unblockrequesteddatetime =
        BaseJsonParser.goodString(parsedJson, "unblockrequesteddatetime");
    unblockrequesteduser =
        BaseJsonParser.goodString(parsedJson, "unblockrequesteduser");
    unblockrequestno =
        BaseJsonParser.goodString(parsedJson, "unblockrequestno");
  }
}
