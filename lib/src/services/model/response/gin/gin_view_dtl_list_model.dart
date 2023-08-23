import 'package:base/services.dart';
import 'package:redstars/src/services/model/response/gin/gin_sourcemapping_dtl_model.dart';

import '../../../../../utility.dart';

class GINViewDetailModel extends BaseResponseModel {
  List<GINViewDetailList> dtlList;

  GINViewDetailModel.fromJson(Map<String, dynamic> json)
      : super.fromJson(json) {
    dtlList = BaseJsonParser.goodList(json, "resultObject")
        .map((e) => GINViewDetailList.fromJson(e))
        .toList();
  }
}

class GINViewDetailList {
  int optionid;
  int tableid;
  int transactionuniqueid;
  String amendmentno;
  String amendmentdate;
  int amendedfromoptionid;
  int companyid;
  int branchid;
  int finyearid;
  String grnno;
  String grndate;
  int supplierid;
  String supllierinvno;
  String supllierinvdate;
  String interstateyn;
  int statusbccid;
  String statuswefdate;
  String systemgenyn;
  String futuredatedtransyn;
  int lastmoduserid;
  String lastmoddate;
  String recordstatus;
  String supplier;
  String grnaddress1;
  String grnaddress2;
  String grnaddress3;
  String location;
  String leadtime;
  String creditperiod;
  String creditlimit;
  String transactiondate;
  String processfrom;
  int supplierinvoicetotaltax;
  int supplierinvoicetotalafterroundoff;
  int hdrfccurrencyid;
  int fccurrencyid;
  String fccurrencycode;
  int lccurrencyid;
  String lccurrencycode;
  int exchrate;
  int createduserid;
  String createdusername;
  String createddate;
  String paymentmode;
  String isblockedyn;
  int businesslevelcodeid;
  int blreftableid;
  int blreftabledataid;
  int Id;
  List<GINDetailDtlList> ginDetailDtlList;
  GINViewDetailList.fromJson(Map parsedJson) {
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    transactionuniqueid =
        BaseJsonParser.goodInt(parsedJson, "transactionuniqueid");
    amendmentno = BaseJsonParser.goodString(parsedJson, "amendmentno");
    amendmentdate = BaseJsonParser.goodString(parsedJson, "amendmentdate");
    amendedfromoptionid =
        BaseJsonParser.goodInt(parsedJson, "amendedfromoptionid");
    companyid = BaseJsonParser.goodInt(parsedJson, "companyid");
    branchid = BaseJsonParser.goodInt(parsedJson, "branchid");
    finyearid = BaseJsonParser.goodInt(parsedJson, "finyearid");
    grnno = BaseJsonParser.goodString(parsedJson, "grnno");
    grndate = BaseJsonParser.goodString(parsedJson, "grndate");
    supplierid = BaseJsonParser.goodInt(parsedJson, "supplierid");
    supllierinvno = BaseJsonParser.goodString(parsedJson, "supllierinvno");
    supllierinvdate = BaseJsonParser.goodString(parsedJson, "supllierinvdate");
    interstateyn = BaseJsonParser.goodString(parsedJson, "interstateyn");
    statusbccid = BaseJsonParser.goodInt(parsedJson, "statusbccid");
    statuswefdate = BaseJsonParser.goodString(parsedJson, "statuswefdate");
    systemgenyn = BaseJsonParser.goodString(parsedJson, "systemgenyn");
    futuredatedtransyn =
        BaseJsonParser.goodString(parsedJson, "futuredatedtransyn");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    recordstatus = BaseJsonParser.goodString(parsedJson, "recordstatus");
    supplier = BaseJsonParser.goodString(parsedJson, "supplier");
    grnaddress1 = BaseJsonParser.goodString(parsedJson, "grnaddress1");
    grnaddress2 = BaseJsonParser.goodString(parsedJson, "grnaddress2");
    grnaddress3 = BaseJsonParser.goodString(parsedJson, "grnaddress3");
    location = BaseJsonParser.goodString(parsedJson, "location");
    leadtime = BaseJsonParser.goodString(parsedJson, "leadtime");
    creditperiod = BaseJsonParser.goodString(parsedJson, "creditperiod");
    creditlimit = BaseJsonParser.goodString(parsedJson, "creditlimit");
    transactiondate = BaseJsonParser.goodString(parsedJson, "transactiondate");
    processfrom = BaseJsonParser.goodString(parsedJson, "processfrom");
    supplierinvoicetotaltax =
        BaseJsonParser.goodInt(parsedJson, "supplierinvoicetotaltax");
    supplierinvoicetotalafterroundoff =
        BaseJsonParser.goodInt(parsedJson, "supplierinvoicetotalafterroundoff");
    hdrfccurrencyid = BaseJsonParser.goodInt(parsedJson, "hdrfccurrencyid");
    fccurrencyid = BaseJsonParser.goodInt(parsedJson, "fccurrencyid");
    fccurrencycode = BaseJsonParser.goodString(parsedJson, "fccurrencycode");
    lccurrencyid = BaseJsonParser.goodInt(parsedJson, "lccurrencyid");
    lccurrencycode = BaseJsonParser.goodString(parsedJson, "lccurrencycode");
    exchrate = BaseJsonParser.goodInt(parsedJson, "exchrate");
    createduserid = BaseJsonParser.goodInt(parsedJson, "createduserid");
    createdusername = BaseJsonParser.goodString(parsedJson, "createdusername");
    createddate = BaseJsonParser.goodString(parsedJson, "createddate");
    paymentmode = BaseJsonParser.goodString(parsedJson, "paymentmode");
    isblockedyn = BaseJsonParser.goodString(parsedJson, "isblockedyn");
    businesslevelcodeid =
        BaseJsonParser.goodInt(parsedJson, "businesslevelcodeid");
    blreftableid = BaseJsonParser.goodInt(parsedJson, "blreftableid");
    blreftabledataid = BaseJsonParser.goodInt(parsedJson, "blreftabledataid");
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
    ginDetailDtlList = BaseJsonParser.goodList(parsedJson, "detailsdtllist")
        .map((e) => GINDetailDtlList.fromJson(e))
        .toList();
  }
}

