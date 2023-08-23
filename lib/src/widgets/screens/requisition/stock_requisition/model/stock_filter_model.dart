import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/location_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_detail_view_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';

import '../../../../../../utility.dart';

class SRFilterModel {
  DateTimeRange dateRange;
  DateTime fromDate;
  DateTime toDate;
  String transNo;
  LocationLookUpItem location;
  StockLocation locObj;
  List<SelectedStockViewModel> result;

  SRFilterModel(
      {this.fromDate,
      this.toDate,
      this.dateRange,
      this.transNo,
      this.location,
      this.result,
      this.locObj});

  @override
  String toString() {
    return "   fromDate : ${BaseDates(fromDate).format}" +
        "   toDate : ${BaseDates(toDate).format}" +
        "   supplier : $location" +
        "   transNo : $transNo";
  }

  SRFilterModel copyWith({
    DateTimeRange dateRange,
    DateTime fromDate,
    DateTime toDate,
    String transNo,
    LocationLookUpItem supplier,
    List<SelectedStockViewModel> result,
    StockLocation locObj,
  }) {
    return SRFilterModel(
        dateRange: dateRange ?? this.dateRange,
        transNo: transNo ?? this.transNo,
        location: supplier ?? this.location,
        fromDate: fromDate ?? this.fromDate,
        toDate: toDate ?? this.toDate,
        result: result ?? this.result,
        locObj: locObj ?? this.locObj);
  }
}
