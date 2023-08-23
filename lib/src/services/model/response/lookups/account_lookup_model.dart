import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class AccountLookupModel extends LookupModel {
  AccountLookupModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      lookupItems = new List<AccountLookupItem>();
      parsedJson['resultObject'].forEach((mod) {
        lookupItems.add(new AccountLookupItem.fromJson(mod));
      });
    } else {
      lookupItems = List<AccountLookupItem>();
    }
  }
}

class AccountLookupItem extends LookupItems {
  String accountcode;
  int accountid;
  int accounttableid;
  String aliasname;
  String groupname;
  int primarygroupid;
  int rowno;
  int attributeId;
  int attributeValueRefId;
  String description;
  AccountLookupItem(
      {this.accountid, this.description, this.aliasname, this.groupname});

  AccountLookupItem.fromOther({
    this.accountcode,
    this.accountid,
    this.accounttableid,
    this.aliasname,
    this.groupname,
    this.primarygroupid,
    this.rowno,
    this.attributeId,
    this.attributeValueRefId,
  });

  AccountLookupItem.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    accountcode = BaseJsonParser.goodString(json, "accountcode");
    accountid = BaseJsonParser.goodInt(json, "accountid");
    accounttableid = BaseJsonParser.goodInt(json, "accounttableid");
    aliasname = BaseJsonParser.goodString(json, "aliasname");
    groupname = BaseJsonParser.goodString(json, "groupname");
    primarygroupid = BaseJsonParser.goodInt(json, "primarygroupid");
    rowno = BaseJsonParser.goodInt(json, "rowno");
    attributeId = BaseJsonParser.goodInt(json, "attributeid");
    attributeValueRefId = BaseJsonParser.goodInt(json, "attributevaluerefid");
    description = BaseJsonParser.goodString(json, "description");
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AccountLookupItem &&
          runtimeType == other.runtimeType &&
          accountcode == other.accountcode &&
          accountid == other.accountid;

  @override
  int get hashCode => accountcode.hashCode ^ accountid.hashCode;
}
