import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/lookups/grading_and_costing/grade_lookup_model.dart';
import 'package:redstars/src/widgets/screens/grading_and_costing/model/grading_model.dart';
import 'package:redstars/utility.dart';

class ProcessFillGINListModel extends BaseResponseModel {
  List<ProcessFillGradingList> processFillGradingList;

  ProcessFillGINListModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    processFillGradingList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => ProcessFillGradingList.fromJson(e))
        .toList();
  }
}

class ProcessFillGradingList {
  int branchid;
  int ginid;
  int gintableid;
  int supplierid;
  int suppliertableid;
  String branchname;
  String address1;
  String address2;
  String address3;
  String suppliername;
  String ginno;
  String gindate;
  String purchaseOderNo;
  String purchaseOderDate;
  List<ItemDetailModel> itemDtl;

  ProcessFillGradingList.fromJson(Map<String, dynamic> json) {
    ginid = BaseJsonParser.goodInt(json, "ginid");
    gintableid = BaseJsonParser.goodInt(json, "gintableid");
    supplierid = BaseJsonParser.goodInt(json, "supplierid");
    suppliertableid = BaseJsonParser.goodInt(json, "suppliertableid");
    branchid = BaseJsonParser.goodInt(json, "branchid");
    suppliername = BaseJsonParser.goodString(json, "suppliername");
    address1 = BaseJsonParser.goodString(json, "address1");
    address2 = BaseJsonParser.goodString(json, "address2");
    address3 = BaseJsonParser.goodString(json, "address3");
    branchname = BaseJsonParser.goodString(json, "branchname");
    ginno = BaseJsonParser.goodString(json, "ginno");
    gindate = BaseJsonParser.goodString(json, "gindate");
    purchaseOderNo = BaseJsonParser.goodString(json, "pono");
    purchaseOderDate = BaseJsonParser.goodString(json, "podate");

    itemDtl = BaseJsonParser.goodList(json, "itemdtljson")
        .map((e) => ItemDetailModel.fromJson(e))
        .toList();

    // var itemDtl = BaseJsonParser.goodList(json, "itemdtljson")
    //     .map((e) => ItemDetailModel.fromJson(e))
    //     .toList();
    // itemDtl = rateDtls.isNotEmpty ? rateDtls?.first : null;
  }
}

class ItemDetailModel {
  int id;
  int itemId;
  int uomId;
  int optionId;
  int uomTypeBccId;
  double totalValue;
  int parentTableDataId;
  int parentTableId;
  int itemTableId;
  double qty;
  double rate;
  String itemCode;
  String itemName;
  int gradingQty;
  double gradingRate;
  double gradingTotalValue;
  GradeLookupItem grade;
  List<GradeModel> gradeModelData;

  ItemDetailModel.fromJson(Map<String, dynamic> json) {
    itemId = BaseJsonParser.goodInt(json, "itemid");
    uomId = BaseJsonParser.goodInt(json, "uomid");
    parentTableDataId = BaseJsonParser.goodInt(json, "parenttabledataid");
    parentTableId = BaseJsonParser.goodInt(json, "parenttableid");
    optionId = BaseJsonParser.goodInt(json, "optionid");
    totalValue = BaseJsonParser.goodDouble(json, "totalvalue");
    id = BaseJsonParser.goodInt(json, "id");
    qty = BaseJsonParser.goodDouble(json, "qty");
    uomTypeBccId = BaseJsonParser.goodInt(json, "uomtypebccid");
    itemTableId = BaseJsonParser.goodInt(json, "tableid");
    rate = BaseJsonParser.goodDouble(json, "rate");
    itemName = BaseJsonParser.goodString(json, "itemname");
    itemCode = BaseJsonParser.goodString(json, "itemcode");
  }
}
