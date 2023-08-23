import 'package:redstars/src/services/model/response/gin/gin_sourcemapping_dtl_model.dart';
import 'package:redstars/src/services/model/response/gin/gin_view_dtl_list_model.dart';
import 'package:redstars/utility.dart';

class GINModel {
  int identificationno;
  int supplierid;
  String suppliername;
  int dtlid;
  int itemid;
  String itemcode;
  String itemname;
  int uomid;
  String uomname;
  int uomtypebccid;
  int qty;
  int rate;
  int totalvalue;
  int companyid;
  int branchid;
  int finyearid;
  int optionid;
  String address1;
  String address2;
  String address3;
  String isbarcodedyn;
  int bookstockoptionid;
  String bookstockenteredyn;
  String itemaccessedcode;
  int itemaccessedcodetypebccid;
  int fccurrencyid;
  String fccurrencyname;
  int lccurrencyid;
  String lccurrencyname;
  int exchrate;
  int createduserid;
  String createdusername;
  String createddate;
  int itemfccurrencyid;
  String itemfccurrenycode;
  int itemexchrate;
  int itemlclcnettotal;
  String paymentmode;
  int poqty;
  int prevginqty;
  String budgetreqyn;
  String grnno;
  List<VehicleModel> vehicles;
  List<GINItemModel> items;
  GINModel(
      {this.suppliername,
      this.address1,
      this.address2,
      this.address3,
      this.supplierid,
      this.branchid,
      this.exchrate,
      this.companyid,
      this.createduserid,
      this.createddate,
      this.finyearid,
      this.paymentmode,
      this.items,
      this.grnno});
  GINModel.fromJson(Map<String, dynamic> parsedJson) {
    Map<String, dynamic> json = parsedJson['resultObject'][0];
    items = BaseJsonParser.goodList(parsedJson, 'resultObject')
        .map((e) => GINItemModel.fromJson(e))
        .toList();
    vehicles = BaseJsonParser.goodList(json, 'vehicledtljson')
        .map((e) => VehicleModel.fromJson(e))
        .toList();
    identificationno = BaseJsonParser.goodInt(json, "identificationno");
    supplierid = BaseJsonParser.goodInt(json, "supplierid");
    suppliername = BaseJsonParser.goodString(json, "suppliername");
    dtlid = BaseJsonParser.goodInt(json, "dtlid");
    itemid = BaseJsonParser.goodInt(json, "itemid");
    itemcode = BaseJsonParser.goodString(json, "itemcode");
    itemname = BaseJsonParser.goodString(json, "itemname");
    uomid = BaseJsonParser.goodInt(json, "uomid");
    uomname = BaseJsonParser.goodString(json, "uomname");
    uomtypebccid = BaseJsonParser.goodInt(json, "uomtypebccid");
    qty = BaseJsonParser.goodInt(json, "qty");
    rate = BaseJsonParser.goodInt(json, "rate");
    totalvalue = BaseJsonParser.goodInt(json, "totalvalue");
    companyid = BaseJsonParser.goodInt(json, "companyid");
    branchid = BaseJsonParser.goodInt(json, "branchid");
    finyearid = BaseJsonParser.goodInt(json, "finyearid");
    optionid = BaseJsonParser.goodInt(json, "optionid");
    address1 = BaseJsonParser.goodString(json, "address1");
    address2 = BaseJsonParser.goodString(json, "address2");
    address3 = BaseJsonParser.goodString(json, "address3");
    isbarcodedyn = BaseJsonParser.goodString(json, "isbarcodedyn");
    bookstockoptionid = BaseJsonParser.goodInt(json, "bookstockoptionid");
    bookstockenteredyn = BaseJsonParser.goodString(json, "bookstockenteredyn");
    itemaccessedcode = BaseJsonParser.goodString(json, "itemaccessedcode");
    itemaccessedcodetypebccid =
        BaseJsonParser.goodInt(json, "itemaccessedcodetypebccid");
    fccurrencyid = BaseJsonParser.goodInt(json, "fccurrencyid");
    fccurrencyname = BaseJsonParser.goodString(json, "fccurrencyname");
    lccurrencyid = BaseJsonParser.goodInt(json, "lccurrencyid");
    lccurrencyname = BaseJsonParser.goodString(json, "lccurrencyname");
    exchrate = BaseJsonParser.goodInt(json, "exchrate");
    createduserid = BaseJsonParser.goodInt(json, "createduserid");
    createdusername = BaseJsonParser.goodString(json, "createdusername");
    createddate = BaseJsonParser.goodString(json, "createddate");
    itemfccurrencyid = BaseJsonParser.goodInt(json, "itemfccurrencyid");
    itemfccurrenycode = BaseJsonParser.goodString(json, "itemfccurrenycode");
    itemexchrate = BaseJsonParser.goodInt(json, "itemexchrate");
    itemlclcnettotal = BaseJsonParser.goodInt(json, "itemlclcnettotal");
    paymentmode = BaseJsonParser.goodString(json, "paymentmode");
    poqty = BaseJsonParser.goodInt(json, "poqty");
    prevginqty = BaseJsonParser.goodInt(json, "prevginqty");
    budgetreqyn = BaseJsonParser.goodString(json, "budgetreqyn");
  }
}
// class GINModel {
//   int identificationNo;
//   int supplierId;
//   String supplierName;
//   int dtlId;
//   String shipmentNo;
//   String shippingDate;
//   int companyId;
//   int branchId;
//   int finYearId;
//   int optionId;
//   String address1;
//   String address2;
//   String address3;
//
//
//   GINModel.fromJson(Map<String, dynamic> result) {
//
//     identificationNo = BaseJsonParser.goodInt(json, 'identificationno');
//     supplierId = BaseJsonParser.goodInt(json, 'supplierid');
//     supplierName = BaseJsonParser.goodString(json, 'suppliername');
//     dtlId = BaseJsonParser.goodInt(json, 'dtlid');
//     shipmentNo = BaseJsonParser.goodString(json, 'shipmentno');
//     shippingDate = BaseJsonParser.goodString(json, 'shippingdate');
//     companyId = BaseJsonParser.goodInt(json, 'companyid');
//     branchId = BaseJsonParser.goodInt(json, 'branchid');
//     finYearId = BaseJsonParser.goodInt(json, 'finyearid');
//     optionId = BaseJsonParser.goodInt(json, 'optionid');
//     address1 = BaseJsonParser.goodString(json, 'address1');
//     address2 = BaseJsonParser.goodString(json, 'address2');
//     address3 = BaseJsonParser.goodString(json, 'address3');
//   }
// }

