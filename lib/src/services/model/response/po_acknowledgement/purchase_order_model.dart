import 'package:redstars/src/redux/viewmodels/po_acknowledge/vehicle_model.dart';
import 'package:redstars/utility.dart';

class PurchaseOrderModel {
  String transNo;
  String transDate;
  String remarks;
  String ackDateTime;
  String branchName;

  int id;
  int rowNo;
  int tableId;
  int start;
  int limit;
  int totalRecords;

  PurchaseOrderModel.fromJson(Map<String, dynamic> json) {
    transDate = BaseJsonParser.goodString(json, 'transdate');
    transNo = BaseJsonParser.goodString(json, 'transno');
    remarks = BaseJsonParser.goodString(json, 'remarks');
    ackDateTime = BaseJsonParser.goodString(json, 'ackdatetime');
    branchName = BaseJsonParser.goodString(json, 'branchname');
    rowNo = BaseJsonParser.goodInt(json, 'rowno');
    id = BaseJsonParser.goodInt(json, 'id');
    tableId = BaseJsonParser.goodInt(json, 'tableid');
    start = BaseJsonParser.goodInt(json, 'start');
    limit = BaseJsonParser.goodInt(json, 'limit');
    totalRecords = BaseJsonParser.goodInt(json, 'totalrecords');
  }
}

class PODetailModel {
  int id;
  int ackHdrId;
  int ackHdrTableId;
  int tableId;
  String purchaseOrderNo;
  String transDate;
  String remarks;
  List<POItemModel> items;
  List<POVehicleModel> vehicles;

  PODetailModel.fromJson(Map<String, dynamic> json) {
    id = BaseJsonParser.goodInt(json, 'id');
    ackHdrId = BaseJsonParser.goodInt(json, 'ackhdrid');
    ackHdrTableId = BaseJsonParser.goodInt(json, 'ackhdrtableid');
    tableId = BaseJsonParser.goodInt(json, 'tableid');
    purchaseOrderNo = BaseJsonParser.goodString(json, 'purchaseorderno');
    remarks = BaseJsonParser.goodString(json, 'ackremarks');
    transDate = BaseJsonParser.goodString(json, 'transdate');
    items = BaseJsonParser.goodList(json, 'dtljson')
        .map((e) => POItemModel.fromJson(e))
        .toList();
    vehicles = BaseJsonParser.goodList(json, 'ackdtljson')
        .map((e) => POVehicleModel.fromJson(e))
        .toList();
  }
}

class POItemModel {
  int id;
  int uomId;
  String uom;
  String itemName;
  double qty;
  String image;

  POItemModel.fromJson(Map<String, dynamic> json) {
    id = BaseJsonParser.goodInt(json, 'itemid');
    uomId = BaseJsonParser.goodInt(json, 'uomid');
    uom = BaseJsonParser.goodString(json, 'uom');
    itemName = BaseJsonParser.goodString(json, 'itemname');
    qty = BaseJsonParser.goodDouble(json, 'qty');
    image = BaseJsonParser.goodString(json, 'image');
  }
}
