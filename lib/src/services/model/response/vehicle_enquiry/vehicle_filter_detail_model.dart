import 'package:base/services.dart';

import '../../../../../utility.dart';

class VehicleFilterDetailListModel extends BaseResponseModel {
  List<VehicleFilterDetailList> vehicleFilterDetails;

  VehicleFilterDetailListModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    vehicleFilterDetails = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => VehicleFilterDetailList.fromJson(e))
        .toList();
  }
}

class VehicleFilterDetailList {
  String chassisno;
  String customername;
  String engineno;
  int itemid;
  int limit;
  String modelname;
  String phoneno;
  String registrationno;
  int rowno;
  int start;
  int totalrecords;
  VehicleFilterDetailList.fromJson(Map parsedJson) {
    chassisno = BaseJsonParser.goodString(parsedJson, "chassisno");
    customername = BaseJsonParser.goodString(parsedJson, "customername");
    engineno = BaseJsonParser.goodString(parsedJson, "engineno");
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    limit = BaseJsonParser.goodInt(parsedJson, "limit");
    modelname = BaseJsonParser.goodString(parsedJson, "modelname");
    phoneno = BaseJsonParser.goodString(parsedJson, "phoneno");
    registrationno = BaseJsonParser.goodString(parsedJson, "registrationno");
    rowno = BaseJsonParser.goodInt(parsedJson, "rowno");
    start = BaseJsonParser.goodInt(parsedJson, "start");
    totalrecords = BaseJsonParser.goodInt(parsedJson, "totalrecords");
  }
}
