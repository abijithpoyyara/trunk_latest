import 'package:redstars/utility.dart';

class PoModel {
  String status;
  bool isBookStockEntered;
  String isInterState;
  String transactionNo;
  String transactionDate;
  String supplierName;
  double qty;
  int rowNo;
  int supplierId;
  int amendmentNo;
  int refTableData;
  int refTableId;
  int totalValue;
  int statusBccId;
  int companyId;
  int branchId;
  int finYearId;
  int refOptionId;
  int bookStockOptionId;
  int start;
  int limit;
  int totalRecords;

  PoModel({
    this.rowNo,
    this.supplierId,
    this.supplierName,
    this.amendmentNo,
    this.refTableData,
    this.refTableId,
    this.transactionNo,
    this.transactionDate,
    this.qty,
    this.totalValue,
    this.statusBccId,
    this.status,
    this.companyId,
    this.branchId,
    this.finYearId,
    this.refOptionId,
    this.isInterState,
    this.bookStockOptionId,
    this.isBookStockEntered,
    this.start,
    this.limit,
    this.totalRecords,
  });

  PoModel.fromJson(dynamic json) {
    rowNo = json["rowno"];

    supplierId = json["supplierid"];
    supplierName = json["suppliername"];
    amendmentNo = json["amendmentno"];
    refTableData = json["reftabledata"];
    refTableId = json["reftableid"];
    transactionNo = json["transactionno"];
    transactionDate = json["transactiondate"];
    qty = BaseJsonParser.goodDouble(json, "qty");
    totalValue = json["totalvalue"];
    statusBccId = json["statusbccid"];
    status = json["status"];
    companyId = json["companyid"];
    branchId = json["branchid"];
    finYearId = json["finyearid"];
    refOptionId = json["refoptionid"];
    isInterState = BaseJsonParser.goodString(json, "interstateyn");
    bookStockOptionId = json["bookstockoptionid"];
    isBookStockEntered = BaseJsonParser.goodBoolean(json, "bookstockenteredyn");
    start = json["start"];
    limit = json["limit"];
    totalRecords = json["totalrecords"];
  }
}
