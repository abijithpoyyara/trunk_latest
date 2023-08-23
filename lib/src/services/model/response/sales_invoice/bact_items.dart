import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class BatchModel extends BaseResponseModel {
  List<BatchList> batchList;

  BatchModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    batchList = BaseJsonParser.goodList(json, "resultDatchDetailsObject")
        .map((e) => BatchList.fromJson(e))
        .toList();
  }
}

class BatchList {
  String batchcode;
  String batchdescription;
  int bookstockqty;
  int chassisno;
  int engineno;
  int itembatchid;
  int itembatchtableid;
  int itemid;
  int limit;
  double mrp;
  double nlc;
  int physicalstockqty;
  int rowno;
  int start;
  int totalrecords;
  bool vehiclebatchyn;

  BatchList.fromJson(Map<String, dynamic> json) {
    rowno = BaseJsonParser.goodInt(json, "rowno");
    itemid = BaseJsonParser.goodInt(json, "itemid");
    batchdescription = BaseJsonParser.goodString(json, "batchdescription");
    itembatchtableid = BaseJsonParser.goodInt(json, "itembatchtableid");
    batchcode = BaseJsonParser.goodString(json, "batchcode");
    itembatchid = BaseJsonParser.goodInt(json, "itembatchid");
    totalrecords = BaseJsonParser.goodInt(json, "totalrecords");
    mrp = BaseJsonParser.goodDouble(json, "mrp");
    bookstockqty = BaseJsonParser.goodInt(json, "bookstockqty");
    physicalstockqty = BaseJsonParser.goodInt(json, "physicalstockqty");
    nlc = BaseJsonParser.goodDouble(json, "nlc");
    vehiclebatchyn = BaseJsonParser.goodBoolean(json, "vehiclebatchyn");
    chassisno = BaseJsonParser.goodInt(json, "chassisno");
    engineno = BaseJsonParser.goodInt(json, "engineno");
    start = BaseJsonParser.goodInt(json, "start");
    limit = BaseJsonParser.goodInt(json, "limit");
  }
}

class CostItemModel extends BaseResponseModel {
  List<CostItem> costItemList;

  CostItemModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    costItemList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => CostItem.fromJson(e))
        .toList();
  }
}

class CostItem {
  int ItemId;
  int ItemBatchId;
  int NLC;
  int UomId;

  CostItem.fromJson(Map<String, dynamic> json) {
    ItemId = BaseJsonParser.goodInt(json, "itemid");
    ItemBatchId = BaseJsonParser.goodInt(json, "itembatchid");
    NLC = BaseJsonParser.goodInt(json, "nlc");
    UomId = BaseJsonParser.goodInt(json, "uomid");
  }
}
