import 'package:base/services.dart';

import '../../../../../utility.dart';

class ServiceModel extends BaseResponseModel {
  List<ServiceList> serviceList;

  ServiceModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    serviceList = BaseJsonParser.goodList(json, "serviceObject")
        .map((e) => ServiceList.fromJson(e))
        .toList();
  }
}

class ServiceList {
  int accountid;
  int id;
  int limit;
  int optionid;
  int serviceid;
  int rowno;
  int start;
  String accountcode;
  String accountname;
  String code;
  String description;
  String optioncode;

  ServiceList.fromJson(Map<String, dynamic> json) {
    accountid = BaseJsonParser.goodInt(json, "accountid");
    id = BaseJsonParser.goodInt(json, "id");
    limit = BaseJsonParser.goodInt(json, "limit");
    optionid = BaseJsonParser.goodInt(json, "optionid");
    serviceid = BaseJsonParser.goodInt(json, "serviceid");
    rowno = BaseJsonParser.goodInt(json, "rowno");
    start = BaseJsonParser.goodInt(json, "start");
    accountcode = BaseJsonParser.goodString(json, "accountcode");
    accountname = BaseJsonParser.goodString(json, "accountname");
    code = BaseJsonParser.goodString(json, "code");
    description = BaseJsonParser.goodString(json, "description");
    optioncode = BaseJsonParser.goodString(json, "optioncode");
  }
}
