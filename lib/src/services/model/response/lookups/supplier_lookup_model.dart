import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class SupplierLookupModel extends LookupModel {
  SupplierLookupModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      lookupItems = new List<SupplierLookupItem>();
      parsedJson['resultObject'].forEach((mod) {
        lookupItems.add(new SupplierLookupItem.fromJson(mod));
      });
    } else {
      lookupItems = List<SupplierLookupItem>();
    }
  }
}

class SupplierLookupItem extends LookupItems {
  int id;
  int tableId;
  String code;
  String name;
  bool hasTDS;
  bool isActive;
  int supplierId;

  SupplierLookupItem.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    id = BaseJsonParser.goodInt(json, "Id");
    tableId = BaseJsonParser.goodInt(json, "tableid");
    code = BaseJsonParser.goodString(json, "code");
    name = BaseJsonParser.goodString(json, "name");
    hasTDS = BaseJsonParser.goodBoolean(json, "tdsapplicableyn");
    isActive = BaseJsonParser.goodBoolean(json, "isactive");
    supplierId = BaseJsonParser.goodInt(json, "id");
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SupplierLookupItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          code == other.code;

  @override
  int get hashCode => id.hashCode ^ code.hashCode;
}
