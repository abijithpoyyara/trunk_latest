import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';

class FilterModel {
  DateTimeRange dateRange;
  DateTime fromDate;
  DateTime toDate;
  String transNo;
  List<dynamic> suppliers;
  // BCCModel transactionType;
  String reqNo;
  BranchStockLocation loc;
  StockLocation location;
  String amountFrom;
  String amountTo;
  DateTime salesinvoiceFromDate;
  DateTime salesinvoiceToDate;
  String salesinvoiceTransno;
  FilterModel(
      {this.fromDate,
      this.toDate,
      this.dateRange,
      this.transNo,
      this.suppliers,
      this.loc,
      // this.transactionType,
      this.reqNo,
      this.location,
      this.amountFrom,
      this.salesinvoiceFromDate,
      this.salesinvoiceToDate,
      this.salesinvoiceTransno,
      this.amountTo});
}
