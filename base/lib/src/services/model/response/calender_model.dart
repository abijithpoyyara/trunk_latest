import 'package:base/src/utils/base_json_parser.dart';

class FinYearModel {
  int id;
  int tableId;
  String finyearcode;
  String finyeardesc;
  String finyearenddate;
  String finyearstartdate;

  FinYearModel.fromJson(Map<String, dynamic> json) {
    id = BaseJsonParser.goodInt(json, "Id");
    tableId = BaseJsonParser.goodInt(json, "tableid");
    finyearcode = BaseJsonParser.goodString(json, "finyearcode");
    finyeardesc = BaseJsonParser.goodString(json, "finyeardesc");
    finyearenddate = BaseJsonParser.goodString(json, "finyearenddate");
    finyearstartdate = BaseJsonParser.goodString(json, "finyearstartdate");
  }
}

class CalendarModel {
  int id;
  int tableid;
  int parenttableid;
  int parenttabledataid;
  int monthnumber;

  int start;
  int limit;
  int totalrecords;

  String monthcode;
  String monthname;
  String startdate;
  String enddate;

  CalendarModel({
    this.id,
    this.tableid,
    this.parenttableid,
    this.parenttabledataid,
    this.monthnumber,
    this.monthcode,
    this.monthname,
    this.startdate,
    this.enddate,
    this.start,
    this.limit,
    this.totalrecords,
  });

  CalendarModel.fromJson(dynamic json) {
    id = BaseJsonParser.goodInt(json, "id");
    tableid = BaseJsonParser.goodInt(json, "tableid");
    parenttableid = BaseJsonParser.goodInt(json, "parenttableid");
    parenttabledataid = BaseJsonParser.goodInt(json, "parenttabledataid");
    start = BaseJsonParser.goodInt(json, "start");
    limit = BaseJsonParser.goodInt(json, "limit");
    totalrecords = BaseJsonParser.goodInt(json, "totalrecords");
    monthnumber = BaseJsonParser.goodInt(json, "monthnumber");

    monthcode = BaseJsonParser.goodString(json, "monthcode");
    monthname = BaseJsonParser.goodString(json, "monthname");
    startdate = BaseJsonParser.goodString(json, "startdate");
    enddate = BaseJsonParser.goodString(json, "enddate");
  }
}
