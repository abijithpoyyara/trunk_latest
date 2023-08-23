import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class StockLocationModel extends BaseResponseModel {
  List<StockLocation> location;

  StockLocationModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    location = BaseJsonParser.goodList(json, "locationObject")
        .map((e) => StockLocation.fromJson(e))
        .toList();
  }
}

class StockLocation {
  String branchcode;
  int branchid;
  int businesslevelcodeid;
  String code;
  String hobranchyn;
  int id;
  String levelcode;
  String name;
  int stateid;
  int tableid;
StockLocation({this.id,this.name});
  StockLocation.fromJson(Map<String, dynamic> json) {
    branchcode = BaseJsonParser.goodString(json, "branchcode");
    branchid = BaseJsonParser.goodInt(json, "branchid");
    businesslevelcodeid = BaseJsonParser.goodInt(json, "businesslevelcodeid");
    code = BaseJsonParser.goodString(json, "code");
    hobranchyn = BaseJsonParser.goodString(json, "hobranchyn");
    id = BaseJsonParser.goodInt(json, "id");
    levelcode = BaseJsonParser.goodString(json, "levelcode");
    name = BaseJsonParser.goodString(json, "name");
    stateid = BaseJsonParser.goodInt(json, "stateid");
    tableid = BaseJsonParser.goodInt(json, "tableid");
  }
}

class BranchsModel extends BaseResponseModel {
  List<BranchStockLocation> branches;

  BranchsModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    branches = BaseJsonParser.goodList(json, "locationObj")
        .map((e) => BranchStockLocation.fromJson(e))
        .toList();
  }
}

class BranchStockLocation {
  String branchcode;
  int branchid;
  int businesslevelcodeid;
  String code;
  String hobranchyn;
  int id;
  String levelcode;
  String name;
  int stateid;
  int tableid;
  BranchStockLocation(
      {this.branchid,
      this.businesslevelcodeid,
      this.name,
      this.tableid,
      this.id});
  BranchStockLocation.fromJson(Map<String, dynamic> json) {
    branchcode = BaseJsonParser.goodString(json, "branchcode");
    branchid = BaseJsonParser.goodInt(json, "branchid");
    businesslevelcodeid = BaseJsonParser.goodInt(json, "businesslevelcodeid");
    code = BaseJsonParser.goodString(json, "code");
    hobranchyn = BaseJsonParser.goodString(json, "hobranchyn");
    id = BaseJsonParser.goodInt(json, "id");
    levelcode = BaseJsonParser.goodString(json, "levelcode");
    name = BaseJsonParser.goodString(json, "name");
    stateid = BaseJsonParser.goodInt(json, "stateid");
    tableid = BaseJsonParser.goodInt(json, "tableid");
  }
}