class GINUomDtl {
  int itemid;
  String itemname;
  int uomid;
  String uomname;
  int uomtypebccid;
  int qty;
  String defaultuomyn;
  int uomtypesortorder;
  String uomvalue;
  int Id;
  GINUomDtl.fromJson(Map parsedJson) {
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    itemname = BaseJsonParser.goodString(parsedJson, "itemname");
    uomid = BaseJsonParser.goodInt(parsedJson, "uomid");
    uomname = BaseJsonParser.goodString(parsedJson, "uomname");
    uomtypebccid = BaseJsonParser.goodInt(parsedJson, "uomtypebccid");
    qty = BaseJsonParser.goodInt(parsedJson, "qty");
    defaultuomyn = BaseJsonParser.goodString(parsedJson, "defaultuomyn");
    uomtypesortorder = BaseJsonParser.goodInt(parsedJson, "uomtypesortorder");
    uomvalue = BaseJsonParser.goodString(parsedJson, "uomvalue");
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
  }
}

class GINBatchDtl {
  int itemid;
  int itembatchid;
  String batchcode;
  String batchdescription;
  int mrp;
  int bookstockqty;
  int physicalstockqty;
  GINBatchDtl.fromJson(Map parsedJson) {
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    itembatchid = BaseJsonParser.goodInt(parsedJson, "itembatchid");
    batchcode = BaseJsonParser.goodString(parsedJson, "batchcode");
    batchdescription =
        BaseJsonParser.goodString(parsedJson, "batchdescription");
    mrp = BaseJsonParser.goodInt(parsedJson, "mrp");
    bookstockqty = BaseJsonParser.goodInt(parsedJson, "bookstockqty");
    physicalstockqty = BaseJsonParser.goodInt(parsedJson, "physicalstockqty");
  }
}

