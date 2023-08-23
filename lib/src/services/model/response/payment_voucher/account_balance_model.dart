import 'package:base/services.dart';

import '../../../../../utility.dart';

class AccountBalanceModel extends BaseResponseModel {
  List<AccountBalance> accountBalanceList;

  AccountBalanceModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    accountBalanceList = BaseJsonParser.goodList(parsedJson, "accountBalance")
        .map((json) => AccountBalance.fromJson(json))
        .toList();
  }
}

class AccountBalance {
  double account_openbalance;
  int accountid;
  double closing;
  double transactionbalance;

  AccountBalance.fromJson(Map<String, dynamic> json) {
    account_openbalance =
        BaseJsonParser.goodDouble(json, "account_openbalance");
    accountid = BaseJsonParser.goodInt(json, "accountid");
    closing = BaseJsonParser.goodDouble(json, "closing");
    transactionbalance = BaseJsonParser.goodDouble(json, "transactionbalance");
  }
}

class CashierBalanceModel extends BaseResponseModel {
  List<CashierBalance> cashierBalanceList;

  CashierBalanceModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    cashierBalanceList = BaseJsonParser.goodList(parsedJson, "resultObject")
        .map((json) => CashierBalance.fromJson(json))
        .toList();
  }
}

class CashierBalance {
  double account_openbalance;
  int accountid;
  int analysiscodeid;
  int analysiscodetypeid;
  double closing;
  double transactionbalance;

  CashierBalance.fromJson(Map<String, dynamic> json) {
    account_openbalance =
        BaseJsonParser.goodDouble(json, "account_openbalance");
    accountid = BaseJsonParser.goodInt(json, "accountid");
    analysiscodeid = BaseJsonParser.goodInt(json, "analysiscodeid");
    analysiscodetypeid = BaseJsonParser.goodInt(json, "analysiscodetypeid");
    closing = BaseJsonParser.goodDouble(json, "closing");
    transactionbalance = BaseJsonParser.goodDouble(json, "transactionbalance");
  }
}
