import 'package:base/services.dart';
import 'package:base/utility.dart';

class TransactionHistoryModel extends BaseResponseModel {
  List<TransactionHistoryList> transactionHistList;
  List<TransactionApprovalList> transactionApprList;

  TransactionHistoryModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    transactionHistList = List();
    transactionApprList = List();
    if (parsedJson.containsKey('resultObject') &&
        parsedJson['resultObject'] != null) {
      parsedJson['resultObject']?.forEach((json) {
        transactionHistList.add(TransactionHistoryList.fromJson(json));
        transactionApprList.add(TransactionApprovalList.fromJson(json));
      });
    }
  }
}

class HistoryList {
  String userName;
  String userAction;
  String date;
  String level;
  int id;
}

class TransactionHistoryList extends HistoryList {
  TransactionHistoryList.fromJson(Map<String, dynamic> json) {
    id = BaseJsonParser.goodInt(json, "id");
    userName = BaseJsonParser.goodString(json, "username");
    userAction = BaseJsonParser.goodString(json, "useraction");
    date = BaseJsonParser.goodString(json, "lastmoddate");
  }
}

class TransactionApprovalList extends HistoryList {
  TransactionApprovalList.fromJson(Map<String, dynamic> json) {
    userName = BaseJsonParser.goodString(json, "username");
    userAction = BaseJsonParser.goodString(json, "action");
    level = BaseJsonParser.goodString(json, "level");
    date = BaseJsonParser.goodString(json, "date");
  }
}
