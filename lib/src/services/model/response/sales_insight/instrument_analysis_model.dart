import 'package:base/services.dart';
import 'package:base/utility.dart';

class InstrumentHeaderModel extends BaseResponseModel {
  final String resultKey = "resultObject";

  List<InstrumentHeader> instrumentHeaders;

  InstrumentHeaderModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    instrumentHeaders = List();
    if (parsedJson.containsKey(resultKey) && parsedJson[resultKey] != null) {
      parsedJson[resultKey]?.forEach((json) {
        instrumentHeaders.add(InstrumentHeader.fromJson(json));
      });
    }
  }
}

class InstrumentHeader {
  int colorder;
  String dataindex;
  String grouptitle;
  String header;
  int sortorder;

  InstrumentHeader.fromJson(Map<String, dynamic> json) {
    colorder = BaseJsonParser.goodInt(json, "colorder");
    dataindex = BaseJsonParser.goodString(json, "dataindex");
    grouptitle = BaseJsonParser.goodString(json, "grouptitle");
    header = BaseJsonParser.goodString(json, "header");
    sortorder = BaseJsonParser.goodInt(json, "sortorder");
  }
}

class InstrumentAnalysisModel extends BaseResponseModel {
  final String resultKey = "resultObject";

  List<Map<String, dynamic>> instrumentDtl;
  List<CoordinatesDtl> coordinatesDtl;

  InstrumentAnalysisModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    instrumentDtl = List();
    coordinatesDtl = List();
    if (parsedJson.containsKey(resultKey) && parsedJson[resultKey] != null) {
      parsedJson[resultKey][0]["instrumentdetails"]
          .forEach((e) => instrumentDtl.add(Map<String, dynamic>.from(e)));

      parsedJson[resultKey][0]["coordinatesdtl"].forEach((coordinate) =>
          coordinatesDtl.add(CoordinatesDtl.fromJson(coordinate)));
    }
  }
}

class CoordinatesDtl {
  double advance;
  double axisCard;
  String branch;
  int branchId;
  double credit;
  int subRowNo;
  double total;

  CoordinatesDtl.fromJson(Map<String, dynamic> json) {
    advance = BaseJsonParser.goodDouble(json, "advance");
    axisCard = BaseJsonParser.goodDouble(json, "axis_card");
    branch = BaseJsonParser.goodString(json, "branch");
    branchId = BaseJsonParser.goodInt(json, "branchid");
    credit = BaseJsonParser.goodDouble(json, "credit");
    subRowNo = BaseJsonParser.goodInt(json, "subrowno");
    total = BaseJsonParser.goodDouble(json, "total");
  }
}
