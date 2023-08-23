import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';

import '../../../../utility.dart';

class GINFilterModel {
  DateTimeRange dateRange;
  DateTime fromDate;
  DateTime toDate;
  String transNo;
  SupplierLookupItem supplier;

  GINFilterModel({
    this.fromDate,
    this.toDate,
    this.dateRange,
    this.transNo,
    this.supplier,
  });

  @override
  String toString() {
    return "   fromDate : ${BaseDates(fromDate).format}" +
        "   toDate : ${BaseDates(toDate).format}" +
        "   supplier : $supplier" +
        "   transNo : $transNo";
  }

  GINFilterModel copyWith({
    DateTimeRange dateRange,
    DateTime fromDate,
    DateTime toDate,
    String transNo,
    SupplierLookupItem supplier,
  }) {
    return GINFilterModel(
      dateRange: dateRange ?? this.dateRange,
      transNo: transNo ?? this.transNo,
      supplier: supplier ?? this.supplier,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }
}
