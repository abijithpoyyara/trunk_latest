import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class TransactionStatusModel extends BaseResponseModel {
  List<TransactionStatusItem> status;

  TransactionStatusModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    status = BaseJsonParser.goodList(json, "statusObject")
        .map((e) => TransactionStatusItem.fromJson(e))
        .toList();
  }
}

class TransactionStatusItem {
  String code;
  String description;
  String extra;
  String fieldcodename;
  int id;

  TransactionStatusItem.fromJson(Map<String, dynamic> json) {
    code = BaseJsonParser.goodString(json, "code");
    description = BaseJsonParser.goodString(json, "description");
    extra = BaseJsonParser.goodString(json, "extra");
    fieldcodename = BaseJsonParser.goodString(json, "fieldcodename");
    id = BaseJsonParser.goodInt(json, "id");
  }
}
