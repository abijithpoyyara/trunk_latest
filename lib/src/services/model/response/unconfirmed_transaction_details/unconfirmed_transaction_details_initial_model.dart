import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class UnConfirmedTransactionDetailInitialConfigModel extends BaseResponseModel {
  List<BCCModel> statusTypes;
  List<BCCModel> transactionOptionTypes;

  UnConfirmedTransactionDetailInitialConfigModel.fromJson(
      Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    statusTypes = BaseJsonParser.goodList(parsedJson, "statusObj")
        .map((e) => BCCModel.fromJson(e))
        .toList();
    transactionOptionTypes =
        BaseJsonParser.goodList(parsedJson, "transOptionObj")
            .map((e) => BCCModel.fromJson(e))
            .toList();
  }
}
