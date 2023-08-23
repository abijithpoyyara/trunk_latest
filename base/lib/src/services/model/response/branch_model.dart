import 'package:base/utility.dart';

class BranchModel {
  String branchCode;
  int branchId;
  int businessLevelCodeId;
  String code;
  int id;
  String levelCode;
  String name;
  int tableId;

  BranchModel.fromJson(Map<String, dynamic> json) {
    branchCode = BaseJsonParser.goodString(json, "branchcode");
    branchId = BaseJsonParser.goodInt(json, "branchid");
    businessLevelCodeId = BaseJsonParser.goodInt(json, "businesslevelcodeid");
    code = BaseJsonParser.goodString(json, "code");
    id = BaseJsonParser.goodInt(json, "id");
    levelCode = BaseJsonParser.goodString(json, "levelcode");
    name = BaseJsonParser.goodString(json, "name");
    tableId = BaseJsonParser.goodInt(json, "tableid");
  }
}
