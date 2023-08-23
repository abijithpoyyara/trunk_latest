import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class ItemLookupModel extends LookupModel {
  ItemLookupModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      lookupItems = new List<ItemLookupItem>();
      parsedJson['resultObject'].forEach((mod) {
        lookupItems.add(new ItemLookupItem.fromJson(mod));
      });
    } else {
      lookupItems = List<ItemLookupItem>();
    }
  }
}

class ItemLookupItem extends LookupItems {
  List<UomTypes> uoms;
  String batchtype;
  int id;
  String code;
  String codeanddesc;
  String description;
  String hsncode;
  String identificationparam;
  bool isbarcodedyn;
  bool iscomboitemyn;
  String budgetreqyn;
  ItemLookupItem({this.description, this.code, this.id});

  ItemLookupItem.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    id = BaseJsonParser.goodInt(json, "itemid");
    batchtype = BaseJsonParser.goodString(json, "batchtype");
    code = BaseJsonParser.goodString(json, "code");
    codeanddesc = BaseJsonParser.goodString(json, "codeanddesc");
    description = BaseJsonParser.goodString(json, "description");
    budgetreqyn = BaseJsonParser.goodString(json, "budgetreqyn");
    hsncode = BaseJsonParser.goodString(json, "hsncode");
    identificationparam =
        BaseJsonParser.goodString(json, "identificationparam");
    isbarcodedyn = BaseJsonParser.goodBoolean(json, "isbarcodedyn");
    iscomboitemyn = BaseJsonParser.goodBoolean(json, "iscomboitemyn");
    uoms = BaseJsonParser.goodList(json, "uomratedetails")
        .map((e) => UomTypes.fromJson(e))
        .toList();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemLookupItem &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          code == other.code &&
          codeanddesc == other.codeanddesc &&
          hsncode == other.hsncode;

  @override
  int get hashCode =>
      code.hashCode ^ codeanddesc.hashCode ^ hsncode.hashCode ^ id.hashCode;
}

class UomTypes {
  bool defaultuomyn;
  int itemid;
  String itemname;
  int uomid;
  String uomname;
  int uomtypebccid;
  int uomtypesortorder;
  String uomvalue;
  UomTypes({this.uomid, this.uomtypebccid, this.uomname});

  UomTypes.fromJson(Map<String, dynamic> json) {
    defaultuomyn = BaseJsonParser.goodBoolean(json, "defaultuomyn");
    itemid = BaseJsonParser.goodInt(json, "itemid");
    itemname = BaseJsonParser.goodString(json, "itemname");
    uomid = BaseJsonParser.goodInt(json, "uomid");
    uomname = BaseJsonParser.goodString(json, "uomname");
    uomtypebccid = BaseJsonParser.goodInt(json, "uomtypebccid");
    uomtypesortorder = BaseJsonParser.goodInt(json, "uomtypesortorder");
    uomvalue = BaseJsonParser.goodString(json, "uomvalue");
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UomTypes &&
          runtimeType == other.runtimeType &&
          uomid == other.uomid &&
          uomtypebccid == other.uomtypebccid &&
          uomvalue == other.uomvalue;

  @override
  int get hashCode =>
      uomid.hashCode ^ uomtypebccid.hashCode ^ uomvalue.hashCode;
}
