import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class StockDetailModel extends BaseResponseModel {
  List<StockDetail> stocks;

  StockDetailModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    stocks = BaseJsonParser.goodList(json, "stockObject")
        .map((e) => StockDetail.fromJson(e))
        .toList();
  }
}

class StockDetail {
  String businessLevelName;
  double closingBookStockQty;
  double closingPhysicalStockQty;
  bool isItemBarcoded;
  int itemId;
  String itemName;
  String uomName;

  StockDetail.fromJson(Map<String, dynamic> json) {
    businessLevelName = BaseJsonParser.goodString(json, "businesslevelname");
    closingBookStockQty =
        BaseJsonParser.goodDouble(json, "closingbookstockqty");
    closingPhysicalStockQty =
        BaseJsonParser.goodDouble(json, "closingphysicalstockqty");
    isItemBarcoded = BaseJsonParser.goodBoolean(json, "isitembarcoded");
    itemId = BaseJsonParser.goodInt(json, "itemid");
    itemName = BaseJsonParser.goodString(json, "itemname");
    uomName = BaseJsonParser.goodString(json, "uomname");
  }
}
