import 'package:base/services.dart';

import '../../../../../utility.dart';

class BudgetModel extends BaseResponseModel {
  List<BudgetList> budgetList;

  BudgetModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    budgetList = BaseJsonParser.goodList(parsedJson, "resultObject")
        .map((json) => BudgetList.fromJson(json))
        .toList();
  }
}

class BudgetList {
  double accountbalance;
  int accountid;
  String accountname;
  double actual;
  int branchid;
  String branchname;
  String budgetdate;
  double budgeted;
  int budgetreftabledataid;
  int budgetreftableid;
  bool budgetreqyn;
  // budgetsplituplistjson: null
  int calendardtlid;
  int departmentid;
  String departmentname;
  String enddatemonth;
  double inprocess;
  // item: null
  int itemcost;
  // itemgroup: null
  int itemid;
  String monthenddate;
  String monthname;
  int monthnumber;
  String monthstartdate;
  double remaining;
  String startdatemonth;

  BudgetList.fromJson(Map<String, dynamic> json) {
    remaining = BaseJsonParser.goodDouble(json, "remaining");
    inprocess = BaseJsonParser.goodDouble(json, "inprocess");
    actual = BaseJsonParser.goodDouble(json, "actual");
    budgeted = BaseJsonParser.goodDouble(json, "budgeted");
    accountbalance = BaseJsonParser.goodDouble(json, "accountbalance");
    startdatemonth = BaseJsonParser.goodString(json, "startdatemonth");
    accountname = BaseJsonParser.goodString(json, "accountname");
    branchname = BaseJsonParser.goodString(json, "branchname");
    budgetdate = BaseJsonParser.goodString(json, "budgetdate");
    departmentname = BaseJsonParser.goodString(json, "departmentname");
    enddatemonth = BaseJsonParser.goodString(json, "enddatemonth");
    monthenddate = BaseJsonParser.goodString(json, "monthenddate");
    monthname = BaseJsonParser.goodString(json, "monthname");
    monthstartdate = BaseJsonParser.goodString(json, "monthstartdate");
    accountid = BaseJsonParser.goodInt(json, "accountid");
    branchid = BaseJsonParser.goodInt(json, "branchid");
    budgetreftabledataid = BaseJsonParser.goodInt(json, "budgetreftabledataid");
    budgetreftableid = BaseJsonParser.goodInt(json, "budgetreftableid");
    itemid = BaseJsonParser.goodInt(json, "itemid");
    monthnumber = BaseJsonParser.goodInt(json, "monthnumber");
    itemcost = BaseJsonParser.goodInt(json, "itemcost");
  }
}
