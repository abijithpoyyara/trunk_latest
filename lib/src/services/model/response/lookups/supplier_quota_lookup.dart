import 'package:base/services.dart';

import '../../../../../utility.dart';

class SupplierQuotaModel extends LookupModel {
  SupplierQuotaModel.fromJson(Map<String, dynamic> parsedJson)
      : super.fromJson(parsedJson) {
    if (parsedJson["resultObject"] != null) {
      lookupItems = new List<SupplierQuotaItem>();
      parsedJson['resultObject'].forEach((mod) {
        lookupItems.add(new SupplierQuotaItem.fromJson(mod));
      });
    } else {
      lookupItems = List<SupplierQuotaItem>();
    }
  }
}

class SupplierQuotaItem extends LookupItems {
  int Id;
  int LastModUserId;
  int approvedby;
  int createduserid;
  int optionid;
  int supplierregtypebccid;
  int tableid;
  String SerialNoCol;
  String TransDateCol;
  String approveddate;
  String code;
  String createddate;
  String docAttachXml;
  String docapprvlstatus;
  String isactive;
  String isblockedyn;
  String name;
  String tdsapplicableyn;
  bool docAttachReqYN;
  List addressDtl;
  List extraFldDataObj;
  List<SupplierCurrencyMappingdtlList> supplierCurrencyMappingdtlList;
  List<ContactDtlList> contactDtlList;
  List<ExtensionDataObj> extensionDataObj;
  List<SupplierTypeMappingList> supplierTypeMappingList;
  SupplierQuotaItem({this.name,this.Id});

  SupplierQuotaItem.fromJson(Map<String, dynamic> json) : super.fromJson(json) {
    Id = BaseJsonParser.goodInt(json, "Id");
    LastModUserId = BaseJsonParser.goodInt(json, "LastModUserId");
    approvedby = BaseJsonParser.goodInt(json, "approvedby");
    createduserid = BaseJsonParser.goodInt(json, "createduserid");
    optionid = BaseJsonParser.goodInt(json, "optionid");
    supplierregtypebccid = BaseJsonParser.goodInt(json, "supplierregtypebccid");
    tableid = BaseJsonParser.goodInt(json, "tableid");
    SerialNoCol = BaseJsonParser.goodString(json, "SerialNoCol");
    TransDateCol = BaseJsonParser.goodString(json, "TransDateCol");
    approveddate = BaseJsonParser.goodString(json, "approveddate");
    code = BaseJsonParser.goodString(json, "code");
    createddate = BaseJsonParser.goodString(json, "createddate");
    docAttachXml = BaseJsonParser.goodString(json, "docAttachXml");
    docapprvlstatus = BaseJsonParser.goodString(json, "docapprvlstatus");
    isactive = BaseJsonParser.goodString(json, "isactive");
    isblockedyn = BaseJsonParser.goodString(json, "isblockedyn");
    name = BaseJsonParser.goodString(json, "name");
    tdsapplicableyn = BaseJsonParser.goodString(json, "tdsapplicableyn");
    docAttachReqYN = BaseJsonParser.goodBoolean(json, "docAttachReqYN");

    supplierCurrencyMappingdtlList = BaseJsonParser.goodList(json, "supplierCurrencyMappingdtlList")
        .map((e) => SupplierCurrencyMappingdtlList.fromJson(e))
        .toList();
    contactDtlList = BaseJsonParser.goodList(json, "contactDtlList")
        .map((e) => ContactDtlList.fromJson(e))
        .toList();
    extensionDataObj = BaseJsonParser.goodList(json, "extensionDataObj")
        .map((e) => ExtensionDataObj.fromJson(e))
        .toList();
    supplierTypeMappingList = BaseJsonParser.goodList(json, "supplierTypeMappingList")
        .map((e) => SupplierTypeMappingList.fromJson(e))
        .toList();
  }
}

