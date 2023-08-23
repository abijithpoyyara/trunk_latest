import 'package:base/services.dart';
import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';

class PVFilterModel {
  DateTimeRange dateRange;
  DateTime fromDate;
  DateTime toDate;
  String transNo;
  BCCModel transactionType;
  String reqNo;
  StockLocation location;
  String amountFrom;
  String amountTo;
  DateTime salesinvoiceFromDate;
  DateTime salesinvoiceToDate;
  String salesinvoiceTransno;
  PVFilterModel(
      {this.fromDate,
      this.toDate,
      this.dateRange,
      this.transNo,
      this.transactionType,
      this.reqNo,
      this.location,
      this.amountFrom,
      this.salesinvoiceFromDate,
      this.salesinvoiceToDate,
      this.salesinvoiceTransno,
      this.amountTo});
}
