import 'package:base/services.dart';

import '../../../../../utility.dart';

class UnConfirmedTransactionModelNotification extends BaseResponseModel {
  List<UnConfirmedTransactionDetailNotification> unConfirmedTransactionDetailNotification;

  UnConfirmedTransactionModelNotification.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    unConfirmedTransactionDetailNotification =
        BaseJsonParser.goodList(json, "transactiondtl")
            .map((e) => UnConfirmedTransactionDetailNotification.fromJson(e))
            .toList();
  }
}

class UnConfirmedTransactionDetailNotification {
  int rowno;
  int nextrowno;
  int prevrowno;
  int id;
  int tableid;
  int nextid;
  int previd;
  int unconfirmedid;
  int unconfirmedtableid;
  int refoptionid;
  String transno;
  String transdate;
  String partyname;
  double totalvalue;
  String reason;
  int totalrecords;
  String paidfrom;
  String paidto;
  String lastmoddate;
  String settlementdue;
  int settlementduedays;
  String paymentremarks;
  String settlementtype;

  UnConfirmedTransactionDetailNotification.fromJson(Map parsedJson) {
    rowno = BaseJsonParser.goodInt(parsedJson, "rowno");
    nextrowno = BaseJsonParser.goodInt(parsedJson, "nextrowno");
    prevrowno = BaseJsonParser.goodInt(parsedJson, "prevrowno");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    nextid = BaseJsonParser.goodInt(parsedJson, "nextid");
    previd = BaseJsonParser.goodInt(parsedJson, "previd");
    unconfirmedid = BaseJsonParser.goodInt(parsedJson, "unconfirmedid");
    unconfirmedtableid =
        BaseJsonParser.goodInt(parsedJson, "unconfirmedtableid");
    refoptionid = BaseJsonParser.goodInt(parsedJson, "refoptionid");
    transno = BaseJsonParser.goodString(parsedJson, "transno");
    transdate = BaseJsonParser.goodString(parsedJson, "transdate");
    partyname = BaseJsonParser.goodString(parsedJson, "partyname");
    totalvalue = BaseJsonParser.goodDouble(parsedJson, "totalvalue");
    reason = BaseJsonParser.goodString(parsedJson, "reason");
    totalrecords = BaseJsonParser.goodInt(parsedJson, "totalrecords");
    paidfrom = BaseJsonParser.goodString(parsedJson, "paidfrom");
    paidto = BaseJsonParser.goodString(parsedJson, "paidto");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    settlementduedays = BaseJsonParser.goodInt(parsedJson, "settlementduedays");
    settlementdue = BaseJsonParser.goodString(parsedJson, "settlementdue");
    settlementtype = BaseJsonParser.goodString(parsedJson, "settlementtype");
    paymentremarks = BaseJsonParser.goodString(parsedJson, "paymentremarks");
  }
}
