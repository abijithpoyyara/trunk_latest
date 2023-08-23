import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class PaymentRequisitionConfigModel extends BaseResponseModel {
  List<BSCModel> settleWithin;
  List<BSCModel> analysisCode;
  List<BSCModel> analysisType;
  List<BCCModel> reqFromModel;
  List<BCCModel> reqTransTypeModel;
  List<BCCModel> reqProcessTypeModel;
  List<BCCModel> paymentTypeModel;
  List<TaxConfigModel> taxConfigs;
  List<ServiceModel> serviceTypes;

  PaymentRequisitionConfigModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    settleWithin = BaseJsonParser.goodList(parsedJson, "settleWithinObj")
        .map((e) => BSCModel.fromJson(e))
        .toList();

    reqFromModel = BaseJsonParser.goodList(parsedJson, "reqFromObj")
        .map((e) => BCCModel.fromJson(e))
        .toList();
    reqTransTypeModel = BaseJsonParser.goodList(parsedJson, "reqTransTypeObj")
        .map((e) => BCCModel.fromJson(e))
        .toList();
    reqProcessTypeModel = BaseJsonParser.goodList(parsedJson, "transTypeAllObj")
        .map((e) => BCCModel.fromJson(e))
        .toList();
    paymentTypeModel = BaseJsonParser.goodList(parsedJson, "reqTypeObj")
        .map((e) => BCCModel.fromJson(e))
        .toList();
    taxConfigs = BaseJsonParser.goodList(parsedJson, "taxConfigObj")
        .map((e) => TaxConfigModel.fromJson(e))
        .toList();
    analysisCode = BaseJsonParser.goodList(parsedJson, "analysisCodeObj")
        .map((e) => BSCModel.fromJson(e))
        .toList();
    analysisType = BaseJsonParser.goodList(parsedJson, "analysisCodeTypeObj")
        .map((e) => BSCModel.fromJson(e))
        .toList();
    serviceTypes = BaseJsonParser.goodList(parsedJson, "serviceObject")
        .map((e) => ServiceModel.fromJson(e))
        .toList();
  }
}

class ServiceModel {
  String accountcode;
  String accountname;
  String code;
  String description;
  String optioncode;
  int accountid;
  int id;
  int serviceid;
  int optionid;
  int totalrecords;
  int start;
  int rowno;

  ServiceModel.fromJson(Map<String, dynamic> json) {
    accountcode = BaseJsonParser.goodString(json, "accountcode");
    accountname = BaseJsonParser.goodString(json, "accountname");
    code = BaseJsonParser.goodString(json, "code");
    description = BaseJsonParser.goodString(json, "description");
    optioncode = BaseJsonParser.goodString(json, "optioncode");
    accountid = BaseJsonParser.goodInt(json, "accountid");
    id = BaseJsonParser.goodInt(json, "id");
    serviceid = BaseJsonParser.goodInt(json, "serviceid");
    optionid = BaseJsonParser.goodInt(json, "optionid");
    totalrecords = BaseJsonParser.goodInt(json, "totalrecords");
    start = BaseJsonParser.goodInt(json, "start");
    rowno = BaseJsonParser.goodInt(json, "rowno");
  }
}


class TaxConfigModel {
  List<TaxDtlModel> taxdtl;
  String attachment;
  String attachmentdesc;
  String calculateon;
  int attachmentid;
  int effectonparty;
  int sortorder;

  TaxConfigModel.fromJson(Map<String, dynamic> json) {
    attachment = BaseJsonParser.goodString(json, "attachment");
    attachmentdesc = BaseJsonParser.goodString(json, "attachmentdesc");
    calculateon = BaseJsonParser.goodString(json, "calculateon");
    attachmentid = BaseJsonParser.goodInt(json, "attachmentid");
    effectonparty = BaseJsonParser.goodInt(json, "effectonparty");
    sortorder = BaseJsonParser.goodInt(json, "sortorder");
    taxdtl = BaseJsonParser.goodList(json, "taxdtljson")
        .map((e) => TaxDtlModel.fromJson(e))
        .toList();
  }
}

class TaxDtlModel {
  int accountid;
  int taxperc;

  TaxDtlModel.fromJson(Map<String, dynamic> json) {
    accountid = BaseJsonParser.goodInt(json, "accountid");
    taxperc = BaseJsonParser.goodInt(json, "taxperc");
  }
}
