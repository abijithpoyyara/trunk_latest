import 'package:base/services.dart';
import 'package:base/utility.dart';
import 'package:redstars/src/services/model/response/lookups/service_lookup_model.dart';

class ProcessFromModel extends BaseResponseModel {
  List<ServiceLookupItem> status;

  ProcessFromModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    status = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => ServiceLookupItem.fromJson(e))
        .toList();
  }
}

class ProcessFromDtlListModel extends BaseResponseModel {
  List<ProcessFromDtlList> list;

  ProcessFromDtlListModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    list = BaseJsonParser.goodList(json, "itemAccounDetailObj")
        .map((e) => ProcessFromDtlList.fromJson(e))
        .toList();
  }
}

class ProcessFromDtlList {
  double accountBalance;
  double actual;
  double amount;
  double budgeted;
  double remaining;
  int accountId;
  int attributeId;
  int attributeValueRefId;
  String value;
  String accountName;

  ProcessFromDtlList.fromJson(Map<String, dynamic> json) {
    accountBalance = BaseJsonParser.goodDouble(json, "accountbalance");
    actual = BaseJsonParser.goodDouble(json, "actual");
    amount = BaseJsonParser.goodDouble(json, "amount");
    budgeted = BaseJsonParser.goodDouble(json, "budgeted");
    remaining = BaseJsonParser.goodDouble(json, "remaining");
    accountId = BaseJsonParser.goodInt(json, "accountid");
    attributeId = BaseJsonParser.goodInt(json, "attributeid");
    attributeValueRefId = BaseJsonParser.goodInt(json, "attributevaluerefid");
    value = BaseJsonParser.goodString(json, "value");
    accountName = BaseJsonParser.goodString(json, "accountname");
  }
}
