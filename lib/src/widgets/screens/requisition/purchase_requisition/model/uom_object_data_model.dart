import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/utility.dart';

class UomModel extends BaseResponseModel {
  List<UomTypes> uomList;

  UomModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    uomList = BaseJsonParser.goodList(json, "uomObject")
        .map((e) => UomTypes.fromJson(e))
        .toList();
  }
}

// class UomTypes {
//   bool defaultuomyn;
//   int itemid;
//   String itemname;
//   int uomid;
//   String uomname;
//   int uomtypebccid;
//   int uomtypesortorder;
//   String uomvalue;
//
//   UomTypes.fromJson(Map<String, dynamic> json) {
//     defaultuomyn = BaseJsonParser.goodBoolean(json, "defaultuomyn");
//     itemid = BaseJsonParser.goodInt(json, "itemid");
//     itemname = BaseJsonParser.goodString(json, "itemname");
//     uomid = BaseJsonParser.goodInt(json, "uomid");
//     uomname = BaseJsonParser.goodString(json, "uomname");
//     uomtypebccid = BaseJsonParser.goodInt(json, "uomtypebccid");
//     uomtypesortorder = BaseJsonParser.goodInt(json, "uomtypesortorder");
//     uomvalue = BaseJsonParser.goodString(json, "uomvalue");
//   }
// }
