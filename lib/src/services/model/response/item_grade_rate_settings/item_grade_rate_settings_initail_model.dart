import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';

import '../../../../../utility.dart';

class ItemGradeRateSettingsInitailModel extends BaseResponseModel {
  List<BusinessSubLevelObjModel> businessSubLevelObj;
  List<StockLocation> itemGradeRateLocationObj;
  List<BusinessLevelObjModel> businessLevelObj;
  List<BCCModel> currencyList;
  ItemGradeRateSettingsInitailModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    businessSubLevelObj =
        BaseJsonParser.goodList(parsedJson, "businessSubLevelObj")
            .map((e) => BusinessSubLevelObjModel.fromJson(e))
            .toList();

    currencyList = BaseJsonParser.goodList(parsedJson, "currencyList")
        .map((e) => BCCModel.fromJson(e))
        .toList();
    itemGradeRateLocationObj =
        BaseJsonParser.goodList(parsedJson, "locationObj")
            .map((e) => StockLocation.fromJson(e))
            .toList();
    businessLevelObj = BaseJsonParser.goodList(parsedJson, "businessLevelObj")
        .map((e) => BusinessLevelObjModel.fromJson(e))
        .toList();
  }
}

class BusinessSubLevelObjModel {
  int id;
  int businesssubleveloptionid;
  int levelno;
  String code;
  String name;
  BusinessSubLevelObjModel.fromJson(Map<String, dynamic> json) {
    name = BaseJsonParser.goodString(json, "name");
    code = BaseJsonParser.goodString(json, "code");
    levelno = BaseJsonParser.goodInt(json, "levelno");
    id = BaseJsonParser.goodInt(json, "id");
    businesssubleveloptionid =
        BaseJsonParser.goodInt(json, "businesssubleveloptionid");
  }
}

class BusinessLevelObjModel {
  int optionid;
  String code;
  String name;
  String serialnocode;
  int companyid;
  String isactive;
  int currencyid;
  int Id;
  int tableid;
  int LastModUserId;
  bool docAttachReqYN;
  String LastModeDate;
  List<AddModel> addModel;
  List<ExtensionDataObjModel> extensionDataObjModel;
  BusinessLevelObjModel.fromJson(Map parsedJson) {
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    code = BaseJsonParser.goodString(parsedJson, "code");
    name = BaseJsonParser.goodString(parsedJson, "name");
    serialnocode = BaseJsonParser.goodString(parsedJson, "serialnocode");
    companyid = BaseJsonParser.goodInt(parsedJson, "companyid");
    isactive = BaseJsonParser.goodString(parsedJson, "isactive");
    currencyid = BaseJsonParser.goodInt(parsedJson, "currencyid");
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    LastModUserId = BaseJsonParser.goodInt(parsedJson, "LastModUserId");
    docAttachReqYN = BaseJsonParser.goodBoolean(parsedJson, "docAttachReqYN");
    LastModeDate = BaseJsonParser.goodString(parsedJson, "LastModDate");
    addModel = BaseJsonParser.goodList(parsedJson, "addmodel")
        .map((e) => AddModel.fromJson(e))
        .toList();
    extensionDataObjModel =
        BaseJsonParser.goodList(parsedJson, "extensionDataObj")
            .map((e) => ExtensionDataObjModel.fromJson(e))
            .toList();
  }
}

class AddComModel {
  int Id;
  int optionid;
  int tableid;
  int parenttableid;
  int parenttabledataid;
  int communicationtypebccid;
  String communicationno;
  String remarks;
  int LastModUserId;
  String LastModDate;
  AddComModel.fromJson(Map parsedJson) {
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    parenttableid = BaseJsonParser.goodInt(parsedJson, "parenttableid");
    parenttabledataid = BaseJsonParser.goodInt(parsedJson, "parenttabledataid");
    communicationtypebccid =
        BaseJsonParser.goodInt(parsedJson, "communicationtypebccid");
    communicationno = BaseJsonParser.goodString(parsedJson, "communicationno");
    remarks = BaseJsonParser.goodString(parsedJson, "remarks");
    LastModUserId = BaseJsonParser.goodInt(parsedJson, "LastModUserId");
    LastModDate = BaseJsonParser.goodString(parsedJson, "LastModDate");
  }
}

class AddModel {
  int optionid;
  int reftableid;
  int reftabledataid;
  String address1;
  String address2;
  String address3;
  int countryid;
  int stateid;
  List<AddComModel> addComModel;
  AddModel.fromJson(Map parsedJson) {
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    reftableid = BaseJsonParser.goodInt(parsedJson, "reftableid");
    reftabledataid = BaseJsonParser.goodInt(parsedJson, "reftabledataid");
    address1 = BaseJsonParser.goodString(parsedJson, "address1");
    address2 = BaseJsonParser.goodString(parsedJson, "address2");
    address3 = BaseJsonParser.goodString(parsedJson, "address3");
    countryid = BaseJsonParser.goodInt(parsedJson, "countryid");
    stateid = BaseJsonParser.goodInt(parsedJson, "stateid");
    addComModel = BaseJsonParser.goodList(parsedJson, "addComModel")
        .map((e) => AddComModel.fromJson(e))
        .toList();
  }
}

class ExtensionDataObjModel {
  int Id;
  int tableid;
  int LastModUserId;
  int optionid;
  int parenttableid;
  int parenttabledataid;
  int companyid;
  int reftableid;
  int reftabledataid;
  bool fieldvalue;
  String LastModDate;
  ExtensionDataObjModel.fromJson(Map parsedJson) {
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    LastModUserId = BaseJsonParser.goodInt(parsedJson, "LastModUserId");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    parenttableid = BaseJsonParser.goodInt(parsedJson, "parenttableid");
    parenttabledataid = BaseJsonParser.goodInt(parsedJson, "parenttabledataid");
    companyid = BaseJsonParser.goodInt(parsedJson, "companyid");
    reftableid = BaseJsonParser.goodInt(parsedJson, "reftableid");
    reftabledataid = BaseJsonParser.goodInt(parsedJson, "reftabledataid");
    fieldvalue = BaseJsonParser.goodBoolean(parsedJson, "fieldvalue");
    LastModDate = BaseJsonParser.goodString(parsedJson, "LastModDate");
  }
}
