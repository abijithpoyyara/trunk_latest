import 'package:base/services.dart';

import '../../../../../utility.dart';

class ItemGradeRateSettingsViewPageModel extends BaseResponseModel {
  List<ItemGradeRateSettingsViewPageList> itemGradeRateSettingsViewPage;

  int EOR_Id;
  int SOR_Id;
  int TotalRecords;
  ItemGradeRateSettingsViewPageModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    itemGradeRateSettingsViewPage =
        BaseJsonParser.goodList(parsedJson, "resultObject")
            .map((e) => ItemGradeRateSettingsViewPageList.fromJson(e))
            .toList();

    SOR_Id = parsedJson["SOR_Id"];
    EOR_Id = parsedJson["EOR_Id"];
    TotalRecords = parsedJson["TotalRecords"];
  }
}

class ItemGradeRateSettingsViewPageList {
  int slno;
  int nextrowno;
  int prevrowno;
  int tableid;
  int optionid;
  String pricingno;
  String pricingwefdate;
  String businesssublevel;
  String createddate;
  String createduser;
  String apprvlstatus;
  int nextid;
  int previd;
  int start;
  int limit;
  int totalrecords;
  int Id;
  ItemGradeRateSettingsViewPageList.fromJson(Map parsedJson) {
    slno = BaseJsonParser.goodInt(parsedJson, "slno");
    nextrowno = BaseJsonParser.goodInt(parsedJson, "nextrowno");
    prevrowno = BaseJsonParser.goodInt(parsedJson, "prevrowno");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    pricingno = BaseJsonParser.goodString(parsedJson, "pricingno");
    pricingwefdate = BaseJsonParser.goodString(parsedJson, "pricingwefdate");
    businesssublevel =
        BaseJsonParser.goodString(parsedJson, "businesssublevel");
    createddate = BaseJsonParser.goodString(parsedJson, "createddate");
    createduser = BaseJsonParser.goodString(parsedJson, "createduser");
    apprvlstatus = BaseJsonParser.goodString(parsedJson, "apprvlstatus");
    nextid = BaseJsonParser.goodInt(parsedJson, "nextid");
    previd = BaseJsonParser.goodInt(parsedJson, "previd");
    start = BaseJsonParser.goodInt(parsedJson, "start");
    limit = BaseJsonParser.goodInt(parsedJson, "limit");
    totalrecords = BaseJsonParser.goodInt(parsedJson, "totalrecords");
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
  }
}
