import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class GradingCostingViewDetailModel extends BaseResponseModel {
  List<GradingDetailViewList> gradingDetailViewList;

  GradingCostingViewDetailModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    gradingDetailViewList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => GradingDetailViewList.fromJson(e))
        .toList();
  }
}

class GradingDetailViewList {
  int Id;
  String address1;
  String address2;
  String address3;
  int amendedfromoptionid;
  String amendmentdate;
  int amendmentno;
  int branchid;
  String branchname;
  int companyid;
  String createddate;
  int createduserid;
  int exchrate;
  String fccurrency;
  int fccurrencyid;
  int finyearid;
  String gindate;
  String ginno;
  String isblockedyn;
  String lastmoddate;
  int lastmoduserid;
  String lccurrency;
  int lccurrencyid;
  int optionid;
  String podate;
  String pono;
  String remarks;
  int supplierid;
  String suppliername;
  int tableid;
  int transactionuniqueid;
  String transdate;
  String transno;
  List<SourceItemDtlList> sourceItemDtl;
  List<GradingDtlJsonList> gradingDtlJson;
  GradingDetailViewList.fromJson(Map parsedJson) {
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
    address1 = BaseJsonParser.goodString(parsedJson, "address1");
    address2 = BaseJsonParser.goodString(parsedJson, "address2");
    address3 = BaseJsonParser.goodString(parsedJson, "address3");
    amendedfromoptionid =
        BaseJsonParser.goodInt(parsedJson, "amendedfromoptionid");
    amendmentdate = BaseJsonParser.goodString(parsedJson, "amendmentdate");
    amendmentno = BaseJsonParser.goodInt(parsedJson, "amendmentno");
    branchid = BaseJsonParser.goodInt(parsedJson, "branchid");
    branchname = BaseJsonParser.goodString(parsedJson, "branchname");
    companyid = BaseJsonParser.goodInt(parsedJson, "companyid");
    createddate = BaseJsonParser.goodString(parsedJson, "createddate");
    createduserid = BaseJsonParser.goodInt(parsedJson, "createduserid");
    exchrate = BaseJsonParser.goodInt(parsedJson, "exchrate");
    fccurrency = BaseJsonParser.goodString(parsedJson, "fccurrency");
    fccurrencyid = BaseJsonParser.goodInt(parsedJson, "fccurrencyid");
    finyearid = BaseJsonParser.goodInt(parsedJson, "finyearid");
    gindate = BaseJsonParser.goodString(parsedJson, "gindate");
    ginno = BaseJsonParser.goodString(parsedJson, "ginno");
    isblockedyn = BaseJsonParser.goodString(parsedJson, "isblockedyn");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    lccurrency = BaseJsonParser.goodString(parsedJson, "lccurrency");
    lccurrencyid = BaseJsonParser.goodInt(parsedJson, "lccurrencyid");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    podate = BaseJsonParser.goodString(parsedJson, "podate");
    pono = BaseJsonParser.goodString(parsedJson, "pono");
    remarks = BaseJsonParser.goodString(parsedJson, "remarks");
    supplierid = BaseJsonParser.goodInt(parsedJson, "supplierid");
    suppliername = BaseJsonParser.goodString(parsedJson, "suppliername");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    transactionuniqueid =
        BaseJsonParser.goodInt(parsedJson, "transactionuniqueid");
    transdate = BaseJsonParser.goodString(parsedJson, "transdate");
    transno = BaseJsonParser.goodString(parsedJson, "transno");
    sourceItemDtl = BaseJsonParser.goodList(parsedJson, "sourceitemdtl")
        .map((e) => SourceItemDtlList.fromJson(e))
        .toList();
    gradingDtlJson = BaseJsonParser.goodList(parsedJson, "gradingdtljson")
        .map((e) => GradingDtlJsonList.fromJson(e))
        .toList();
  }
}