class GINSrcMapDtl {
  int grndtlid;
  int grndtltableid;
  int optionid;
  int tableid;
  int parenttableid;
  int parenttabledataid;
  int reftableid;
  int reftabledataid;
  int generateduomid;
  int generateduomtypebccid;
  int generatedqty;
  int lastmoduserid;
  String lastmoddate;
  int refhdrtableid;
  int refhdrtabledataid;
  String transactiondate;
  int Id;
  GINSrcMapDtl.fromJson(Map parsedJson) {
    grndtlid = BaseJsonParser.goodInt(parsedJson, "grndtlid");
    grndtltableid = BaseJsonParser.goodInt(parsedJson, "grndtltableid");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    parenttableid = BaseJsonParser.goodInt(parsedJson, "parenttableid");
    parenttabledataid = BaseJsonParser.goodInt(parsedJson, "parenttabledataid");
    reftableid = BaseJsonParser.goodInt(parsedJson, "reftableid");
    reftabledataid = BaseJsonParser.goodInt(parsedJson, "reftabledataid");
    generateduomid = BaseJsonParser.goodInt(parsedJson, "generateduomid");
    generateduomtypebccid =
        BaseJsonParser.goodInt(parsedJson, "generateduomtypebccid");
    generatedqty = BaseJsonParser.goodInt(parsedJson, "generatedqty");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    refhdrtableid = BaseJsonParser.goodInt(parsedJson, "refhdrtableid");
    refhdrtabledataid = BaseJsonParser.goodInt(parsedJson, "refhdrtabledataid");
    transactiondate = BaseJsonParser.goodString(parsedJson, "transactiondate");
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
  }
}

class GINItemWiseQtyDtl {
  int id;
  int tableid;
  int optionid;
  int parenttableid;
  int parenttabledataid;
  int uomtypebccid;
  int uomid;
  int qty;
  String uomname;
  String code;
  GINItemWiseQtyDtl({this.id, this.uomtypebccid});
  GINItemWiseQtyDtl.fromJson(Map parsedJson) {
    id = BaseJsonParser.goodInt(parsedJson, "id");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    parenttableid = BaseJsonParser.goodInt(parsedJson, "parenttableid");
    parenttabledataid = BaseJsonParser.goodInt(parsedJson, "parenttabledataid");
    uomtypebccid = BaseJsonParser.goodInt(parsedJson, "uomtypebccid");
    uomid = BaseJsonParser.goodInt(parsedJson, "uomid");
    qty = BaseJsonParser.goodInt(parsedJson, "qty");
    uomname = BaseJsonParser.goodString(parsedJson, "uomname");
    code = BaseJsonParser.goodString(parsedJson, "code");
  }
}

class GINItemRateDtl {
  int itemid;
  String itemname;
  int uomid;
  String uomname;
  int uomtypebccid;
  int qty;
  String defaultuomyn;
  int uomtypesortorder;
  String uomvalue;
  int Id;
  GINItemRateDtl.fromJson(Map parsedJson) {
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    itemname = BaseJsonParser.goodString(parsedJson, "itemname");
    uomid = BaseJsonParser.goodInt(parsedJson, "uomid");
    uomname = BaseJsonParser.goodString(parsedJson, "uomname");
    uomtypebccid = BaseJsonParser.goodInt(parsedJson, "uomtypebccid");
    qty = BaseJsonParser.goodInt(parsedJson, "qty");
    defaultuomyn = BaseJsonParser.goodString(parsedJson, "defaultuomyn");
    uomtypesortorder = BaseJsonParser.goodInt(parsedJson, "uomtypesortorder");
    uomvalue = BaseJsonParser.goodString(parsedJson, "uomvalue");
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
  }
}

