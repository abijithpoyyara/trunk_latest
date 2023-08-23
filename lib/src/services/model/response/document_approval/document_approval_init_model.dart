import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:redstars/src/services/model/response/document_approval/document_report_model.dart';

class TransactionTypeModel extends BaseResponseModel {
  List<ApprovalsTypes> approvalTypes;
  List<TransactionTypes> transactionTypeList;

  TransactionTypeModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultApprovalTypes"] != null) {
      approvalTypes = List();
      parsedJson["resultApprovalTypes"]
          .forEach((obj) => approvalTypes.add(ApprovalsTypes.fromJson(obj)));
    }
    if (parsedJson["resultTransactionTypes"] != null) {
      transactionTypeList = List();
      parsedJson["resultTransactionTypes"].forEach((obj) {
        TransactionTypes item = TransactionTypes.fromJson(obj);
        if (!transactionTypeList.contains(item)) transactionTypeList.add(item);
      });
    }
  }
}

class TransactionTypes {
  int optionId;
  String optionName;
  String optionCode;
  String optionDescription;
  int iconColor, countColor;
  int icon;
  int subTypeId;
  int userId;
  int transCount;
  bool isSummaryApproval;
  bool emailOnApproval;
  bool smsOnApproval;
  ReportFormatModel reportDtlFormat;
  ReportFormatModel reportSummaryFormat;

  TransactionTypes({this.optionId, this.optionName, this.subTypeId});

  TransactionTypes.fromJson(Map<String, dynamic> json) {
    optionId = BaseJsonParser.goodInt(json, "optionid");
    subTypeId = BaseJsonParser.goodInt(json, "subtypeid");
    optionName = BaseJsonParser.goodString(json, "optionname");
    optionCode = BaseJsonParser.goodString(json, "optioncode");
    optionDescription = BaseJsonParser.goodString(json, "optiondescription");
    isSummaryApproval =
        BaseJsonParser.goodString(json, "apprvlonsummaryyn") == "Y";

    emailOnApproval = BaseJsonParser.goodBoolean(json, "emailonapprovalreqyn");
    smsOnApproval = BaseJsonParser.goodBoolean(json, "smsonapprovalreqyn");
    iconColor = BaseJsonParser.goodHexInt(json, "iconcolor") ??
        BaseJsonParser.goodHex("0XFF6200EA");
    countColor = BaseJsonParser.goodHexInt(json, "countcolor") ??
        BaseJsonParser.goodHex("0XFF6200EA");
    icon = BaseJsonParser.goodInt(json, "icon") ?? 59700;
    userId = BaseJsonParser.goodInt(json, "userid");
    transCount = BaseJsonParser.goodInt(json, "transcount");
    String summaryKey = "reportformatsmry";
    String dtlKey = "reportformatdtl";

    if (json.containsKey(summaryKey) && json[summaryKey] != null)
      reportSummaryFormat = ReportFormatModel.fromJson(json[summaryKey]);
    if (json.containsKey(dtlKey) && json[dtlKey] != null)
      reportDtlFormat = ReportFormatModel.fromJson(json[dtlKey]);
  }
}

class ApprovalsTypes {
  String tableCode;
  String fieldCodeName;
  int id;
  String code;
  String description;
  String extra;

  ApprovalsTypes.fromJson(Map<String, dynamic> json) {
    tableCode = BaseJsonParser.goodString(json, "tablecode");
    fieldCodeName = BaseJsonParser.goodString(json, "fieldcodename");
    id = BaseJsonParser.goodInt(json, "id");
    code = BaseJsonParser.goodString(json, "code");
    description = BaseJsonParser.goodString(json, "description");
    extra = BaseJsonParser.goodString(json, "extra");
  }

  @override
  String toString() {
    return "tableCode : $tableCode "
        "fieldCodeName : $fieldCodeName "
        "id : $id "
        "code : $code "
        "description : $description "
        "extra : $extra ";
  }
}
