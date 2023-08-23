import 'package:base/services.dart';

import '../../../../../utility.dart';

class CostOverviewModel extends BaseResponseModel {
  List<SaleOrderRateList> saleOrderRateList;
  List<SaleOrderTaxList> saleOrderTaxList;
  List<SaleOrderDiscountList> saleOrderDiscountList;
  List<MrpDetails> saleOrderMrpList;


  CostOverviewModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      saleOrderRateList = List();
      saleOrderTaxList = List();
      saleOrderDiscountList = List();
      saleOrderMrpList = List();

      if(parsedJson['resultObject'][0]['listtype']=='SaleOrderRateList' && parsedJson['resultObject'][0]['list']!=null)
        parsedJson['resultObject'][0]['list']?.forEach((mod) {
          saleOrderRateList.add(SaleOrderRateList.fromJson(mod));
        });
      if(parsedJson['resultObject'][1]['listtype']=='SaleOrderTaxList' && parsedJson['resultObject'][0]['list']!=null)
        parsedJson['resultObject'][1]['list']?.forEach((mod) {
          saleOrderTaxList.add(SaleOrderTaxList.fromJson(mod));
        });
      if(parsedJson['resultObject'][2]['listtype']=='SaleOrderDiscountList' && parsedJson['resultObject'][0]['list']!=null)
        parsedJson['resultObject'][2]['list']?.forEach((mod) {
          saleOrderDiscountList.add(SaleOrderDiscountList.fromJson(mod));
        });
      if(parsedJson['resultObject'][3]['listtype']=='MrpDetails' && parsedJson['resultObject'][0]['list']!=null)
        parsedJson['resultObject'][3]['list']?.forEach((mod) {
          saleOrderMrpList.add(MrpDetails.fromJson(mod));
        });



    }

  }
}

class SaleOrderRateList{
  String itemName;
  int itemId;
  int uomId;
  String uomCode;
  bool allowdecimalYN;
  String uom;
  String uomtypebccid;
  String description;
  int itemtableid;
  String ratetypecode;
  String ratetype;
  bool multipletaxapplicableYN;
  int salerate;
  int taxperc;
  int rateinltax;
  SaleOrderRateList.fromJson(Map<String, dynamic> json) {
    itemName = BaseJsonParser.goodString(json, "itemname");
    description = BaseJsonParser.goodString(json, "description");
    uom = BaseJsonParser.goodString(json, "uom");
    allowdecimalYN = BaseJsonParser.goodBoolean(json, "allowdecimalyn");
    uomCode = BaseJsonParser.goodString(json, "uomcode");
    description = BaseJsonParser.goodString(json, "description");
    ratetypecode = BaseJsonParser.goodString(json, "ratetypecode");
    ratetype = BaseJsonParser.goodString(json, "ratetype");
    multipletaxapplicableYN = BaseJsonParser.goodBoolean(json, "multipletaxapplicableyn");
    uomId = BaseJsonParser.goodInt(json, "uomid");
    salerate = BaseJsonParser.goodInt(json, "salerate");
    taxperc = BaseJsonParser.goodInt(json, "taxperc");
    rateinltax = BaseJsonParser.goodInt(json, "rateinltax");
    itemId = BaseJsonParser.goodInt(json, "itemid");
    itemtableid = BaseJsonParser.goodInt(json, "id");
  }
}
class SaleOrderTaxList{

  int taxaccountid;
  String attachmentcode;
  String attachmentdesc;
  String calculateon;
  int itemid;
  int taxperc;
  int attachmentid;
  int  sortorder;
  int effectonparty;
  SaleOrderTaxList.fromJson(Map<String, dynamic> json) {
    attachmentcode = BaseJsonParser.goodString(json, "attachmentcode");
    attachmentdesc = BaseJsonParser.goodString(json, "attachmentdesc");
    calculateon = BaseJsonParser.goodString(json, "calculateon");
    taxperc = BaseJsonParser.goodInt(json, "taxperc");
    taxaccountid = BaseJsonParser.goodInt(json, "taxaccountid");
    itemid = BaseJsonParser.goodInt(json, "itemid");
    attachmentid = BaseJsonParser.goodInt(json, "attachmentid");
    sortorder = BaseJsonParser.goodInt(json, "sortorder");
    effectonparty = BaseJsonParser.goodInt(json, "effectonparty");
  }
}
class SaleOrderDiscountList{

  int discountid;
  String itemname;
  String uom;
  String discount;
  bool allowdecimalyn;
  bool  discapplicableyn;
  int itemid;
  int uomid;
  String discounttype;



  SaleOrderDiscountList.fromJson(Map<String, dynamic> json) {
  itemname = BaseJsonParser.goodString(json, "itemname");
  uom = BaseJsonParser.goodString(json, "uom");
  discount = BaseJsonParser.goodString(json, "discount");
  discounttype = BaseJsonParser.goodString(json, "discounttype");
  uomid = BaseJsonParser.goodInt(json, "uomid");
  itemid = BaseJsonParser.goodInt(json, "itemid");
  discountid = BaseJsonParser.goodInt(json, "discountid");
  allowdecimalyn = BaseJsonParser.goodBoolean(json, "allowdecimalyn");
  discapplicableyn = BaseJsonParser.goodBoolean(json, "discapplicableyn");
  }
}
class MrpDetails {
  String actiondate;
  int qty;
  int rateincltax;
  String batchcode;
  int itemid;
  int batchid;
  int mrp;
  int bookstockqty;
  String batchdescription;
  MrpDetails.fromJson(Map<String, dynamic> json) {
  batchdescription = BaseJsonParser.goodString(json, "batchdescription");
  actiondate = BaseJsonParser.goodString(json, "actiondate");
  batchcode = BaseJsonParser.goodString(json, "batchcode");
  mrp = BaseJsonParser.goodInt(json, "mrp");
  itemid = BaseJsonParser.goodInt(json, "itemid");
  qty = BaseJsonParser.goodInt(json, "qty");
  bookstockqty = BaseJsonParser.goodInt(json, "bookstockqty");
  rateincltax = BaseJsonParser.goodInt(json, "rateincltax");
  batchid = BaseJsonParser.goodInt(json, "batchid");
  }
}