class SourceItemDtlList {
  String code;
  String description;
  int hdrid;
  int hdrtableid;
  int id;
  int itemid;
  double qty;
  int tableid;
  SourceItemDtlList.fromJson(Map parsedJson) {
    code = BaseJsonParser.goodString(parsedJson, "code");
    description = BaseJsonParser.goodString(parsedJson, "description");
    hdrid = BaseJsonParser.goodInt(parsedJson, "hdrid");
    hdrtableid = BaseJsonParser.goodInt(parsedJson, "hdrtableid");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    qty = BaseJsonParser.goodDouble(parsedJson, "qty");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
  }
}

class GradingDtlJsonList {
  String dtlisblockedyn;
  int exchrate;
  int fccurrencyid;
  String gradecode;
  int gradeid;
  String gradename;
  int id;
  String itemcode;
  int itemid;
  String itemname;
  String lastmoddate;
  int lastmoduserid;
  int lcrate;
  int lctotalvalue;
  int optionid;
  int parenttabledataid;
  int parenttableid;
  double qty;
  double rate;
  int uomTypeBccId;
  int uomId;
  List<SourceMappingDtlJson> sourcemappingdtljson;
  GradingDtlJsonList.fromJson(Map parsedJson) {
    dtlisblockedyn = BaseJsonParser.goodString(parsedJson, "dtlisblockedyn");
    exchrate = BaseJsonParser.goodInt(parsedJson, "exchrate");
    fccurrencyid = BaseJsonParser.goodInt(parsedJson, "fccurrencyid");
    gradecode = BaseJsonParser.goodString(parsedJson, "gradecode");
    gradeid = BaseJsonParser.goodInt(parsedJson, "gradeid");
    gradename = BaseJsonParser.goodString(parsedJson, "gradename");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    itemcode = BaseJsonParser.goodString(parsedJson, "itemcode");
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    itemname = BaseJsonParser.goodString(parsedJson, "itemname");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    lcrate = BaseJsonParser.goodInt(parsedJson, "lcrate");
    lctotalvalue = BaseJsonParser.goodInt(parsedJson, "lctotalvalue");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    parenttabledataid = BaseJsonParser.goodInt(parsedJson, "parenttabledataid");
    parenttableid = BaseJsonParser.goodInt(parsedJson, "parenttableid");
    qty = BaseJsonParser.goodDouble(parsedJson, "qty");
    rate = BaseJsonParser.goodDouble(parsedJson, "rate");
    uomTypeBccId = BaseJsonParser.goodInt(parsedJson, "uomtypebccid");
    uomId = BaseJsonParser.goodInt(parsedJson, "uomid");
    sourcemappingdtljson =
        BaseJsonParser.goodList(parsedJson, "sourcemappingdtljson")
            .map((e) => SourceMappingDtlJson.fromJson(e))
            .toList();
  }
}

class SourceMappingDtlJson {
  int id;
  int generatedqty;
  int generateduomid;
  int generateduomtypebccid;
  int refhdrtabledataid;
  int refhdrtableid;
  int reftabledataid;
  int reftableid;
  SourceMappingDtlJson.fromJson(Map parsedJson) {
    id = BaseJsonParser.goodInt(parsedJson, "id");
    generateduomid = BaseJsonParser.goodInt(parsedJson, "generateduomid");
    generatedqty = BaseJsonParser.goodInt(parsedJson, "generatedqty");
    generateduomtypebccid =
        BaseJsonParser.goodInt(parsedJson, "generateduomtypebccid");
    refhdrtabledataid = BaseJsonParser.goodInt(parsedJson, "refhdrtabledataid");
    refhdrtableid = BaseJsonParser.goodInt(parsedJson, "refhdrtableid");
    reftabledataid = BaseJsonParser.goodInt(parsedJson, "reftabledataid");
    reftableid = BaseJsonParser.goodInt(parsedJson, "reftableid");
  }
}
