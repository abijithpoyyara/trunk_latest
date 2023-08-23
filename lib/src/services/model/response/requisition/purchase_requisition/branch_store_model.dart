import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class BranchStoreModel extends BaseResponseModel {
  List<BranchStore> branchstorelist;

  BranchStoreModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    branchstorelist = BaseJsonParser.goodList(json, "branchDetails")
        .map((e) => BranchStore.fromJson(e))
        .toList();
  }
}

class BranchStore {
  int id;
  String code;
  String name;
  String isactive;
  int companyid;
  int currencyid;

  BranchStore({this.id});
  BranchStore.fromJson(Map<String, dynamic> json) {
    code = BaseJsonParser.goodString(json, "code");
    name = BaseJsonParser.goodString(json, "name");
    isactive = BaseJsonParser.goodString(json, "isactive");
    id = BaseJsonParser.goodInt(json, "Id");
    companyid = BaseJsonParser.goodInt(json, "companyid");
    currencyid = BaseJsonParser.goodInt(json, "currencyid");
  }
}