class SupplierCurrencyMappingdtlList {
  int Id;
  int LastModUserId;
  int currencyid;
  int parenttabledataid;
  int parenttableid;
  int tableid;
  String SerialNoCol;
  String TransDateCol;
  String docAttachXml;
  bool docAttachReqYN;
  SupplierCurrencyMappingdtlList.fromJson(Map<String, dynamic> json) { {
    Id = BaseJsonParser.goodInt(json, "Id");
    LastModUserId = BaseJsonParser.goodInt(json, "LastModUserId");
    currencyid = BaseJsonParser.goodInt(json, "currencyid");
    parenttabledataid = BaseJsonParser.goodInt(json, "parenttabledataid");
    parenttableid = BaseJsonParser.goodInt(json, "parenttableid");
    tableid = BaseJsonParser.goodInt(json, "tableid");
    SerialNoCol = BaseJsonParser.goodString(json, "SerialNoCol");
    TransDateCol = BaseJsonParser.goodString(json, "TransDateCol");
    docAttachXml = BaseJsonParser.goodString(json, "docAttachXml");
    docAttachReqYN = BaseJsonParser.goodBoolean(json, "docAttachReqYN");
  }
  }
}

class ContactDtlList{
  int Id;
  int LastModUserId;
  int parenttabledataid;
  int parenttableid;
  int tableid;
  String SerialNoCol;
  String TransDateCol;
  String branchname;
  String docAttachXml;
  String ishobranchyn;
  bool docAttachReqYN;
  List extensionDataObj;
  List extraFldDataObj;
  List<AddressDtl> addressDtl;
  ContactDtlList.fromJson(Map<String, dynamic> json) { {
    Id = BaseJsonParser.goodInt(json, "Id");
    LastModUserId = BaseJsonParser.goodInt(json, "LastModUserId");
    parenttabledataid = BaseJsonParser.goodInt(json, "parenttabledataid");
    parenttableid = BaseJsonParser.goodInt(json, "parenttableid");
    tableid = BaseJsonParser.goodInt(json, "tableid");
    SerialNoCol = BaseJsonParser.goodString(json, "SerialNoCol");
    TransDateCol = BaseJsonParser.goodString(json, "TransDateCol");
    branchname = BaseJsonParser.goodString(json, "branchname");
    docAttachXml = BaseJsonParser.goodString(json, "docAttachXml");
    ishobranchyn = BaseJsonParser.goodString(json, "ishobranchyn");
    docAttachReqYN = BaseJsonParser.goodBoolean(json, "docAttachReqYN");
    addressDtl = BaseJsonParser.goodList(json, "addressDtl")
        .map((e) => AddressDtl.fromJson(e))
        .toList();
  }
  }
}

class AddressDtl{
 int Id;
 int LastModUserId;
 int addressid;
 int areaid;
 int countryid;
 int optionid;
 int reftabledataid;
 int reftableid;
 int stateid;
 int tableid;
 String SerialNoCol;
 String TransDateCol;
 String address1;
 String address2;
 String address3;
 String docAttachXml;
 bool docAttachReqYN;
 List<DtoList> dtoList;
 AddressDtl.fromJson(Map<String, dynamic> json) { {
   Id = BaseJsonParser.goodInt(json, "Id");
   LastModUserId = BaseJsonParser.goodInt(json, "LastModUserId");
   addressid = BaseJsonParser.goodInt(json, "addressid");
   areaid = BaseJsonParser.goodInt(json, "areaid");
   countryid = BaseJsonParser.goodInt(json, "countryid");
   optionid = BaseJsonParser.goodInt(json, "optionid");
   reftabledataid = BaseJsonParser.goodInt(json, "reftabledataid");
   stateid = BaseJsonParser.goodInt(json, "stateid");
   tableid = BaseJsonParser.goodInt(json, "tableid");
   SerialNoCol = BaseJsonParser.goodString(json, "SerialNoCol");
   TransDateCol = BaseJsonParser.goodString(json, "TransDateCol");
   address1 = BaseJsonParser.goodString(json, "address1");
   address2 = BaseJsonParser.goodString(json, "address2");
   address3 = BaseJsonParser.goodString(json, "address3");
   docAttachXml = BaseJsonParser.goodString(json, "docAttachXml");
   dtoList = BaseJsonParser.goodList(json, "dtoList")
       .map((e) => DtoList.fromJson(e))
       .toList();
 }}
}

