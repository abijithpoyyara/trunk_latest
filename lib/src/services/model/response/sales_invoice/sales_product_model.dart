import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';

import '../../../../../utility.dart';

class ProductsModel extends LookupModel {
  ProductsModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      lookupItems = BaseJsonParser.goodList(parsedJson, "resultObject")
          .map((mod) => ProductModel.fromJson(mod))
          .toList();
    } else {
      lookupItems = List<ProductModel>();
    }
  }
}

class ProductModel extends ItemLookupItem {
  List<UomTypes> uoms;
  int rowno;
  int itemid;
  String itemcode;
  String itemdescription;

  String thumbnail;
  double sellingprice;
  double actualprice;
  double rateincltax;
  double qty;

  ProductModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    uoms = BaseJsonParser.goodList(json, "uomratedetails")
        .map((e) => UomTypes.fromJson(e))
        .toList();

    rowno = BaseJsonParser.goodInt(json, "rowno");
    itemid = BaseJsonParser.goodInt(json, "itemid");
    itemcode = BaseJsonParser.goodString(json, "itemcode");
    itemdescription = BaseJsonParser.goodString(json, "itemdescription");
    thumbnail = BaseJsonParser.goodString(json, "thumbnail");
    sellingprice = BaseJsonParser.goodDouble(json, "sellingprice");
    actualprice = BaseJsonParser.goodDouble(json, "actualprice");
    rateincltax = BaseJsonParser.goodDouble(json, "rateincltax");
    qty = BaseJsonParser.goodDouble(json, "qty");
  }
}

class CustomersModel extends BaseResponseModel {
  List<CustomersList> customers;

  CustomersModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    customers = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => CustomersList.fromJson(e))
        .toList();
  }
}

class CustomersList {
  String code;
  String name;
  String address1;
  String address2;
  String address3;
  String mobile;
  String phone;
  String customertype;
  String customeraddress;
  String analysiscodetypeid;
  String gstno;
  int analysisaccountid;
  int analysiscodeid;
  int id;
  int account_id;

  CustomersList.fromJson(Map<String, dynamic> json) {
    code = BaseJsonParser.goodString(json, "code");
    name = BaseJsonParser.goodString(json, "name");
    customertype = BaseJsonParser.goodString(json, "customertype");
    customeraddress = BaseJsonParser.goodString(json, "customeraddress");
    analysiscodetypeid = BaseJsonParser.goodString(json, "analysiscodetypeid");
    gstno = BaseJsonParser.goodString(json, "gstno");
    address1 = BaseJsonParser.goodString(json, "address1");
    address2 = BaseJsonParser.goodString(json, "address2");
    address3 = BaseJsonParser.goodString(json, "address3");
    mobile = BaseJsonParser.goodString(json, "mobile");
    phone = BaseJsonParser.goodString(json, "phone");
    id = BaseJsonParser.goodInt(json, "id");
    analysisaccountid = BaseJsonParser.goodInt(json, "analysisaccountid");
    analysiscodeid = BaseJsonParser.goodInt(json, "analysiscodeid");
    account_id = BaseJsonParser.goodInt(json, "accountid");
  }
}

class SalesmanModel extends BaseResponseModel {
  List<SalesmanObjects> salesman;

  SalesmanModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    salesman = BaseJsonParser.goodList(json, "salesmanObject")
        .map((e) => SalesmanObjects.fromJson(e))
        .toList();
  }
}

class SalesmanObjects {
  String description;
  int customerid;
  int limit;
  String mobile;
  String personnelcode;
  int personnelid;
  int start;
  int totalrecords;
  int personneltableid;
  int userid;

  SalesmanObjects.fromJson(Map<String, dynamic> json) {
    description = BaseJsonParser.goodString(json, "description");
    customerid = BaseJsonParser.goodInt(json, "customerid");
    limit = BaseJsonParser.goodInt(json, "limit");
    mobile = BaseJsonParser.goodString(json, "mobile");
    personnelcode = BaseJsonParser.goodString(json, "personnelcode");
    personnelid = BaseJsonParser.goodInt(json, "personnelid");
    start = BaseJsonParser.goodInt(json, "start");
    totalrecords = BaseJsonParser.goodInt(json, "totalrecords");
    personneltableid = BaseJsonParser.goodInt(json, "personneltableid");
    userid = BaseJsonParser.goodInt(json, "userid");
  }
}

class ProductDetailResponseModel extends BaseResponseModel {
  ProductDetailModel detail;

  ProductDetailResponseModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    detail = BaseJsonParser.goodList(parsedJson, "resultObject")
        .map((e) => ProductDetailModel.fromJson(e))
        ?.first;
  }
}

class ProductDetailModel {
  List<String> images;
  String description;
  String moreInfo;
  String specification;
  int itemId;
  int uomid;
  String itemCode;

  ProductDetailModel.fromJson(Map<String, dynamic> json) {
    images = BaseJsonParser.goodList(json, "images")
        .map((e) => e as String)
        .toList();
    itemId = BaseJsonParser.goodInt(json, "itemid");
    uomid = BaseJsonParser.goodInt(json, "uomid");
    description = BaseJsonParser.goodString(json, "description");
    itemCode = BaseJsonParser.goodString(json, "itemcode");
    specification = BaseJsonParser.goodString(json, "specification");
    moreInfo = BaseJsonParser.goodString(json, "moreinfo");
  }
}
