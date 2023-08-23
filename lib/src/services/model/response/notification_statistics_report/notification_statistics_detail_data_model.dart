import 'package:base/services.dart';
import 'package:redstars/utility.dart';

class NotificationStatisticsDetailDataModel extends BaseResponseModel{
  List<NotificationStatisticsDetailData> notificationDetailData;

  NotificationStatisticsDetailDataModel.fromJson(Map<String, dynamic> json)
    : super.fromJson(json) {
    notificationDetailData = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => NotificationStatisticsDetailData.fromJson(e))
        .toList();
  }
}

class NotificationStatisticsDetailData {
  int id;
  int slno;
  int start;
  int limit;
  int totalrecords;
  int tableid;
  String transno;
  List child;
  List childmap;
  var header;
  Map<String, dynamic> childData;
  // List childList;
  List<HeaderDtl> headerDtl;
  List<ChildDtl> childDtl;
  List selecedChildData=[];
  List<Map<String, dynamic>> listChildMapDtl = [];
  var mappedHeaderDtl;
  var mappedChildDtl;
  NotificationStatisticsDetailData.fromJson(Map<String, dynamic> parsedJson){
    id = BaseJsonParser.goodInt(parsedJson, "id");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    slno = BaseJsonParser.goodInt(parsedJson, "slno");
    start = BaseJsonParser.goodInt(parsedJson, "start");
    limit = BaseJsonParser.goodInt(parsedJson, "limit");
    transno = BaseJsonParser.goodString(parsedJson, "transno");
    totalrecords = BaseJsonParser.goodInt(parsedJson, "totalrecords");
    headerDtl = BaseJsonParser.goodList(parsedJson, "header")
        .map((e) => HeaderDtl.fromJson(e))
        .toList();
    // childDtl.map((e) => ChildDtl.fromJson(parsedJson)).toList();
    // childDtl = parsedJson['childjson'];
    // childDtl = BaseJsonParser.goodList(parsedJson, "childjson")
    //     .map((e) => ChildDtl.fromJson(e))
    //     .toList();
    child = parsedJson['childjson'];
    // childData = parsedJson["childjson"];

  child.forEach((element) {

    var k=element[0]['child'];
selecedChildData.add(k);
    print(k);
    return selecedChildData;
  });
 print(selecedChildData) ;
    // childmap = parsedJson['childjson']['child'];
    header = parsedJson['header'];
    // childList.add(child);
    // child = parsedJson;
    // listChildMapDtl.add(child);
    mappedHeaderDtl =
        BaseJsonParser.goodList(parsedJson, "header").map((e) => HeaderDtl.fromJson(e));
    mappedChildDtl =
        BaseJsonParser.goodList(parsedJson, "childjson").map((e) => ChildDtl.fromJson(e));
  }
}

class HeaderDtl{
  Map<String, dynamic> header;
  List<Map<String, dynamic>> headerDtl = [];
  HeaderDtl.fromJson(Map<String, dynamic> parsedJson) {
    header = parsedJson;
    headerDtl.add(header);
  }
}

class ChildDtl{
  int id;
  int tableid;
  int reqid;
  Map<String, dynamic> child;
  // List<Map<String, dynamic>> childMapDtl;
  ChildDtl.fromJson(Map<String, dynamic> parsedJson) {
    id = BaseJsonParser.goodInt(parsedJson, "id");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    reqid = BaseJsonParser.goodInt(parsedJson, "reqid");
    child = parsedJson;
    // childMapDtl.add(child);

    // childMapDtl = BaseJsonParser.goodList(parsedJson, "childjson")
    //     .map((e) => ChildMapDtl.fromJson(e))
    //     .toList();
  }
}

class ChildMapDtl {
  Map<String, dynamic> childMapDtl;
  List<Map<String, dynamic>> listChildMapDtl = [];
  ChildMapDtl.fromJson(Map<String, dynamic> parsedJson) {
    childMapDtl = parsedJson;
    listChildMapDtl.add(childMapDtl);
  }
}