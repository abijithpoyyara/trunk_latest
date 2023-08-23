import 'package:base/services.dart';

class LookupModel extends BaseResponseModel {
  List<LookupItems> lookupItems;

  int SOR_Id;
  int EOR_Id;
  int totalRecords;

  LookupModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      lookupItems = new List<LookupItems>();
      parsedJson['resultObject'].forEach((mod) {
        lookupItems.add(new LookupItems.fromJson(mod));
      });
    } else {
      lookupItems = List<LookupItems>();
    }
    SOR_Id = parsedJson["SOR_Id"];
    EOR_Id = parsedJson["EOR_Id"];
    totalRecords = parsedJson["TotalRecords"];
  }
}

class LookupItems {
  int start;
  int limit;
  int id;
  int totalrecords;
  String code;
  String description;

  LookupItems({this.id, this.code, this.description});

  LookupItems.fromJson(Map<String, dynamic> json) {
    id = json["Id"];
    start = json["start"];
    limit = json["limit"];
    code = json["code"];
    description = json["description"];
    totalrecords = json["totalrecords"];
  }

  Map toMap() {
    Map<String, dynamic> kMap = Map<String, dynamic>();
    kMap["start"] = start;
    kMap["id"] = id;
    kMap["limit"] = limit;
    kMap["code"] = code;
    kMap["description"] = description;
    kMap["totalrecords"] = totalrecords;
    return kMap;
  }

  @override
  String toString() {
    return toMap().toString();
  }
}
