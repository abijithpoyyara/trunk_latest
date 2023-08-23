import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class ItemDetailModel extends BaseResponseModel {
  List<ItemDetailListItems> itemDetailList;

  ItemDetailModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    itemDetailList = BaseJsonParser.goodList(json, "ItemDtlObj")
        .map((e) => ItemDetailListItems.fromJson(e))
        .toList();
  }
}

class ItemDetailListItems {
  int additionalcost;
  int barcodeqty;
  int bcdqty;
  int currentstock;
  // customerpricingdtljson: null
  String itemcode;
  int itemid;
  String itemname;
  int landingcost;
  String mfd;
  double mrp;
  double mrpmarginamount;
  double mrpmarginperc;
  double newsellingprice;
  double orgmrp;
  int pricingdtlid;
  double rate;
  int sortorder;
// taxdtl: null
  String uom;
  int uomid;
  int uomtypebccid;
  RateDetail rateDtl;
  String newPrice;
  ItemDetailListItems(
      {this.itemname, this.itemcode, this.uom, this.newPrice, this.rateDtl});

  ItemDetailListItems.fromJson(Map<String, dynamic> json) {
    additionalcost = BaseJsonParser.goodInt(json, "additionalcost");
    barcodeqty = BaseJsonParser.goodInt(json, "barcodeqty");

    currentstock = BaseJsonParser.goodInt(json, "currentstock");
    pricingdtlid = BaseJsonParser.goodInt(json, "pricingdtlid");
    landingcost = BaseJsonParser.goodInt(json, "landingcost");

    sortorder = BaseJsonParser.goodInt(json, "sortorder");
    uomid = BaseJsonParser.goodInt(json, "uomid");
    uomtypebccid = BaseJsonParser.goodInt(json, "uomtypebccid");
    itemid = BaseJsonParser.goodInt(json, "itemid");
    itemcode = BaseJsonParser.goodString(json, "itemcode");
    itemname = BaseJsonParser.goodString(json, "itemname");
    var rateDtls = BaseJsonParser.goodList(json, "ratedtl")
        .map((e) => RateDetail.fromJson(e))
        .toList();
    rateDtl = rateDtls.isNotEmpty ? rateDtls?.first : null;
    mfd = BaseJsonParser.goodString(json, "mfd");
    mrp = BaseJsonParser.goodDouble(json, "mrp");
    bcdqty = BaseJsonParser.goodInt(json, "bcdqty");
    mrpmarginamount = BaseJsonParser.goodDouble(json, "mrpmarginamount");
    mrpmarginperc = BaseJsonParser.goodDouble(json, "mrpmarginperc");
    newsellingprice = BaseJsonParser.goodDouble(json, "newsellingprice");

    orgmrp = BaseJsonParser.goodDouble(json, "orgmrp");
    rate = BaseJsonParser.goodDouble(json, "rate");
    newPrice = BaseJsonParser.goodString(json, "newPrice");
  }
}

class RateDetail {
  int additionalcostforrate;
  int defaultuomid;
  String itemcode;
  int itemid;
  String itemname;
  int margin;
  int marginper;
  double newsellingprice;
  double prevrate;
  double rate;
  String ratetype;
  int ratetypebccid;
  double sellingcost;
  double tax;
  double taxperc;
  String uomname;
  int uomtypebccid;

  RateDetail.fromJson(Map<String, dynamic> json) {
    additionalcostforrate =
        BaseJsonParser.goodInt(json, "additionalcostforrate");
    defaultuomid = BaseJsonParser.goodInt(json, "defaultuomid");

    uomtypebccid = BaseJsonParser.goodInt(json, "uomtypebccid");
    ratetypebccid = BaseJsonParser.goodInt(json, "ratetypebccid");
    itemid = BaseJsonParser.goodInt(json, "itemid");

    margin = BaseJsonParser.goodInt(json, "margin");
    marginper = BaseJsonParser.goodInt(json, "marginper");
    uomtypebccid = BaseJsonParser.goodInt(json, "uomtypebccid");

    itemcode = BaseJsonParser.goodString(json, "itemcode");
    itemname = BaseJsonParser.goodString(json, "itemname");

    tax = BaseJsonParser.goodDouble(json, "tax");
    taxperc = BaseJsonParser.goodDouble(json, "taxperc");
    sellingcost = BaseJsonParser.goodDouble(json, "sellingcost");
    prevrate = BaseJsonParser.goodDouble(json, "prevrate");

    newsellingprice = BaseJsonParser.goodDouble(json, "newsellingprice");

    rate = BaseJsonParser.goodDouble(json, "rate");
  }
}
