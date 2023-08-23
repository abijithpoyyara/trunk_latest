import 'package:redstars/utility.dart';

class SalesEnquiryMisModel {
  int itemId;
  String itemName;
  int uomId;
  double branchStock;
  double readyStock;
  double othBranchStock;
  double othReadyStock;
  String thumbnail;

  SalesEnquiryMisModel({
    this.itemId,
    this.itemName,
    this.uomId,
    this.branchStock,
    this.readyStock,
    this.othBranchStock,
    this.othReadyStock,
    this.thumbnail,
  });

  SalesEnquiryMisModel.fromJson(dynamic json) {
    itemId = BaseJsonParser.goodInt(json, "itemid");
    itemName = BaseJsonParser.goodString(json, "itemname");
    thumbnail = BaseJsonParser.goodString(json, "thumbnail");
    uomId = BaseJsonParser.goodInt(json, "uomid");
    branchStock = BaseJsonParser.goodDouble(json, "branchstock");
    readyStock = BaseJsonParser.goodDouble(json, "readystock");
    othBranchStock = BaseJsonParser.goodDouble(json, "othbranchstock");
    othReadyStock = BaseJsonParser.goodDouble(json, "othreadystock");
  }
}
