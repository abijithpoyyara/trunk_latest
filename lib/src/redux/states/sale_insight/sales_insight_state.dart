import 'package:flutter/widgets.dart';
import 'package:redstars/src/redux/states/sale_insight/sales_insight_base.dart';
import 'package:redstars/src/redux/states/sale_insight/sales_insight_brand.dart';
import 'package:redstars/src/redux/states/sale_insight/sales_insight_customer.dart';
import 'package:redstars/src/redux/states/sale_insight/sales_insight_home.dart';
import 'package:redstars/src/redux/states/sale_insight/sales_insight_instrument.dart';

@immutable
class SalesInsightState {
  final SalesInsightHomeState salesInsightHomeState;
  final SalesInsightCustomerState salesInsightCustomerState;
  final SalesInsightInstrumentState salesInsightInstrumentState;
  final SalesInsightBrandState salesInsightBrandState;
  final SalesInsightBaseState salesInsightBaseState;

  SalesInsightState(
      {@required this.salesInsightHomeState,
      @required this.salesInsightCustomerState,
      @required this.salesInsightInstrumentState,
      @required this.salesInsightBrandState,
      @required this.salesInsightBaseState});

  factory SalesInsightState.initial() {
    return SalesInsightState(
        salesInsightHomeState: SalesInsightHomeState.initial(),
        salesInsightBrandState: SalesInsightBrandState.initial(),
        salesInsightCustomerState: SalesInsightCustomerState.initial(),
        salesInsightBaseState: SalesInsightBaseState.initial(),
        salesInsightInstrumentState: SalesInsightInstrumentState.initial());
  }

  SalesInsightState copyWith(
          {SalesInsightHomeState salesInsightHomeState,
          SalesInsightCustomerState salesInsightCustomerState,
          SalesInsightInstrumentState salesInsightInstrumentState,
          SalesInsightBrandState salesInsightBrandState,
          SalesInsightBaseState salesInsightBaseState}) =>
      SalesInsightState(
          salesInsightHomeState:
              salesInsightHomeState ?? this.salesInsightHomeState,
          salesInsightCustomerState:
              salesInsightCustomerState ?? this.salesInsightCustomerState,
          salesInsightInstrumentState:
              salesInsightInstrumentState ?? this.salesInsightInstrumentState,
          salesInsightBrandState:
              salesInsightBrandState ?? this.salesInsightBrandState,
          salesInsightBaseState:
              salesInsightBaseState ?? this.salesInsightBaseState);
}
