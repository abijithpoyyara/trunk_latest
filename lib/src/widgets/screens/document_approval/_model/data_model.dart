// To parse this JSON data, do
//
//     final dataModel = dataModelFromJson(jsonString);

import 'dart:convert';

List<DataModel> dataModelFromJson(String str) => List<DataModel>.from(json.decode(str).map((x) => DataModel.fromJson(x)));

String dataModelToJson(List<DataModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class DataModel {
  DataModel({
    this.id,
    this.tableid,
    this.parenttableid,
    this.parenttabledataid,
    this.sortorder,
    this.dataindex,
    this.header,
    this.width,
    this.align,
    this.grouptitle,
    this.colspan,
    this.isvisibleyn,
    this.isdrilldowncolumnyn,
    this.lastmoduserid,
    this.lastmoddate,
    this.datatypebccid,
    this.formatnumberyn,
    this.datatype,
    this.value,
  });

  int id;
  int tableid;
  int parenttableid;
  int parenttabledataid;
  int sortorder;
  String dataindex;
  String header;
  int width;
  String align;
  String grouptitle;
  dynamic colspan;
  String isvisibleyn;
  String isdrilldowncolumnyn;
  int lastmoduserid;
  String lastmoddate;
  dynamic datatypebccid;
  String formatnumberyn;
  dynamic datatype;
  var value;

  factory DataModel.fromJson(Map<String, dynamic> json) => DataModel(
    id: json["id"],
    tableid: json["tableid"],
    parenttableid: json["parenttableid"],
    parenttabledataid: json["parenttabledataid"],
    sortorder: json["sortorder"],
    dataindex: json["dataindex"],
    header: json["header"],
    width: json["width"],
    align: json["align"],
    grouptitle: json["grouptitle"],
    colspan: json["colspan"],
    isvisibleyn: json["isvisibleyn"],
    isdrilldowncolumnyn: json["isdrilldowncolumnyn"],
    lastmoduserid: json["lastmoduserid"],
    lastmoddate: json["lastmoddate"],
    datatypebccid: json["datatypebccid"],
    formatnumberyn: json["formatnumberyn"],
    datatype: json["datatype"],
    value: json["value"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tableid": tableid,
    "parenttableid": parenttableid,
    "parenttabledataid": parenttabledataid,
    "sortorder": sortorder,
    "dataindex": dataindex,
    "header": header,
    "width": width,
    "align": align,
    "grouptitle": grouptitle,
    "colspan": colspan,
    "isvisibleyn": isvisibleyn,
    "isdrilldowncolumnyn": isdrilldowncolumnyn,
    "lastmoduserid": lastmoduserid,
    "lastmoddate": lastmoddate,
    "datatypebccid": datatypebccid,
    "formatnumberyn": formatnumberyn,
    "datatype": datatype,
    "value": value,
  };
}
