  // To parse this JSON data, do
//
//     final dataJsonModel = dataJsonModelFromJson(jsonString);

import 'dart:convert';

DataJsonModel dataJsonModelFromJson(String str) => DataJsonModel.fromJson(json.decode(str));

String dataJsonModelToJson(DataJsonModel data) => json.encode(data.toJson());

class DataJsonModel {
  DataJsonModel({
    this.statusCode,
    this.statusMessage,
    this.resultObject,
  });

  int statusCode;
  String statusMessage;
  List<ResultObject> resultObject;

  factory DataJsonModel.fromJson(Map<String, dynamic> json) => DataJsonModel(
    statusCode: json["statusCode"],
    statusMessage: json["statusMessage"],
    resultObject: List<ResultObject>.from(json["resultObject"].map((x) => ResultObject.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "statusCode": statusCode,
    "statusMessage": statusMessage,
    "resultObject": List<dynamic>.from(resultObject.map((x) => x.toJson())),
  };
}

class ResultObject {
  ResultObject({
    this.transactiondtl,
    this.reportformatdtl,
  });

  List<ResultObjectTransactiondtl> transactiondtl;
  List<Reportformatdtl> reportformatdtl;

  factory ResultObject.fromJson(Map<String, dynamic> json) => ResultObject(
    transactiondtl: List<ResultObjectTransactiondtl>.from(json["transactiondtl"].map((x) => ResultObjectTransactiondtl.fromJson(x))),
    reportformatdtl: List<Reportformatdtl>.from(json["reportformatdtl"].map((x) => Reportformatdtl.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "transactiondtl": List<dynamic>.from(transactiondtl.map((x) => x.toJson())),
    "reportformatdtl": List<dynamic>.from(reportformatdtl.map((x) => x.toJson())),
  };
}

class Reportformatdtl {
  Reportformatdtl({
    this.id,
    this.tableid,
    this.optionid,
    this.formatcode,
    this.formatname,
    this.reportengineid,
    this.isdrilldownyn,
    this.parentformatid,
    this.procedurename,
    this.actionflg,
    this.subflag,
    this.dtl,
  });

  int id;
  int tableid;
  int optionid;
  String formatcode;
  String formatname;
  int reportengineid;
  String isdrilldownyn;
  dynamic parentformatid;
  String procedurename;
  String actionflg;
  String subflag;
  List<Dtl> dtl;

  factory Reportformatdtl.fromJson(Map<String, dynamic> json) => Reportformatdtl(
    id: json["id"],
    tableid: json["tableid"],
    optionid: json["optionid"],
    formatcode: json["formatcode"],
    formatname: json["formatname"],
    reportengineid: json["reportengineid"],
    isdrilldownyn: json["isdrilldownyn"],
    parentformatid: json["parentformatid"],
    procedurename: json["procedurename"],
    actionflg: json["actionflg"],
    subflag: json["subflag"],
    dtl: List<Dtl>.from(json["dtl"].map((x) => Dtl.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tableid": tableid,
    "optionid": optionid,
    "formatcode": formatcode,
    "formatname": formatname,
    "reportengineid": reportengineid,
    "isdrilldownyn": isdrilldownyn,
    "parentformatid": parentformatid,
    "procedurename": procedurename,
    "actionflg": actionflg,
    "subflag": subflag,
    "dtl": List<dynamic>.from(dtl.map((x) => x.toJson())),
  };
}

class Dtl {
  Dtl({
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

  factory Dtl.fromJson(Map<String, dynamic> json) => Dtl(
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
  };
}

class ResultObjectTransactiondtl {
  ResultObjectTransactiondtl({
    this.transactiondtl,
    this.documentconfigdtl,
    this.alertconfigdtl,
    this.tablename,
    this.optionid,
    this.defaultpanelname,
    this.userid,
    this.transactiondtltablename,
  });

  List<TransactiondtlTransactiondtl> transactiondtl;
  List<Documentconfigdtl> documentconfigdtl;
  List<Alertconfigdtl> alertconfigdtl;
  String tablename;
  int optionid;
  String defaultpanelname;
  int userid;
  String transactiondtltablename;

  factory ResultObjectTransactiondtl.fromJson(Map<String, dynamic> json) => ResultObjectTransactiondtl(
    transactiondtl: List<TransactiondtlTransactiondtl>.from(json["transactiondtl"].map((x) => TransactiondtlTransactiondtl.fromJson(x))),
    documentconfigdtl: List<Documentconfigdtl>.from(json["documentconfigdtl"].map((x) => Documentconfigdtl.fromJson(x))),
    alertconfigdtl: List<Alertconfigdtl>.from(json["alertconfigdtl"].map((x) => Alertconfigdtl.fromJson(x))),
    tablename: json["tablename"],
    optionid: json["optionid"],
    defaultpanelname: json["defaultpanelname"],
    userid: json["userid"],
    transactiondtltablename: json["transactiondtltablename"],
  );

  Map<String, dynamic> toJson() => {
    "transactiondtl": List<dynamic>.from(transactiondtl.map((x) => x.toJson())),
    "documentconfigdtl": List<dynamic>.from(documentconfigdtl.map((x) => x.toJson())),
    "alertconfigdtl": List<dynamic>.from(alertconfigdtl.map((x) => x.toJson())),
    "tablename": tablename,
    "optionid": optionid,
    "defaultpanelname": defaultpanelname,
    "userid": userid,
    "transactiondtltablename": transactiondtltablename,
  };
}

class Alertconfigdtl {
  Alertconfigdtl({
    this.id,
    this.tableid,
    this.optionid,
    this.parenttableid,
    this.parenttabledataid,
    this.emailprovisionrequireyn,
    this.smsprovisionrequireyn,
    this.emailto,
    this.emailcc,
    this.emailbcc,
    this.emailsubject,
    this.emailbody,
    this.attachment,
    this.smscontent,
    this.reftableid,
    this.lastmoduserid,
    this.lastmoddate,
  });

  int id;
  int tableid;
  int optionid;
  int parenttableid;
  int parenttabledataid;
  String emailprovisionrequireyn;
  String smsprovisionrequireyn;
  dynamic emailto;
  dynamic emailcc;
  dynamic emailbcc;
  dynamic emailsubject;
  String emailbody;
  dynamic attachment;
  String smscontent;
  int reftableid;
  int lastmoduserid;
  String lastmoddate;

  factory Alertconfigdtl.fromJson(Map<String, dynamic> json) => Alertconfigdtl(
    id: json["id"],
    tableid: json["tableid"],
    optionid: json["optionid"],
    parenttableid: json["parenttableid"],
    parenttabledataid: json["parenttabledataid"],
    emailprovisionrequireyn: json["emailprovisionrequireyn"],
    smsprovisionrequireyn: json["smsprovisionrequireyn"],
    emailto: json["emailto"],
    emailcc: json["emailcc"],
    emailbcc: json["emailbcc"],
    emailsubject: json["emailsubject"],
    emailbody: json["emailbody"],
    attachment: json["attachment"],
    smscontent: json["smscontent"],
    reftableid: json["reftableid"],
    lastmoduserid: json["lastmoduserid"],
    lastmoddate: json["lastmoddate"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tableid": tableid,
    "optionid": optionid,
    "parenttableid": parenttableid,
    "parenttabledataid": parenttabledataid,
    "emailprovisionrequireyn": emailprovisionrequireyn,
    "smsprovisionrequireyn": smsprovisionrequireyn,
    "emailto": emailto,
    "emailcc": emailcc,
    "emailbcc": emailbcc,
    "emailsubject": emailsubject,
    "emailbody": emailbody,
    "attachment": attachment,
    "smscontent": smscontent,
    "reftableid": reftableid,
    "lastmoduserid": lastmoduserid,
    "lastmoddate": lastmoddate,
  };
}

class Documentconfigdtl {
  Documentconfigdtl({
    this.id,
    this.tableid,
    this.optionid,
    this.parenttableid,
    this.parenttabledataid,
    this.approvalrejectionbccid,
    this.levelnobccid,
    this.assignedRoles,
    this.assignedUsers,
    this.minpersontoapprove,
    this.amountragefrom,
    this.amountrageto,
    this.iscommentmandatoryyn,
    this.lastmoduserid,
    this.lastmoddate,
    this.levelname,
    this.departmentapprovalyn,
    this.isamountbasedapprovalyn,
    this.iscentralizedapprovalyn,
  });

  int id;
  int tableid;
  int optionid;
  int parenttableid;
  int parenttabledataid;
  int approvalrejectionbccid;
  int levelnobccid;
  List<Assigned> assignedRoles;
  List<Assigned> assignedUsers;
  int minpersontoapprove;
  int amountragefrom;
  int amountrageto;
  String iscommentmandatoryyn;
  int lastmoduserid;
  String lastmoddate;
  String levelname;
  String departmentapprovalyn;
  String isamountbasedapprovalyn;
  String iscentralizedapprovalyn;

  factory Documentconfigdtl.fromJson(Map<String, dynamic> json) => Documentconfigdtl(
    id: json["id"],
    tableid: json["tableid"],
    optionid: json["optionid"],
    parenttableid: json["parenttableid"],
    parenttabledataid: json["parenttabledataid"],
    approvalrejectionbccid: json["approvalrejectionbccid"],
    levelnobccid: json["levelnobccid"],
    assignedRoles: List<Assigned>.from(json["assigned_roles"].map((x) => Assigned.fromJson(x))),
    assignedUsers: List<Assigned>.from(json["assigned_users"].map((x) => Assigned.fromJson(x))),
    minpersontoapprove: json["minpersontoapprove"],
    amountragefrom: json["amountragefrom"],
    amountrageto: json["amountrageto"],
    iscommentmandatoryyn: json["iscommentmandatoryyn"],
    lastmoduserid: json["lastmoduserid"],
    lastmoddate: json["lastmoddate"],
    levelname: json["levelname"],
    departmentapprovalyn: json["departmentapprovalyn"],
    isamountbasedapprovalyn: json["isamountbasedapprovalyn"],
    iscentralizedapprovalyn: json["iscentralizedapprovalyn"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tableid": tableid,
    "optionid": optionid,
    "parenttableid": parenttableid,
    "parenttabledataid": parenttabledataid,
    "approvalrejectionbccid": approvalrejectionbccid,
    "levelnobccid": levelnobccid,
    "assigned_roles": List<dynamic>.from(assignedRoles.map((x) => x.toJson())),
    "assigned_users": List<dynamic>.from(assignedUsers.map((x) => x.toJson())),
    "minpersontoapprove": minpersontoapprove,
    "amountragefrom": amountragefrom,
    "amountrageto": amountrageto,
    "iscommentmandatoryyn": iscommentmandatoryyn,
    "lastmoduserid": lastmoduserid,
    "lastmoddate": lastmoddate,
    "levelname": levelname,
    "departmentapprovalyn": departmentapprovalyn,
    "isamountbasedapprovalyn": isamountbasedapprovalyn,
    "iscentralizedapprovalyn": iscentralizedapprovalyn,
  };
}

class Assigned {
  Assigned({
    this.id,
    this.code,
    this.name,
  });

  int id;
  String code;
  String name;

  factory Assigned.fromJson(Map<String, dynamic> json) => Assigned(
    id: json["id"],
    code: json["code"],
    name: json["name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "name": name,
  };
}

class TransactiondtlTransactiondtl {
  TransactiondtlTransactiondtl({
    this.slno,
    this.reftabledataid,
    this.reftableid,
    this.transno,
    this.transdate,
    this.optionid,
    this.optionname,
    this.emailto,
    this.leveltypebccid,
    this.currentlevel,
    this.currapprovedno,
    this.maxlevelid,
    this.maxlevel,
    this.reference,
    this.translastmoddate,
    this.narration,
    this.refno,
    this.refdate,
    this.branchname,
    this.preparedbyid,
    this.preparedby,
    this.prepareddate,
    this.totalvalue,
    this.totaldisc,
    this.grosstotal,
    this.totaltax,
    this.nettotal,
    this.discaftertax,
    this.roundoff,
    this.totalinvoicevalue,
    this.dtltablereqyn,
    this.historydtl,
    this.docattachreqyn,
    this.doccount,
    this.start,
    this.limit,
    this.totalrecords,
  });

  int slno;
  int reftabledataid;
  int reftableid;
  String transno;
  String transdate;
  int optionid;
  String optionname;
  dynamic emailto;
  int leveltypebccid;
  String currentlevel;
  int currapprovedno;
  int maxlevelid;
  String maxlevel;
  String reference;
  String translastmoddate;
  String narration;
  dynamic refno;
  dynamic refdate;
  String branchname;
  int preparedbyid;
  String preparedby;
  String prepareddate;
  int totalvalue;
  dynamic totaldisc;
  dynamic grosstotal;
  dynamic totaltax;
  dynamic nettotal;
  dynamic discaftertax;
  dynamic roundoff;
  dynamic totalinvoicevalue;
  String dtltablereqyn;
  dynamic historydtl;
  dynamic docattachreqyn;
  dynamic doccount;
  int start;
  int limit;
  int totalrecords;

  factory TransactiondtlTransactiondtl.fromJson(Map<String, dynamic> json) => TransactiondtlTransactiondtl(
    slno: json["slno"],
    reftabledataid: json["reftabledataid"],
    reftableid: json["reftableid"],
    transno: json["transno"],
    transdate: json["transdate"],
    optionid: json["optionid"],
    optionname: json["optionname"],
    emailto: json["emailto"],
    leveltypebccid: json["leveltypebccid"],
    currentlevel: json["currentlevel"],
    currapprovedno: json["currapprovedno"],
    maxlevelid: json["maxlevelid"],
    maxlevel: json["maxlevel"],
    reference: json["reference"],
    translastmoddate: json["translastmoddate"],
    narration: json["narration"],
    refno: json["refno"],
    refdate: json["refdate"],
    branchname: json["branchname"],
    preparedbyid: json["preparedbyid"],
    preparedby: json["preparedby"],
    prepareddate: json["prepareddate"],
    totalvalue: json["totalvalue"],
    totaldisc: json["totaldisc"],
    grosstotal: json["grosstotal"],
    totaltax: json["totaltax"],
    nettotal: json["nettotal"],
    discaftertax: json["discaftertax"],
    roundoff: json["roundoff"],
    totalinvoicevalue: json["totalinvoicevalue"],
    dtltablereqyn: json["dtltablereqyn"],
    historydtl: json["historydtl"],
    docattachreqyn: json["docattachreqyn"],
    doccount: json["doccount"],
    start: json["start"],
    limit: json["limit"],
    totalrecords: json["totalrecords"],
  );

  Map<String, dynamic> toJson() => {
    "slno": slno,
    "reftabledataid": reftabledataid,
    "reftableid": reftableid,
    "transno": transno,
    "transdate": transdate,
    "optionid": optionid,
    "optionname": optionname,
    "emailto": emailto,
    "leveltypebccid": leveltypebccid,
    "currentlevel": currentlevel,
    "currapprovedno": currapprovedno,
    "maxlevelid": maxlevelid,
    "maxlevel": maxlevel,
    "reference": reference,
    "translastmoddate": translastmoddate,
    "narration": narration,
    "refno": refno,
    "refdate": refdate,
    "branchname": branchname,
    "preparedbyid": preparedbyid,
    "preparedby": preparedby,
    "prepareddate": prepareddate,
    "totalvalue": totalvalue,
    "totaldisc": totaldisc,
    "grosstotal": grosstotal,
    "totaltax": totaltax,
    "nettotal": nettotal,
    "discaftertax": discaftertax,
    "roundoff": roundoff,
    "totalinvoicevalue": totalinvoicevalue,
    "dtltablereqyn": dtltablereqyn,
    "historydtl": historydtl,
    "docattachreqyn": docattachreqyn,
    "doccount": doccount,
    "start": start,
    "limit": limit,
    "totalrecords": totalrecords,
  };
}
