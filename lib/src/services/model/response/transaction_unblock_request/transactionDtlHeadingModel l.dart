import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class TransactionReqHeading extends BaseResponseModel {
  List<TransactionReqHeadingList> transactionReqHeadingList;

  TransactionReqHeading.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    transactionReqHeadingList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => TransactionReqHeadingList.fromJson(e))
        .toList();
  }
}

class TransactionReqHeadingList {
  String actionflg;
  String formatcode;
  String formatname;
  int id;
  String isdrilldownyn;
  int optionid;
  int parentformatid;
  String procedurename;
  int reportengineid;
  String subflag;
  int tableid;
  List<TableDetail> dtl;

  TransactionReqHeadingList.fromJson(Map parsedJson) {
    actionflg = BaseJsonParser.goodString(parsedJson, "actionflg");
    formatcode = BaseJsonParser.goodString(parsedJson, "formatcode");
    formatname = BaseJsonParser.goodString(parsedJson, "formatname");
    id = BaseJsonParser.goodInt(parsedJson, "id");
    isdrilldownyn = BaseJsonParser.goodString(parsedJson, "optionid");
    optionid = BaseJsonParser.goodInt(parsedJson, "formatnumberyn");
    parentformatid = BaseJsonParser.goodInt(parsedJson, "parentformatid");
    procedurename = BaseJsonParser.goodString(parsedJson, "procedurename");
    reportengineid = BaseJsonParser.goodInt(parsedJson, "vreportengineid");
    subflag = BaseJsonParser.goodString(parsedJson, "subflag");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    dtl = BaseJsonParser.goodList(parsedJson, "dtl")
        .map((e) => TableDetail.fromJson(e))
        .toList();
  }
}

  class TableDetail {
  String align;
  String colspan;
  String dataindex;
  String datatype;
  int datatypebccid;
  String formatnumberyn;
  String grouptitle;
  String header;
  int id;
  String isdrilldowncolumnyn;
  String isvisibleyn;
  String lastmoddate;
  int lastmoduserid;
  int parenttabledataid;
  int parenttableid;
  int sortorder;
  int tableid;
  int width;

  TableDetail.fromJson(Map parsedJson) {
  align = BaseJsonParser.goodString(parsedJson, "align");
  colspan = BaseJsonParser.goodString(parsedJson, "colspan");
  dataindex = BaseJsonParser.goodString(parsedJson, "dataindex");
  datatype = BaseJsonParser.goodString(parsedJson, "datatype");
  datatypebccid = BaseJsonParser.goodInt(parsedJson, "datatypebccid");
  formatnumberyn = BaseJsonParser.goodString(parsedJson, "formatnumberyn");
  grouptitle = BaseJsonParser.goodString(parsedJson, "grouptitle");
  header = BaseJsonParser.goodString(parsedJson, "header");
  id = BaseJsonParser.goodInt(parsedJson, "id");
  isdrilldowncolumnyn = BaseJsonParser.goodString(parsedJson, "isdrilldowncolumnyn");
  isvisibleyn = BaseJsonParser.goodString(parsedJson, "isvisibleyn");
  lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
  lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
  parenttabledataid = BaseJsonParser.goodInt(parsedJson, "parenttabledataid");
  parenttableid = BaseJsonParser.goodInt(parsedJson, "parenttableid");
  sortorder = BaseJsonParser.goodInt(parsedJson, "sortorder");
  tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
  width = BaseJsonParser.goodInt(parsedJson, "width");
  }
}