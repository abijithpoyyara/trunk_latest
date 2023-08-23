import 'package:base/services.dart';

import '../../../../../utility.dart';

class VehicleProductionDetailListModel extends BaseResponseModel {
  List<VehicleProductionDetailsList> vehicleProductionDetail;

  VehicleProductionDetailListModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    vehicleProductionDetail = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => VehicleProductionDetailsList.fromJson(e))
        .toList();
  }
}

class VehicleProductionDetailsList {
  String chassisno;
  String customername;
  String engineno;
  int itemid;
  String modelname;
  String registrationno;
  String lastserviceon;
  List<ProductionDetailJsonList> productionJsonData;

  VehicleProductionDetailsList.fromJson(Map parsedJson) {
    chassisno = BaseJsonParser.goodString(parsedJson, "chassisno");
    customername = BaseJsonParser.goodString(parsedJson, "customername");
    engineno = BaseJsonParser.goodString(parsedJson, "engineno");
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    modelname = BaseJsonParser.goodString(parsedJson, "modelname");
    registrationno = BaseJsonParser.goodString(parsedJson, "registrationno");
    lastserviceon = BaseJsonParser.goodString(parsedJson, "lastserviceon");
    productionJsonData =
        BaseJsonParser.goodList(parsedJson, "productiondtljson")
            .map((e) => ProductionDetailJsonList.fromJson(e))
            .toList();
  }
}

class ProductionDetailJsonList {
  String apprvlstatus;
  String branchname;
  String docapprvlstatus;
  String locationname;
  int optionid;
  String requiredapprovalyn;
  int sortorder;
  String transdate;
  String transno;
  String transtype;
  String remark;

  ProductionDetailJsonList.fromJson(Map parsedJson) {
    apprvlstatus = BaseJsonParser.goodString(parsedJson, "apprvlstatus");
    branchname = BaseJsonParser.goodString(parsedJson, "branchname");
    docapprvlstatus = BaseJsonParser.goodString(parsedJson, "docapprvlstatus");
    locationname = BaseJsonParser.goodString(parsedJson, "locationname");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    requiredapprovalyn =
        BaseJsonParser.goodString(parsedJson, "requiredapprovalyn");
    sortorder = BaseJsonParser.goodInt(parsedJson, "sortorder");
    transdate = BaseJsonParser.goodString(parsedJson, "transdate");
    transno = BaseJsonParser.goodString(parsedJson, "transno");
    transtype = BaseJsonParser.goodString(parsedJson, "transtype");
    remark = BaseJsonParser.goodString(parsedJson, "remarks");
  }
}
