import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';

class GINDateFilterModel {
  DateTimeRange dateRange;
  DateTime fromDate;
  DateTime toDate;
  DateTime poDateFrom;
  DateTime poDateTo;
  String gINno;
  String poNo;
  List<SupplierLookupItem> suppliers;
  List<dynamic> datas;

  GINDateFilterModel({
    this.fromDate,
    this.toDate,
    this.dateRange,
    this.poDateFrom,
    this.gINno,
    this.poDateTo,
    this.poNo,
    this.suppliers,
    this.datas,
  });

  GINDateFilterModel copyWith({
    DateTimeRange dateRange,
    DateTime fromDate,
    DateTime toDate,
    DateTime poDateFrom,
    DateTime poDateTo,
    String gINno,
    String poNo,
    List<SupplierLookupItem> suppliers,
    List<dynamic> datas,
  }) {
    return GINDateFilterModel(
      dateRange: dateRange ?? this.dateRange,
      gINno: gINno ?? this.gINno,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      poNo: poNo ?? this.poNo,
      suppliers: suppliers ?? this.suppliers,
      poDateFrom: poDateFrom ?? this.poDateFrom,
      poDateTo: poDateTo ?? this.poDateTo,
      datas: datas ?? this.datas,
    );
  }
}
