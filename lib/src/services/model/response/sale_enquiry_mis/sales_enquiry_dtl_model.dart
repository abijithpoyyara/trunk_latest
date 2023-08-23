import 'package:redstars/utility.dart';

class SalesEnquiryDtlModel {
  String particulars;
  int total;
  List<MisEnquiryDtl> details;

  SalesEnquiryDtlModel.fromJson(Map<String, dynamic> json) {
    particulars = BaseJsonParser.goodString(json, "particulars");
    total = BaseJsonParser.goodInt(json, "totalcount") ?? 0;
    details = BaseJsonParser.goodList(json, "dtljson")
        .map((e) => MisEnquiryDtl.fromJson(e))
        .toList();
  }
}

class MisEnquiryDtl {
  String enquiryNo;
  String enquiryUniqueNo;
  String enquiryDate;
  String branch;
  String status;

  MisEnquiryDtl.fromJson(Map<String, dynamic> json) {
    enquiryNo = BaseJsonParser.goodString(json, "salenquiryno");
    enquiryUniqueNo = BaseJsonParser.goodString(json, "saleenquniqueno");
    enquiryDate = BaseJsonParser.goodString(json, "salenquirydate");
    branch = BaseJsonParser.goodString(json, "branch");
    status = BaseJsonParser.goodString(json, "status");
  }
}
