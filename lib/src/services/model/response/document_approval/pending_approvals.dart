import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:flutter/material.dart';

class PendingApprovals extends BaseResponseModel {
  PendingItems itemList;

  PendingApprovals.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson.containsKey("resultObject") &&
        parsedJson["resultObject"] != null) {
      itemList = PendingItems.cast(parsedJson["resultObject"][0]);
    }
  }
}

class PendingItems {
  List<Map<String, dynamic>> transactionDtlMap;
  List<TransactionDetails> transactionDtl;
  List<DocumentConfigDtl> documentConfigDtl;
  List alertConfigDtl;
  String tableName;
  String transactionDtlTableName;
  int optionId;

  PendingItems.cast(Map<String, dynamic> json) {
    transactionDtl = List();
    transactionDtlMap = List();
    documentConfigDtl = List();
    alertConfigDtl = List();
    optionId = BaseJsonParser.goodInt(json, "optionid");
    if (json.containsKey("transactiondtl"))
      json["transactiondtl"]?.forEach((obj) => {
            transactionDtlMap.add(Map.from(obj)),
            transactionDtl.add(TransactionDetails.fromJson(obj, optionId))
          });

    if (json.containsKey("documentconfigdtl"))
      json["documentconfigdtl"]?.forEach(
          (obj) => documentConfigDtl.add(DocumentConfigDtl.fromJson(obj)));

    tableName = BaseJsonParser.goodString(json, "tablename");
    transactionDtlTableName =
        BaseJsonParser.goodString(json, "transactiondtltablename");
  }
}

class DocumentConfigDtl {
  int id;
  int approvalRejectionBccId;
  int levelNoBccid;
  int minPersonToApprove;
  double amountRageFrom;
  double amountRageTo;
  bool isCommentMandatory;
  bool isAmountBasedApproval;
  bool isCentralizedApproval;

  DocumentConfigDtl.fromJson(Map<String, dynamic> json) {
    id = BaseJsonParser.goodInt(json, "id");
    approvalRejectionBccId =
        BaseJsonParser.goodInt(json, "approvalrejectionbccid");
    levelNoBccid = BaseJsonParser.goodInt(json, "levelnobccid");
    minPersonToApprove = BaseJsonParser.goodInt(json, "minpersontoapprove");
    amountRageFrom = BaseJsonParser.goodDouble(json, "amountragefrom");
    amountRageTo = BaseJsonParser.goodDouble(json, "amountrageto");
    isCommentMandatory =
        BaseJsonParser.goodString(json, "iscommentmandatoryyn").contains("Y");
    isAmountBasedApproval =
        BaseJsonParser.goodString(json, "isamountbasedapprovalyn")
            .contains("Y");
    isCentralizedApproval =
        BaseJsonParser.goodString(json, "iscentralizedapprovalyn")
            .contains("Y");
  }
}

class TransactionDetails {
  Map<String, dynamic> data;

  int refTableDataId;
  int refTableId;
  String transNo;
  String transDate;
  String optionName;
  int optionId;
  String emailTo;
  int levelTypeBccId;
  String currentLevel;
  int currApprovedNo;
  int maxLevelId;
  String maxLevel;
  double totalValue;
  String reference;
  String transLastModDate;
  String narration;
  String refNo;
  String refDate;
  int optionColor;
  int optionIcon;
  bool hasAttachments;
  int docCount;
  Color color;

//  List<TransactionApprovalList> historyDtl;

  TransactionDetails.fromJson(Map<String, dynamic> json, int optionId) {
    refTableDataId = BaseJsonParser.goodInt(json, "reftabledataid");
    refTableId = BaseJsonParser.goodInt(json, "reftableid");
    transNo = BaseJsonParser.goodString(json, "transno");
    transDate = BaseJsonParser.goodString(json, "transdate");
    optionName = BaseJsonParser.goodString(json, "optionname");
    emailTo = BaseJsonParser.goodString(json, "emailto");
    levelTypeBccId = BaseJsonParser.goodInt(json, "leveltypebccid");
    currentLevel = BaseJsonParser.goodString(json, "currentlevel");
    currApprovedNo = BaseJsonParser.goodInt(json, "currapprovedno");
    maxLevelId = BaseJsonParser.goodInt(json, "maxlevelid");
    maxLevel = BaseJsonParser.goodString(json, "maxlevel");
    totalValue = BaseJsonParser.goodDouble(json, "totalvalue");
    reference = BaseJsonParser.goodString(json, "reference");
    transLastModDate = BaseJsonParser.goodString(json, "translastmoddate");
    narration = BaseJsonParser.goodString(json, "narration");
    refNo = BaseJsonParser.goodString(json, "refno");
    refDate = BaseJsonParser.goodString(json, "refdate");
    optionColor = BaseJsonParser.goodHexInt(json, "color") ??
        BaseJsonParser.goodHex("0XFF6200EA");
    optionIcon = BaseJsonParser.goodInt(json, "icon") ?? 59700;
    this.optionId = optionId;
    this.data = json;

    docCount = BaseJsonParser.goodInt(json, "doccount");
    hasAttachments = BaseJsonParser.goodBoolean(json, "docattachreqyn");

//    historyDtl = List();
//    if (json.containsKey("historydtl") && json["historydtl"] != null)
//      json["historydtl"]
//          .map((tranApp) => TransactionApprovalList.fromJson(tranApp))
//          .toList();
  }