class GINDiscDataDtl {
  int itemid;
  String itemname;
  int uomid;
  String uomname;
  int attachmentid;
  String attachmentdescription;
  int attachmentsortorder;
  String discapplicableyn;
  GINDiscDataDtl.fromJson(Map parsedJson) {
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    itemname = BaseJsonParser.goodString(parsedJson, "itemname");
    uomid = BaseJsonParser.goodInt(parsedJson, "uomid");
    uomname = BaseJsonParser.goodString(parsedJson, "uomname");
    attachmentid = BaseJsonParser.goodInt(parsedJson, "attachmentid");
    attachmentdescription =
        BaseJsonParser.goodString(parsedJson, "attachmentdescription");
    attachmentsortorder =
        BaseJsonParser.goodInt(parsedJson, "attachmentsortorder");
    discapplicableyn =
        BaseJsonParser.goodString(parsedJson, "discapplicableyn");
  }
}

class GINDetailDtlList {
  int optionid;
  int tableid;
  int parenttableid;
  int parenttabledataid;
  int itemid;
  int uomtypebccid;
  int uomid;
  double qty;
  double rate;
  int totalvalue;
  int totaldiscamout;
  int subtotal;
  int taxamount;
  int nettotal;
  int discamountaftertax;
  int othercharges;
  int freightcharges;
  int grosstotal;
  int roundoff;
  int totalafterroundoff;
  int mrp;
  int statusbccid;
  String statuswefdate;
  int lastmoduserid;
  String lastmoddate;
  String barcodetype;
  String itemaccessedcode;
  int itemaccessedcodetypebccid;
  int dtlapprovedby;
  String dtlapproveddate;
  String dtlisblockedyn;
  String dtldocapprovalstatus;
  int fccurrencyid;
  int exchrate;
  int lctotalafterroundoff;
  int deliverynoteqty;
  double poqty;
  int prevginqty;
  int differenceqty;
  String edityn;
  int reftableid;
  int uom;
  String itemcode;
  String itemname;
  String isbarcodedyn;
  int balanceqty;
  String batchtype;
  int pobalanceqty;
  String budgetreqyn;
  int Id;
  List<GINBatchDtl> ginBatchDtl;
  List<GINDiscDataDtl> discdata;
  List<GINItemRateDtl> itemRateDtl;
  List<GINItemWiseQtyDtl> itemWiseQtyDtl;
  List<GINSrcMapDtl> srcMappingDtl;
  List<GINUomDtl> uomDtl;
  List<GINSourceMappingDtlList> srcMapList;
  GINDetailDtlList.fromJson(Map parsedJson) {
    optionid = BaseJsonParser.goodInt(parsedJson, "optionid");
    tableid = BaseJsonParser.goodInt(parsedJson, "tableid");
    parenttableid = BaseJsonParser.goodInt(parsedJson, "parenttableid");
    parenttabledataid = BaseJsonParser.goodInt(parsedJson, "parenttabledataid");
    itemid = BaseJsonParser.goodInt(parsedJson, "itemid");
    uomtypebccid = BaseJsonParser.goodInt(parsedJson, "uomtypebccid");
    uomid = BaseJsonParser.goodInt(parsedJson, "uomid");
    qty = BaseJsonParser.goodDouble(parsedJson, "qty");
    rate = BaseJsonParser.goodDouble(parsedJson, "rate");
    totalvalue = BaseJsonParser.goodInt(parsedJson, "totalvalue");
    totaldiscamout = BaseJsonParser.goodInt(parsedJson, "totaldiscamout");
    subtotal = BaseJsonParser.goodInt(parsedJson, "subtotal");
    taxamount = BaseJsonParser.goodInt(parsedJson, "taxamount");
    nettotal = BaseJsonParser.goodInt(parsedJson, "nettotal");
    discamountaftertax =
        BaseJsonParser.goodInt(parsedJson, "discamountaftertax");
    othercharges = BaseJsonParser.goodInt(parsedJson, "othercharges");
    freightcharges = BaseJsonParser.goodInt(parsedJson, "freightcharges");
    grosstotal = BaseJsonParser.goodInt(parsedJson, "grosstotal");
    roundoff = BaseJsonParser.goodInt(parsedJson, "roundoff");
    totalafterroundoff =
        BaseJsonParser.goodInt(parsedJson, "totalafterroundoff");
    mrp = BaseJsonParser.goodInt(parsedJson, "mrp");
    statusbccid = BaseJsonParser.goodInt(parsedJson, "statusbccid");
    statuswefdate = BaseJsonParser.goodString(parsedJson, "statuswefdate");
    lastmoduserid = BaseJsonParser.goodInt(parsedJson, "lastmoduserid");
    lastmoddate = BaseJsonParser.goodString(parsedJson, "lastmoddate");
    barcodetype = BaseJsonParser.goodString(parsedJson, "barcodetype");
    itemaccessedcode =
        BaseJsonParser.goodString(parsedJson, "itemaccessedcode");
    itemaccessedcodetypebccid =
        BaseJsonParser.goodInt(parsedJson, "itemaccessedcodetypebccid");
    dtlapprovedby = BaseJsonParser.goodInt(parsedJson, "dtlapprovedby");
    dtlapproveddate = BaseJsonParser.goodString(parsedJson, "dtlapproveddate");
    dtlisblockedyn = BaseJsonParser.goodString(parsedJson, "dtlisblockedyn");
    dtldocapprovalstatus =
        BaseJsonParser.goodString(parsedJson, "dtldocapprovalstatus");
    fccurrencyid = BaseJsonParser.goodInt(parsedJson, "fccurrencyid");
    exchrate = BaseJsonParser.goodInt(parsedJson, "exchrate");
    lctotalafterroundoff =
        BaseJsonParser.goodInt(parsedJson, "lctotalafterroundoff");
    deliverynoteqty = BaseJsonParser.goodInt(parsedJson, "deliverynoteqty");
    poqty = BaseJsonParser.goodDouble(parsedJson, "poqty");
    prevginqty = BaseJsonParser.goodInt(parsedJson, "prevginqty");
    differenceqty = BaseJsonParser.goodInt(parsedJson, "differenceqty");
    edityn = BaseJsonParser.goodString(parsedJson, "edityn");
    reftableid = BaseJsonParser.goodInt(parsedJson, "reftableid");
    uom = BaseJsonParser.goodInt(parsedJson, "uom");
    itemcode = BaseJsonParser.goodString(parsedJson, "itemcode");
    itemname = BaseJsonParser.goodString(parsedJson, "itemname");
    isbarcodedyn = BaseJsonParser.goodString(parsedJson, "isbarcodedyn");
    balanceqty = BaseJsonParser.goodInt(parsedJson, "balanceqty");
    batchtype = BaseJsonParser.goodString(parsedJson, "batchtype");
    pobalanceqty = BaseJsonParser.goodInt(parsedJson, "pobalanceqty");
    budgetreqyn = BaseJsonParser.goodString(parsedJson, "budgetreqyn");
    Id = BaseJsonParser.goodInt(parsedJson, "Id");
    ginBatchDtl = BaseJsonParser.goodList(parsedJson, "taxdtl")
        .map((e) => GINBatchDtl.fromJson(e))
        .toList();
    discdata = BaseJsonParser.goodList(parsedJson, "discdata")
        .map((e) => GINDiscDataDtl.fromJson(e))
        .toList();
    itemRateDtl = BaseJsonParser.goodList(parsedJson, "itemrate")
        .map((e) => GINItemRateDtl.fromJson(e))
        .toList();
    itemWiseQtyDtl = BaseJsonParser.goodList(parsedJson, "grnitemwiseqtydtl")
        .map((e) => GINItemWiseQtyDtl.fromJson(e))
        .toList();
    srcMappingDtl = BaseJsonParser.goodList(parsedJson, "grnsrcmappingdtl")
        .map((e) => GINSrcMapDtl.fromJson(e))
        .toList();
    uomDtl = BaseJsonParser.goodList(parsedJson, "uomdetails")
        .map((e) => GINUomDtl.fromJson(e))
        .toList();
    srcMapList = BaseJsonParser.goodList(parsedJson, "grnsrcmappingdtl")
        .map((e) => GINSourceMappingDtlList.fromJson(e))
        .toList();
  }
}
