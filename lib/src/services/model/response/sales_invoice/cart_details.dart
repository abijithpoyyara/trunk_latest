import 'package:base/services.dart';

import '../../../../../utility.dart';

class CartListModel extends BaseResponseModel {
  List<CartItemModel> products;

  CartListModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    products = BaseJsonParser.goodList(parsedJson, "resultObject")
        .map((json) => CartItemModel.fromJson(json))
        .toList();
  }
}

class CartItemModel {
  int itemId;
  int cartid;
  int carttableid;
  String itemCode;
  String itemName;
  int qty;
  double rate;
  String thumbnail;
  CartRateDtlModel rateDtl;
  BatchList batchDtl;
  int bundlingqty = 0;
  int packingqty = 0;

  CartItemModel.fromJson(Map<String, dynamic> json) {
    itemId = BaseJsonParser.goodInt(json, "itemid");
    cartid = BaseJsonParser.goodInt(json, "cartid");
    carttableid = BaseJsonParser.goodInt(json, "carttableid");
    itemCode = BaseJsonParser.goodString(json, "itemcode");
    itemName = BaseJsonParser.goodString(json, "itemname");
    qty = BaseJsonParser.goodInt(json, "qty");
    bundlingqty = BaseJsonParser.goodInt(json, "bundlingqty");
    packingqty = BaseJsonParser.goodInt(json, "packingqty");
    rate = BaseJsonParser.goodDouble(json, "rate");
    thumbnail = BaseJsonParser.goodString(json, "thumbnail");
    var rateDtls = BaseJsonParser.goodList(json, "ratedtljson")
        .map((e) => CartRateDtlModel.fromJson(e))
        .toList();
    var batchDtls = BaseJsonParser.goodList(json, "itembatchdtljson")
        .map((e) => BatchList.fromJson(e))
        .toList();
    rateDtl = rateDtls.isNotEmpty ? rateDtls?.first : null;
    batchDtl = batchDtls.isNotEmpty ? batchDtls?.first : null;
  }
}

class CartRateDtlModel {
  int itemId;
  int uomId;
  int uomTypeBccId;
  int rateTypeBccId;
  int itemTableId;
  double saleRate;
  double rateInclTax;
  double taxPerc;
  String itemName;
  String uom;
  String allowDecimalyn;
  String uomCode;
  String description;
  String rateTypeCode;
  String rateType;
  String multipleTaxApplicableyn;
  List<CartTaxDtlModel> taxes;
  CartMrpDtlModel mrpDtl;

  CartRateDtlModel.fromJson(Map<String, dynamic> json) {
    itemId = BaseJsonParser.goodInt(json, "itemid");
    uomId = BaseJsonParser.goodInt(json, "uomid");
    uomTypeBccId = BaseJsonParser.goodInt(json, "uomtypebccid");
    rateTypeBccId = BaseJsonParser.goodInt(json, "ratetypebccid");
    itemTableId = BaseJsonParser.goodInt(json, "itemtableid");
    saleRate = BaseJsonParser.goodDouble(json, "salerate");
    rateInclTax = BaseJsonParser.goodDouble(json, "rateincltax");
    taxPerc = BaseJsonParser.goodDouble(json, "taxperc");
    itemName = BaseJsonParser.goodString(json, "itemname");
    uom = BaseJsonParser.goodString(json, "uom");
    allowDecimalyn = BaseJsonParser.goodString(json, "allowdecimalyn");
    uomCode = BaseJsonParser.goodString(json, "uomcode");
    description = BaseJsonParser.goodString(json, "description");
    rateTypeCode = BaseJsonParser.goodString(json, "ratetypecode");
    rateType = BaseJsonParser.goodString(json, "ratetype");
    multipleTaxApplicableyn =
        BaseJsonParser.goodString(json, "multipletaxapplicableyn");
    taxes = BaseJsonParser.goodList(json, "taxdtl")
        .map((e) => CartTaxDtlModel.fromJson(e))
        .toList();
    mrpDtl = BaseJsonParser.goodList(json, "mrprate")
        .map((e) => CartMrpDtlModel.fromJson(e))
        ?.first;
  }
}

class CartTaxDtlModel {
  int itemId;
  int taxAccountId;
  double taxPerc;
  int attachmentId;
  String attachmentCode;
  String attachmentDesc;
  String calculateOn;
  int sortOrder;
  int effectOnParty;
  double taxAppAmt;
  double taxAmt;
  double deductedTax;

  CartTaxDtlModel.fromJson(Map<String, dynamic> json) {
    itemId = BaseJsonParser.goodInt(json, "itemid");
    taxAccountId = BaseJsonParser.goodInt(json, "taxaccountid");
    taxPerc = BaseJsonParser.goodDouble(json, "taxperc");
    attachmentId = BaseJsonParser.goodInt(json, "attachmentid");
    attachmentCode = BaseJsonParser.goodString(json, "attachmentcode");
    attachmentDesc = BaseJsonParser.goodString(json, "attachmentdesc");
    calculateOn = BaseJsonParser.goodString(json, "calculateon");
    sortOrder = BaseJsonParser.goodInt(json, "sortorder");
    effectOnParty = BaseJsonParser.goodInt(json, "effectonparty");
  }
}

class CartMrpDtlModel {
  int itemId;
  double mrp;
  double rateInclTax;
  double qty;
  double bookStockQty;
  double physicalStockQty;

  CartMrpDtlModel.fromJson(Map<String, dynamic> json) {
    itemId = BaseJsonParser.goodInt(json, "itemid");
    mrp = BaseJsonParser.goodDouble(json, "mrp");
    rateInclTax = BaseJsonParser.goodDouble(json, "rateincltax");
    qty = BaseJsonParser.goodDouble(json, "qty");
    bookStockQty = BaseJsonParser.goodDouble(json, "bookstockqty");
    physicalStockQty = BaseJsonParser.goodDouble(json, "physicalstockqty");
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
