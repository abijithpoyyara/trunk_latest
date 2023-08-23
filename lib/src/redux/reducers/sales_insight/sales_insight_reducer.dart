library sales_insight_reducer;

import 'package:redstars/src/redux/reducers/sales_insight/sales_insight_base_reducer.dart';
import 'package:redstars/src/redux/reducers/sales_insight/sales_insight_brand_reducer.dart';
import 'package:redstars/src/redux/reducers/sales_insight/sales_insight_customer_reducer.dart';
import 'package:redstars/src/redux/reducers/sales_insight/sales_insight_home_reducer.dart';
import 'package:redstars/src/redux/reducers/sales_insight/sales_insight_instrument_reducer.dart';
import 'package:redstars/src/redux/states/sale_insight/sales_insight_state.dart';

export 'package:redstars/src/redux/reducers/sales_insight/sales_insight_base_reducer.dart';
export 'package:redstars/src/redux/reducers/sales_insight/sales_insight_brand_reducer.dart';
export 'package:redstars/src/redux/reducers/sales_insight/sales_insight_customer_reducer.dart';
export 'package:redstars/src/redux/reducers/sales_insight/sales_insight_home_reducer.dart';
export 'package:redstars/src/redux/reducers/sales_insight/sales_insight_instrument_reducer.dart';
export 'package:redstars/src/redux/states/sale_insight/sales_insight_state.dart';

SalesInsightState salesInsightReducer(
        SalesInsightState state, dynamic action) =>
    state.copyWith(
      salesInsightHomeState:
          salesInsightHomeReducer(state.salesInsightHomeState, action),
      salesInsightCustomerState:
          salesInsightCustomerReducer(state.salesInsightCustomerState, action),
      salesInsightInstrumentState: salesInsightInstrumentReducer(
          state.salesInsightInstrumentState, action),
      salesInsightBrandState:
          salesInsightBrandReducer(state.salesInsightBrandState, action),
      salesInsightBaseState:
          salesInsightBaseReducer(state.salesInsightBaseState, action),
    );
