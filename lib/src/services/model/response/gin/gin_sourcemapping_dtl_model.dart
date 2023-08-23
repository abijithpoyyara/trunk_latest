import 'package:base/services.dart';

import '../../../../../utility.dart';

class GINSourceMappingDtlModel extends BaseResponseModel {
  List<GINSourceMappingDtlList> gradeRateList;

  GINSourceMappingDtlModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    gradeRateList = BaseJsonParser.goodList(json, "resultObj")
        .map((e) => GINSourceMappingDtlList.fromJson(e))
        .toList();
  }
}

class GINSourceMappingDtlList {
  int identificationno;
  int supplierid;
  String suppliername;
  int amendmentno;
  int reftabledataid;
  int reftableid;
  int poid;
  int potableid;
  int refhdrtabledataid;
  int refhdrtableid;
  String transactionno;
  String transactiondate;
  double qty;
  int itemid;
  String itemname;
  int uomid;
  String uomname;
  int uomtypebccid;
  int rate;
  int totalvalue;
  int statusbccid;
  int companyid;
  int branchid;
  int finyearid;
  int refoptionid;
  String isbarcodedyn;
  int fccurrencyid;
  int lccurrencyid;
  int exchrate;
  int bookstockoptionid;
  String bookstockenteredyn;
  int id;
  GINSourceMappingDtlList(
      {this.id,
      this.refhdrtabledataid,
      this.reftableid,
      this.refhdrtableid,
      this.reftabledataid,
      this.uomtypebccid,
      this.uomid});
  GINSourceMappingDtlList.fromJson(Map parsedJson) {
    //Map<String, dynamic> json = parsedJson['resultObject'][0];
    identificationno = BaseJsonParser.goodInt(parsedJson, "identificationno");
    supplierid = BaseJsonParser.goodInt(parsedJson, "supplierid");
    suppliername = BaseJsonParser.goodString(parsedJson, "suppliername");
    amendmentno = BaseJsonParser.goodInt(parsedJson, "amendmentno");
    reftabledataid = BaseJsonParser.goodInt(parsedJson, "reftabledataid");
    reftableid = BaseJsonParser.goodInt(parsedJson, "reftableid");
    poid = BaseJsonParser.goodInt(parsedJson, "poid");
    potableid = BaseJsonParser.goodInt(parsedJson, "potableid");
    refhdrtabledataid = BaseJsonParser.goodInt(parsedJson, "refhdrtabledataid");
    refhdrtableid = BaseJsonParser.goodInt(parsedJson, "refhdrtableid");
    transactionno = BaseJsonParser.goodString(parsedJson, "transactionno");
    transactiondate = BaseJsonParser.goodString(parsedJson, "transactiondate");
    qty = BaseJsonParser.goodDouble(parsedJson, "qty");
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    itemname = BaseJsonParser.goodString(parsedJson, "itemname");
    uomid = BaseJsonParser.goodInt(parsedJson, "uomid");
    uomname = BaseJsonParser.goodString(parsedJson, "uomname");
    uomtypebccid = BaseJsonParser.goodInt(parsedJson, "uomtypebccid");
    rate = BaseJsonParser.goodInt(parsedJson, "rate");
    totalvalue = BaseJsonParser.goodInt(parsedJson, "totalvalue");
    statusbccid = BaseJsonParser.goodInt(parsedJson, "statusbccid");
    companyid = BaseJsonParser.goodInt(parsedJson, "companyid");
    branchid = BaseJsonParser.goodInt(parsedJson, "branchid");
    finyearid = BaseJsonParser.goodInt(parsedJson, "finyearid");
    refoptionid = BaseJsonParser.goodInt(parsedJson, "refoptionid");
    isbarcodedyn = BaseJsonParser.goodString(parsedJson, "isbarcodedyn");
    fccurrencyid = BaseJsonParser.goodInt(parsedJson, "fccurrencyid");
    lccurrencyid = BaseJsonParser.goodInt(parsedJson, "lccurrencyid");
    exchrate = BaseJsonParser.goodInt(parsedJson, "exchrate");
    bookstockoptionid = BaseJsonParser.goodInt(parsedJson, "bookstockoptionid");
    bookstockenteredyn =
        BaseJsonParser.goodString(parsedJson, "bookstockenteredyn");
  }
}
