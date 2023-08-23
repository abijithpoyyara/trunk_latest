import 'package:flutter/material.dart';
import 'package:redstars/src/services/model/response/lookups/item_lookup_model.dart';
import 'package:redstars/src/services/model/response/lookups/pricing/location_lookup_model.dart';
import 'package:redstars/src/services/model/response/requisition/stock_requisition/stock_location_model.dart';

import '../../../../../../utility.dart';

class ItemGradeRateSettingsFilterModel {
  DateTimeRange dateRange;
  DateTime fromDate;
  DateTime toDate;
  String transNo;
  StockLocation locObj;
  ItemLookupItem item;
  List<ItemLookupItem> items;
  String pricingNo;
  List<dynamic> datas;

  ItemGradeRateSettingsFilterModel(
      {this.fromDate,
      this.toDate,
      this.dateRange,
      this.transNo,
      this.item,
      this.items,
      this.datas,
      this.pricingNo,
      this.locObj});

  @override
  String toString() {
    return "   fromDate : ${BaseDates(fromDate).format}" +
        "   toDate : ${BaseDates(toDate).format}" +
        "   transNo : $transNo";
  }

  ItemGradeRateSettingsFilterModel copyWith({
    DateTimeRange dateRange,
    DateTime fromDate,
    DateTime toDate,
    String transNo,
    LocationLookUpItem supplier,
    ItemLookupItem item,
    String pricingNo,
    List<ItemLookupItem> items,
    StockLocation locObj,
    List<dynamic> datas,
  }) {
    return ItemGradeRateSettingsFilterModel(
        dateRange: dateRange ?? this.dateRange,
        transNo: transNo ?? this.transNo,
        fromDate: fromDate ?? this.fromDate,
        toDate: toDate ?? this.toDate,
        pricingNo: pricingNo ?? this.pricingNo,
        item: item ?? this.item,
        items: items ?? this.items,
        datas: datas ?? this.datas,
        locObj: locObj ?? this.locObj);
  }
}
