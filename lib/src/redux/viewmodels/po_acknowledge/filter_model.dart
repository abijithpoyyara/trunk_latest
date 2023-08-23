import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/po_ack_supplier_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/supplier_lookup_model.dart';

import 'package:base/utility.dart';


class POFilterModel {
  DateTimeRange dateRange;
  DateTime fromDate;
  DateTime toDate;
  String transNo;
  POAckSupplierLookupItem supplier;

  POFilterModel({
    this.fromDate,
    this.toDate,
    this.dateRange,
    this.transNo,
    this.supplier,
  });
}
