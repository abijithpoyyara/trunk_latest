import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class VehicleEnquiryLookupModel extends LookupModel {
  VehicleEnquiryLookupModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      lookupItems = new List<VehicleFilterDetailListLookupItem>();
      parsedJson['resultObject'].forEach((mod) {
        lookupItems.add(new VehicleFilterDetailListLookupItem.fromJson(mod));
      });
    } else {
      lookupItems = List<VehicleFilterDetailListLookupItem>();
    }
  }
}

class VehicleFilterDetailListLookupItem extends LookupItems {
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
  VehicleFilterDetailListLookupItem.fromJson(Map parsedJson) {
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

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is VehicleFilterDetailListLookupItem &&
          runtimeType == other.runtimeType &&
          itemid == other.itemid &&
          chassisno == other.chassisno &&
          engineno == other.engineno &&
          registrationno == other.registrationno;

  @override
  int get hashCode => itemid.hashCode;
}
