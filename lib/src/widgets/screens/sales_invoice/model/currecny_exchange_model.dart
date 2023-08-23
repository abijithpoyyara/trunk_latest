import 'package:base/services.dart';

import '../../../../../utility.dart';

class CurrencyExchangeModel extends BaseResponseModel {
  List<CurrencyExchange> currencyEx;

  CurrencyExchangeModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    currencyEx = BaseJsonParser.goodList(json, "currencyExchRateList")
        .map((e) => CurrencyExchange.fromJson(e))
        .toList();
  }
}

class CurrencyExchange {
  double conversionrate;
  int fromcurrencyid;
  int tocurrencyid;
  String fromcurrencyname;
  String tocurrencyname;

  CurrencyExchange.fromJson(Map<String, dynamic> json) {
    tocurrencyname = BaseJsonParser.goodString(json, "tocurrencyname");
    tocurrencyid = BaseJsonParser.goodInt(json, "tocurrencyid");
    fromcurrencyid = BaseJsonParser.goodInt(json, "fromcurrencyid");
    fromcurrencyname = BaseJsonParser.goodString(json, "fromcurrencyname");
    conversionrate = BaseJsonParser.goodDouble(json, "conversionrate");
  }
}
