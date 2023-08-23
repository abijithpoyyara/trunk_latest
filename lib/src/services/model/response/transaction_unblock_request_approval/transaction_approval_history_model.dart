import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class ApprovalHistoryModel extends BaseResponseModel {
  List<HistoryModel> historyModel;

  ApprovalHistoryModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    historyModel = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => HistoryModel.fromJson(e))
        .toList();
  }
}

class HistoryModel {
  String requestno;
  String requestdate;
  String transno;
  String transdate;
  String createduser;
  String createddate;
  String blockeddate;
  String extendeddate;
  String transstatus;
  String actiontaken;
  String blockedreason;
  String actiontakenagainst;
  List<HistoryDtlJson> historyDtl;

  HistoryModel.fromJson(Map parsedJson) {

    requestno = BaseJsonParser.goodString(parsedJson, "requestno");
    requestdate = BaseJsonParser.goodString(parsedJson, "requestdate");
    transno = BaseJsonParser.goodString(parsedJson, "transno");
    transdate = BaseJsonParser.goodString(parsedJson, "transdate");
    createduser = BaseJsonParser.goodString(parsedJson, "createduser");
    createddate = BaseJsonParser.goodString(parsedJson, "createddate");
    blockeddate = BaseJsonParser.goodString(parsedJson, "blockeddate");
    extendeddate = BaseJsonParser.goodString(parsedJson, "extendeddate");
    transstatus = BaseJsonParser.goodString(parsedJson, "transstatus");
    actiontaken = BaseJsonParser.goodString(parsedJson, "actiontaken");
    blockedreason = BaseJsonParser.goodString(parsedJson, "blockedreason");
    actiontakenagainst = BaseJsonParser.goodString(parsedJson, "actiontakenagainst");
    historyDtl =
        BaseJsonParser.goodList(parsedJson, "historydtljson")
            .map((e) => HistoryDtlJson.fromJson(e))
            .toList();
  }
}

class HistoryDtlJson{
  String useraction;
  String username;
  String actiondate;
  String remarks;
  String extendeddate;
  String transstatus;
  String actiontaken;
  String blockedreason;
  String actiontakenagainst;

  HistoryDtlJson.fromJson(Map parsedJson) {
    useraction = BaseJsonParser.goodString(parsedJson, "useraction");
    extendeddate = BaseJsonParser.goodString(parsedJson, "extendeddate");
    username = BaseJsonParser.goodString(parsedJson, "username");
    actiondate = BaseJsonParser.goodString(parsedJson, "actiondate");
    transstatus = BaseJsonParser.goodString(parsedJson, "transstatus");
    remarks = BaseJsonParser.goodString(parsedJson, "remarks");
    actiontaken = BaseJsonParser.goodString(parsedJson, "actiontaken");
    blockedreason = BaseJsonParser.goodString(parsedJson, "blockedreason");
    actiontakenagainst = BaseJsonParser.goodString(parsedJson, "actiontakenagainst");
  }
}

