import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class POAckSupplierLookupModel extends LookupModel {
  POAckSupplierLookupModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["userObj"] != null) {
      lookupItems = new List<POAckSupplierLookupItem>();
      parsedJson['userObj'].forEach((mod) {
        lookupItems.add(new POAckSupplierLookupItem.fromJson(mod));
      });
    } else {
      lookupItems = List<POAckSupplierLookupItem>();
    }
  }
}

class POAckSupplierLookupItem extends LookupItems {
  int id;
  String name;

  POAckSupplierLookupItem();

  POAckSupplierLookupItem.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    id = BaseJsonParser.goodInt(json, "mobileuserid");
    name = BaseJsonParser.goodString(json, "name");
    description = BaseJsonParser.goodString(json, "name");
  }
}
