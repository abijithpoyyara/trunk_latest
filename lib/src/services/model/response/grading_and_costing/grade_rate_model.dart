import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class GradeRateModel extends BaseResponseModel {
  List<GradeRateList> gradeRateList;

  GradeRateModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    gradeRateList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => GradeRateList.fromJson(e))
        .toList();
  }
}

class GradeRateList {
  int currencyId;
  double rate;
  String currencyName;

  GradeRateList.fromJson(Map<String, dynamic> json) {
    currencyId = BaseJsonParser.goodInt(json, "currencyid");
    rate = BaseJsonParser.goodDouble(json, "rate");
    currencyName = BaseJsonParser.goodString(json, "name");
  }
}
