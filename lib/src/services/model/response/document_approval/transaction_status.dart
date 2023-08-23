import 'package:base/services.dart';
import 'package:base/utility.dart';

class TransactionStatusModel extends BaseResponseModel {
  List<TransactionStatus> transactionStatusList;

  TransactionStatusModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    transactionStatusList = List();
    if (parsedJson.containsKey('resultObject') &&
        parsedJson['resultObject'] != null) {
      parsedJson['resultObject']?.forEach((json) {
        transactionStatusList.add(TransactionStatus.fromJson(json));
      });
    }
  }
}

class TransactionStatus {
  int id;
  int parentId;
  int sortOrder;
  String name;
  int hdrId;
  int tableId;
  int optionId;
  String transactionNo;
  bool leafYN;
  bool expanded;

  TransactionStatus.fromJson(Map<String, dynamic> json) {
    id = BaseJsonParser.goodInt(json, "id");
    parentId = BaseJsonParser.goodInt(json, "parentid") ?? 0;
    sortOrder = BaseJsonParser.goodInt(json, "sortorder");
    name = BaseJsonParser.goodString(json, "name");

    hdrId = BaseJsonParser.goodInt(json, "hdrid");
    tableId = BaseJsonParser.goodInt(json, "tableid");
    optionId = BaseJsonParser.goodInt(json, "optionid");

    transactionNo = BaseJsonParser.goodString(json, "transactionno");

    leafYN = BaseJsonParser.goodString(json, "leafyn") == "Y";
    expanded = BaseJsonParser.goodString(json, "expanded") == "Y";
  }

  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map();
    map["id"] = id;
    map["parentid"] = parentId;
    map["sortorder"] = sortOrder;
    map["name"] = name;

    map["hdrid"] = hdrId;
    map["tableid"] = tableId;
    map["optionid"] = optionId;

    map["transactionno"] = transactionNo;

    map["leafyn"] = leafYN ? "Y" : "N";
    map["expanded"] = expanded ? "Y" : "N";
    return map;
  }
}
