import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class ItemGroupLookupModel extends LookupModel {
  ItemGroupLookupModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      lookupItems = new List<ItemGroupLookupItem>();
      parsedJson['resultObject'].forEach((mod) {
        lookupItems.add(new ItemGroupLookupItem.fromJson(mod));
      });
    } else {
      lookupItems = List<ItemGroupLookupItem>();
    }
  }
}

class ItemGroupLookupItem extends LookupItems {
  int attributeid;
  int limit;
  int Id;
  String code;
  String description;
  int parenttabledataid;
  int rowno;
  int start;
  int totalrecords;

  ItemGroupLookupItem.fromOther(
      {this.code,
      this.description,
      this.start,
      this.attributeid,
      this.Id,
      this.limit,
      this.parenttabledataid,
      this.rowno,
      this.totalrecords});

  ItemGroupLookupItem.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    code = BaseJsonParser.goodString(json, "code");
    Id = BaseJsonParser.goodInt(json, "Id");
    attributeid = BaseJsonParser.goodInt(json, "attributeid");
    description = BaseJsonParser.goodString(json, "description");
    start = BaseJsonParser.goodInt(json, "start");
    totalrecords = BaseJsonParser.goodInt(json, "totalrecords");
    rowno = BaseJsonParser.goodInt(json, "rowno");
    limit = BaseJsonParser.goodInt(json, "limit");
    parenttabledataid = BaseJsonParser.goodInt(json, "parenttabledataid");
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemGroupLookupItem &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          id == other.id;

  @override
  int get hashCode => code.hashCode ^ id.hashCode;
}

class ItemGroupModel extends BaseResponseModel {
  List<ItemGroup> itemGroup;

  ItemGroupModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    itemGroup = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => ItemGroup.fromJson(e))
        .toList();
  }
}

class ItemGroup {
  int attributeid;
  int limit;
  int Id;
  String code;
  String description;
  int parenttabledataid;
  int rowno;
  int start;
  int totalrecords;

  ItemGroup.fromJson(Map<String, dynamic> json) {
    code = BaseJsonParser.goodString(json, "code");
    Id = BaseJsonParser.goodInt(json, "id");
    attributeid = BaseJsonParser.goodInt(json, "attributeid");
    description = BaseJsonParser.goodString(json, "description");
    start = BaseJsonParser.goodInt(json, "start");
    totalrecords = BaseJsonParser.goodInt(json, "totalrecords");
    rowno = BaseJsonParser.goodInt(json, "rowno");
    limit = BaseJsonParser.goodInt(json, "limit");
    parenttabledataid = BaseJsonParser.goodInt(json, "parenttabledataid");
  }
}
