import 'package:base/services.dart';
import 'package:flutter/material.dart';

import '../../../../../utility.dart';

class TransactionUnblockListHead1 extends BaseResponseModel {
  List<TransactionUnblockListView> transactionUnblockListView=List();
  var data123;
  TransactionUnblockListHead1.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    if (json.containsKey("resultObject") &&
        json["resultObject"] != null) {
      data123=json["resultObject"];
      json["resultObject"].forEach(
              (data) => transactionUnblockListView.add(TransactionUnblockListView.fromJson(data)));
    }
  }
}

class TransactionUnblockListView {
  Map<String,dynamic> data;
  String actiontaken;
  String actiontakenagainst;
  String blockeddate;
  String blockedreason;
  String blockedyn;
  int branchid;
  String chequeto;
  int companyid;
  String docapprvlstatus;
  List<Filtercountdtls> filtercountdtls;
  int id;
  String description;
  int notificationid;
  double requestedamount;
  String requestno;
  int rowno;
  String transdate;
  String transno;
  int transunblockrequestid;
  int transunblockrequesttableid;
  String unblockrequestdate;
  String unblockrequesteddatetime;
  String unblockrequestedperson;
  int unblockrequestedpersonid;
  String unblockrequestno;
  int unblockrequestreftabledataid;
  int unblockrequestreftableid;
  Color color;
  var approval_result;
  int requestoptionid;
  var s;
  TransactionUnblockListView.fromJson(Map parsedJson) {
    this.approval_result = parsedJson;
    this.s = parsedJson["resultObject"];

    actiontaken = BaseJsonParser.goodString(parsedJson, "actiontaken");
    description = BaseJsonParser.goodString(parsedJson, "description");
    actiontakenagainst =
        BaseJsonParser.goodString(parsedJson, "actiontakenagainst");
    blockeddate = BaseJsonParser.goodString(parsedJson, "blockeddate");
    blockedreason = BaseJsonParser.goodString(parsedJson, "blockedreason");
    blockedyn = BaseJsonParser.goodString(parsedJson, "blockedyn");
    branchid = BaseJsonParser.goodInt(parsedJson, "branchid");
    chequeto = BaseJsonParser.goodString(parsedJson, "chequeto");
    companyid = BaseJsonParser.goodInt(parsedJson, "companyid");
    docapprvlstatus = BaseJsonParser.goodString(parsedJson, "docapprvlstatus");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    notificationid = BaseJsonParser.goodInt(parsedJson, "notificationid");
    requestedamount = BaseJsonParser.goodDouble(parsedJson, "requestedamount");
    requestno = BaseJsonParser.goodString(parsedJson, "requestno");
    rowno = BaseJsonParser.goodInt(parsedJson, "rowno");
    transdate = BaseJsonParser.goodString(parsedJson, "transdate");
    transno = BaseJsonParser.goodString(parsedJson, "transno");
    transunblockrequestid =
        BaseJsonParser.goodInt(parsedJson, "transunblockrequestid");
    transunblockrequesttableid =
        BaseJsonParser.goodInt(parsedJson, "transunblockrequesttableid");
    unblockrequestdate =
        BaseJsonParser.goodString(parsedJson, "unblockrequestdate");
    unblockrequesteddatetime =
        BaseJsonParser.goodString(parsedJson, "unblockrequesteddatetime");
    unblockrequestedperson =
        BaseJsonParser.goodString(parsedJson, "unblockrequestedperson");
    unblockrequestedpersonid =
        BaseJsonParser.goodInt(parsedJson, "unblockrequestedpersonid");
    unblockrequestno =
        BaseJsonParser.goodString(parsedJson, "unblockrequestno");
    unblockrequestreftabledataid =
        BaseJsonParser.goodInt(parsedJson, "unblockrequestreftabledataid");
    unblockrequestreftableid =
        BaseJsonParser.goodInt(parsedJson, "unblockrequestreftableid");
    requestoptionid = BaseJsonParser.goodInt(parsedJson, "requestoptionid");
    filtercountdtls = BaseJsonParser.goodList(parsedJson, "filtercountdtls")
        .map((e) => Filtercountdtls.fromJson(e))
        .toList();
    this.data=parsedJson;
  }

  @override
  String toString() {
    return "actiontaken : $actiontaken"
        "description : $description"
        "actiontakenagainst : $actiontakenagainst"
        "blockeddate : $blockeddate"
        "blockedreason : $blockedreason"
        "blockedyn : $blockedyn"
        "branchid : $branchid"
        "chequeto : $chequeto"
        "companyid : $companyid"
        "docapprvlstatus : $docapprvlstatus"
        "id : $id"
        "notificationid : $notificationid"
        "requestedamount : $requestedamount"
        "rowno : $rowno"
        "transdate : $transdate"
        "transno : $transno"
        "transunblockrequestid : $transunblockrequestid"
        "transunblockrequesttableid : $transunblockrequesttableid"
        "unblockrequestdate : $unblockrequestdate"
        "unblockrequestedperson : $unblockrequestedperson"
        "unblockrequestedpersonid : $unblockrequestedpersonid"
        "unblockrequestno : $unblockrequestno"
        "unblockrequestreftabledataid : $unblockrequestreftabledataid"
        "unblockrequestreftableid : $unblockrequestreftableid"
        "requestoptionid : $requestoptionid";
  }
}

class Filtercountdtls {
  String code;
  int count;
  int id;
  String reportengineformatcode;
  int reportengineformatid;
  int tableid;
  String title;
  Filtercountdtls.fromJson(Map parsedJson) {
    code = BaseJsonParser.goodString(parsedJson, "code");
    count = BaseJsonParser.goodInt(parsedJson, "count");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    reportengineformatcode =
        BaseJsonParser.goodString(parsedJson, "reportengineformatcode");
    reportengineformatid =
        BaseJsonParser.goodInt(parsedJson, "reportengineformatid");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    title = BaseJsonParser.goodString(parsedJson, "title");
  }
}
