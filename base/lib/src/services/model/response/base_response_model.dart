/// Base class for http response model
class BaseResponseModel {
  var statusCode;
  String statusMessage;
  bool result;
  String voucherno;

  BaseResponseModel.fromJson(Map<String, dynamic> parsedJson) {
    statusCode = parsedJson['statusCode'];
    statusMessage = parsedJson['statusMessage'];
    voucherno = parsedJson['Voucherno'];
    result = parsedJson.containsKey("resultObject") &&
        parsedJson["resultObject"] != null;
  }

  Map toMap() {
    Map map = Map<String, dynamic>();
    map["statusCode"] = statusCode;
    map["_statusMessage"] = statusMessage;
    return map;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