class VehicleModel {
  int id;
  int tableId;
  int optionId;
  int parentTableId;
  int parentTableDataId;
  String vehicleNo;
  String remarks;

  VehicleModel.fromJson(Map<String, dynamic> json) {
    id = BaseJsonParser.goodInt(json, 'id');
    tableId = BaseJsonParser.goodInt(json, 'tableid');
    optionId = BaseJsonParser.goodInt(json, 'optionid');
    parentTableId = BaseJsonParser.goodInt(json, 'parenttableid');
    parentTableDataId = BaseJsonParser.goodInt(json, 'parenttabledataid');
    vehicleNo = BaseJsonParser.goodString(json, 'vehicleno');
    remarks = BaseJsonParser.goodString(json, 'remarks');
  }
}

class GINItemModel {
  int itemId;
  int uomId;
  String itemCode;
  String itemName;
  String uom;
  double qty;
  double rate;
  double totalValue;
  bool isItemReceived;
  double receivedQty;
  int uomtypebccid;
  int fccurrencyid;
  String itemaccessedcode;
  int itemaccessedcodetypebccid;
  int exchrate;
  GINSourceMappingDtlList itemSourceMapList;
  GINItemWiseQtyDtl itemWiseQtyDtl;
  int id;
  GINItemModel(
      {this.itemId,
      this.itemSourceMapList,
      this.itemWiseQtyDtl,
      this.receivedQty,
      this.qty,
      this.uomId,
      this.exchrate,
      this.itemaccessedcodetypebccid,
      this.itemaccessedcode,
      this.uomtypebccid,
      this.uom,
      this.rate,
      this.itemName,
      this.itemCode,
      this.fccurrencyid,
      this.totalValue,
      this.id,
      this.isItemReceived});

  GINItemModel.fromJson(Map<String, dynamic> json) {
    itemId = BaseJsonParser.goodInt(json, 'itemid');
    uomId = BaseJsonParser.goodInt(json, 'uomid');
    itemCode = BaseJsonParser.goodString(json, 'itemcode');
    itemName = BaseJsonParser.goodString(json, 'itemname');
    uom = BaseJsonParser.goodString(json, 'uomname');
    qty = BaseJsonParser.goodDouble(json, 'qty');
    receivedQty = BaseJsonParser.goodDouble(json, 'receivedqty');
    rate = BaseJsonParser.goodDouble(json, 'rate');
    isItemReceived = BaseJsonParser.goodBoolean(json, 'itemreceivedyn');
    totalValue = BaseJsonParser.goodDouble(json, 'totalvalue');
    uomtypebccid = BaseJsonParser.goodInt(json, "uomtypebccid");
    itemaccessedcode = BaseJsonParser.goodString(json, "itemaccessedcode");
    itemaccessedcodetypebccid =
        BaseJsonParser.goodInt(json, "itemaccessedcodetypebccid");
    fccurrencyid = BaseJsonParser.goodInt(json, "fccurrencyid");
    exchrate = BaseJsonParser.goodInt(json, "exchrate");
  }
}