  @override
  String toString() {
    return "refTableDataId : $refTableDataId"
        "refTableId : $refTableId"
        "transNo : $transNo"
        "transDate : $transDate"
        "optionName : $optionName"
        "optionId : $optionId"
        "emailTo : $emailTo"
        "levelTypeBccId : $levelTypeBccId"
        "currentLevel : $currentLevel"
        "currApprovedNo : $currApprovedNo"
        "maxLevelId : $maxLevelId"
        "maxLevel : $maxLevel"
        "totalValue : $totalValue"
        "reference : $reference"
        "transLastModDate : $transLastModDate"
        "narration : $narration"
        "refNo : $refNo"
        "refDate : $refDate";
//        "historyDtl : $historyDtl";
  }
}

class UncTransactionDetails {
  Map<String, dynamic> data;

  int refTableDataId;
  int refTableId;
  String transNo;
  String transDate;
  String optionName;
  int optionId;
  String emailTo;
  int levelTypeBccId;
  String currentLevel;
  int currApprovedNo;
  int maxLevelId;
  String maxLevel;
  num totalValue;
  String settlementdue;
  String transLastModDate;
  String paidfrom;
  String paidto;
  int settlementduedays;
  String paymentremarks;
  String settlementtype;
  String partyname;
  String reason;
  int optionColor;
  int optionIcon;
  bool hasAttachments;
  int unconfirmedid;
  int unconfirmedtableid;
  int tableid;
  int id;
  int reoptionId;
  String lastmoddate;

  int docCount;
  Color color;
  UncTransactionDetails(
      {this.transNo,
      this.optionName,
      this.emailTo,
      this.paymentremarks,
      this.settlementdue,
      this.settlementduedays,
      this.settlementtype,
      this.paidfrom,
      this.paidto,
      this.totalValue,
      this.transDate,
      this.partyname,
      this.id,
      this.optionId,
      this.tableid,
      this.unconfirmedid,
      this.unconfirmedtableid,
      this.reoptionId,
      this.lastmoddate,
      this.reason});

//  List<TransactionApprovalList> historyDtl;

  factory UncTransactionDetails.fromJson(Map<String, dynamic> json) =>
      UncTransactionDetails(
        transNo: json["transno"],
        optionName: json["optionname"],
        emailTo: json["emailto"],
        totalValue: json["totalvalue"],
        transDate: json["transdate"],
        paidfrom: json["paidfrom"],
        paidto: json["paidto"],
        reason: json["reason"],
        partyname: json["partyname"],
        settlementdue: json["settlementdue"],
        settlementduedays: json["settlementduedays"],
        paymentremarks: json["paymentremarks"],
        settlementtype: json["settlementtype"],
        id: json["id"],
        reoptionId: json["refoptionid"],
        unconfirmedtableid: json["unconfirmedtableid"],
        unconfirmedid: json["unconfirmedid"],
        tableid: json["tableid"],
        lastmoddate: json["lastmoddate"],
      );

  @override
  String toString() {
    return "refTableDataId : $refTableDataId"
        "refTableId : $refTableId"
        "transNo : $transNo"
        "transDate : $transDate"
        "optionName : $optionName"
        "optionId : $optionId"
        "emailTo : $emailTo"
        "levelTypeBccId : $levelTypeBccId"
        "currentLevel : $currentLevel"
        "currApprovedNo : $currApprovedNo"
        "maxLevelId : $maxLevelId"
        "maxLevel : $maxLevel"
        "totalValue : $totalValue"
        "transLastModDate : $transLastModDate";

//        "historyDtl : $historyDtl";
  }
}
