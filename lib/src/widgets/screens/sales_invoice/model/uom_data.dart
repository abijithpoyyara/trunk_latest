import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';

import '../../../../../utility.dart';

class UomModel extends BaseResponseModel {
  List<UomTypes> uomList;

  UomModel.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    uomList = BaseJsonParser.goodList(json, "uomObject")
        .map((e) => UomTypes.fromJson(e))
        .toList();
  }
}
