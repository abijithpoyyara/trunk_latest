import 'package:base/services.dart';

import '../../../../../utility.dart';

class ItemGradeRateSettingsViewDetailPageListModel extends BaseResponseModel {
  List<ItemGradeRateSettingsViewDetailPageList>
      itemGradeRateSettingsDetailViewPageList;
  int EOR_Id;
  int SOR_Id;
  int TotalRecords;

  ItemGradeRateSettingsViewDetailPageListModel.fromJson(
      Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    itemGradeRateSettingsDetailViewPageList =
        BaseJsonParser.goodList(parsedJson, "resultObject")
            .map((e) => ItemGradeRateSettingsViewDetailPageList.fromJson(e))
            .toList();
    SOR_Id = parsedJson["SOR_Id"];
    EOR_Id = parsedJson["EOR_Id"];
    TotalRecords = parsedJson["TotalRecords"];
  }
}

class ItemGradeRateSettingsViewDetailPageList {
  int id;
  int tableid;
  int optionid;
  int transactionuniqueid;
  int amendmentno;
  String amendmentdate;
  int amendedfromoptionid;
  int companyid;
  String pricingno;
  String pricingwefdate;
  int businesslevelcodeid;
  int businessleveltableid;
  int businessleveltabledataid;
  String recordstatus;
  String isblockedyn;
  int createduserid;
  String createddate;
  int lastmoduserid;
  String lastmoddate;
  int SOR_Id;
  int EOR_Id;
  int TotalRecords;
  List<DtlJsonList> dtlJson;

  ItemGradeRateSettingsViewDetailPageList.fromJson(Map parsedJson) {
    id = BaseJsonParser.goodInt(parsedJson, "Id");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    transactionuniqueid =
        BaseJsonParser.goodInt(parsedJson, "transactionuniqueid");
    amendmentno = BaseJsonParser.goodInt(parsedJson, "amendmentno");
    amendmentdate = BaseJsonParser.goodString(parsedJson, "amendmentdate");
    amendedfromoptionid =
        BaseJsonParser.goodInt(parsedJson, "amendedfromoptionid");
    companyid = BaseJsonParser.goodInt(parsedJson, "companyid");
    pricingno = BaseJsonParser.goodString(parsedJson, "pricingno");
    pricingwefdate = BaseJsonParser.goodString(parsedJson, "pricingwefdate");
    businesslevelcodeid =
        BaseJsonParser.goodInt(parsedJson, "businesslevelcodeid");
    businessleveltableid =
        BaseJsonParser.goodInt(parsedJson, "businessleveltableid");
    businessleveltabledataid =
        BaseJsonParser.goodInt(parsedJson, "businessleveltabledataid");
    recordstatus = BaseJsonParser.goodString(parsedJson, "recordstatus");
    isblockedyn = BaseJsonParser.goodString(parsedJson, "isblockedyn");
    createduserid = BaseJsonParser.goodInt(parsedJson, "createduserid");
    createddate = BaseJsonParser.goodString(parsedJson, "createddate");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    SOR_Id = BaseJsonParser.goodInt(parsedJson, "SOR_Id");
    EOR_Id = BaseJsonParser.goodInt(parsedJson, "EOR_Id");
    TotalRecords = BaseJsonParser.goodInt(parsedJson, "TotalRecords");
    dtlJson = BaseJsonParser.goodList(parsedJson, "dtljson")
        .map((e) => DtlJsonList.fromJson(e))
        .toList();
  }
}

class DtlJsonList {
  int id;
  int tableid;
  int optionid;
  int parenttableid;
  int parenttabledataid;
  int itemid;
  int gradeid;
  double rate;
  int currencyid;
  String dtlisblockedyn;
  int lastmoduserid;
  String lastmoddate;
  String itemname;
  String itemcode;
  String gradename;
  String currencyname;

  DtlJsonList.fromJson(Map parsedJson) {
    id = BaseJsonParser.goodInt(parsedJson, "id");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    parenttableid = BaseJsonParser.goodInt(parsedJson, "parenttableid");
    parenttabledataid = BaseJsonParser.goodInt(parsedJson, "parenttabledataid");
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    gradeid = BaseJsonParser.goodInt(parsedJson, "gradeid");
    rate = BaseJsonParser.goodDouble(parsedJson, "rate");
    currencyid = BaseJsonParser.goodInt(parsedJson, "currencyid");
    dtlisblockedyn = BaseJsonParser.goodString(parsedJson, "dtlisblockedyn");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    itemname = BaseJsonParser.goodString(parsedJson, "itemname");
    itemcode = BaseJsonParser.goodString(parsedJson, "itemcode");
    gradename = BaseJsonParser.goodString(parsedJson, "gradename");
    currencyname = BaseJsonParser.goodString(parsedJson, "currencyname");
  }
}
