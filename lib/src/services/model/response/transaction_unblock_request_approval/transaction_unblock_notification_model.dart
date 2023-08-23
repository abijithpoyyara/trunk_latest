import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_list_head_model.dart';
import 'package:redstars/src/services/model/response/transaction_unblock_request_approval/transaction_list_model.dart';

import '../../../../../utility.dart';


class TransactionUnblockNotificationModel extends BaseResponseModel {
  TransUnblockNotificationItems notificationItems;

  TransactionUnblockNotificationModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson.containsKey("resultObject") &&
        parsedJson["resultObject"] != null) {
      notificationItems = TransUnblockNotificationItems.cast(parsedJson["resultObject"][0]);
    }
  }
}

class TransUnblockNotificationItems {

  List<TransactionUnblockListView> transactionDtl;
  List<TransactionUnblockListHeading> reportformatDtl;

  TransUnblockNotificationItems.cast(Map<String, dynamic> json) {
    transactionDtl = List();
    reportformatDtl = List();

    if (json.containsKey("transactiondtl"))
      json["transactiondtl"]?.forEach((obj) => {
        transactionDtl.add(TransactionUnblockListView.fromJson(obj))
      });

    if (json.containsKey("reportformatdtl"))
      json["reportformatdtl"]?.forEach(
              (obj) => reportformatDtl.add(TransactionUnblockListHeading.fromJson(obj)));

  }
}



