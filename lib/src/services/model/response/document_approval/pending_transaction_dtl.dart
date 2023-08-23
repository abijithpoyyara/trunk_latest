import 'package:base/services.dart';
import 'package:base/utility.dart';

class PendingTransactionDtlModel extends BaseResponseModel {
  List<TransactionDtlApproval> dtlList = List();

  PendingTransactionDtlModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson.containsKey("resultObject") &&
        parsedJson["resultObject"] != null) {
      parsedJson["resultObject"].forEach(
          (data) => dtlList.add(TransactionDtlApproval.fromJson(data)));
    }
  }
}

class TransactionDtlApproval {
  String table;
  int dtlTableId;
  int dtlDataId;
  String proformaInvoiceDtl;
  bool selected;
  Map<String, dynamic> data;

  TransactionDtlApproval.fromJson(Map<String, dynamic> json) {
    table = BaseJsonParser.goodString(json, "table");
    dtlTableId = BaseJsonParser.goodInt(json, "dtltableid");
    dtlDataId = BaseJsonParser.goodInt(json, "dtldataid");
    proformaInvoiceDtl = BaseJsonParser.goodString(json, "proformainvoicedtl");
    data = json;
    selected = BaseJsonParser.goodBoolean(json, "select") ?? false;
  }
}