class DtoList{
  int Id;
  int LastModUserId;
  int adddtlid;
  int communicationtypebccid;
  int optionid;
  int parenttabledataid;
  int parenttableid;
  int tableid;
  String SerialNoCol;
  String TransDateCol;
  String communicationno;
  String docAttachXml;
  String remarks;
  bool docAttachReqYN;
  DtoList.fromJson(Map<String, dynamic> json) { {
    Id = BaseJsonParser.goodInt(json, "Id");
    LastModUserId = BaseJsonParser.goodInt(json, "LastModUserId");
    adddtlid = BaseJsonParser.goodInt(json, "adddtlid");
    communicationtypebccid = BaseJsonParser.goodInt(json, "communicationtypebccid");
    optionid = BaseJsonParser.goodInt(json, "optionid");
    parenttabledataid = BaseJsonParser.goodInt(json, "parenttabledataid");
    parenttableid = BaseJsonParser.goodInt(json, "parenttableid");
    tableid = BaseJsonParser.goodInt(json, "tableid");
    SerialNoCol = BaseJsonParser.goodString(json, "SerialNoCol");
    TransDateCol = BaseJsonParser.goodString(json, "TransDateCol");
    communicationno = BaseJsonParser.goodString(json, "communicationno");
    docAttachXml = BaseJsonParser.goodString(json, "docAttachXml");
    remarks = BaseJsonParser.goodString(json, "remarks");
    docAttachReqYN = BaseJsonParser.goodBoolean(json, "docAttachReqYN");
  }
  }
}

class ExtensionDataObj {
  int Id;
  int LastModUserId;
  int companyid;
  int optionid;
  int parenttabledataid;
  int parenttableid;
  int tableid;
  String SerialNoCol;
  String docAttachXml;
  String fieldvalue;
  String TransDateCol;
  bool docAttachReqYN;

  ExtensionDataObj.fromJson(Map<String, dynamic> json) {
    {
      Id = BaseJsonParser.goodInt(json, "Id");
      LastModUserId = BaseJsonParser.goodInt(json, "LastModUserId");
      companyid = BaseJsonParser.goodInt(json, "companyid");
      optionid = BaseJsonParser.goodInt(json, "optionid");
      parenttabledataid = BaseJsonParser.goodInt(json, "parenttabledataid");
      parenttableid = BaseJsonParser.goodInt(json, "parenttableid");
      tableid = BaseJsonParser.goodInt(json, "tableid");
      tableid = BaseJsonParser.goodInt(json, "tableid");
      SerialNoCol = BaseJsonParser.goodString(json, "SerialNoCol");
      TransDateCol = BaseJsonParser.goodString(json, "TransDateCol");
      fieldvalue = BaseJsonParser.goodString(json, "fieldvalue");
      docAttachXml = BaseJsonParser.goodString(json, "docAttachXml");
      TransDateCol = BaseJsonParser.goodString(json, "TransDateCol");
      docAttachReqYN = BaseJsonParser.goodBoolean(json, "docAttachReqYN");
    }
  }
}

class SupplierTypeMappingList {
  int Id;
  int LastModUserId;
  int tableid;
  int typebccid;
  String SerialNoCol;
  String TransDateCol;
  String docAttachXml;
  bool docAttachReqYN;
  List addressDtl;
  List extensionDataObj;
  List extraFldDataObj;

  SupplierTypeMappingList.fromJson(Map<String, dynamic> json) {
    {
      Id = BaseJsonParser.goodInt(json, "Id");
      LastModUserId = BaseJsonParser.goodInt(json, "LastModUserId");
      tableid = BaseJsonParser.goodInt(json, "tableid");
      typebccid = BaseJsonParser.goodInt(json, "typebccid");
      SerialNoCol = BaseJsonParser.goodString(json, "SerialNoCol");
      TransDateCol = BaseJsonParser.goodString(json, "TransDateCol");
      docAttachXml = BaseJsonParser.goodString(json, "docAttachXml");
      docAttachReqYN = BaseJsonParser.goodBoolean(json, "docAttachReqYN");
    }
  }
}

