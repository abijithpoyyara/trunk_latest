import 'package:base/redux.dart';
import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/sales_insight/instrument_analysis_action.dart';
import 'package:redstars/src/redux/actions/sales_insight/sales_insight_action.dart';
import 'package:redstars/src/redux/states/sale_insight/sales_insight_instrument.dart';
import 'package:base/redux.dart';

final salesInsightInstrumentReducer =
    combineReducers<SalesInsightInstrumentState>([
  TypedReducer<SalesInsightInstrumentState, LoadingAction>(
      _changeLoadingStatus),
  TypedReducer<SalesInsightInstrumentState, ChangeFilterAction>(
      _changeFilterAction),
  TypedReducer<SalesInsightInstrumentState,
      InstrumentHeadersFetchSuccessAction>(_headersFetchSuccess),
  TypedReducer<SalesInsightInstrumentState,
      InstrumentAnalysisFetchSuccessAction>(_instrumentsFetchSuccess),
]);

SalesInsightInstrumentState _changeLoadingStatus(
        SalesInsightInstrumentState state, LoadingAction action) =>
    state.copyWith(
        loadingStatus: action.status,
        loadingMessage: action.message,
        loadingError: action.message);

SalesInsightInstrumentState _changeFilterAction(
        SalesInsightInstrumentState state, ChangeFilterAction action) =>
    state.copyWith(
        fromDate: action.fromDate,
        toDate: action.toDate,
        major: action.major,
        margin: action.margin);

SalesInsightInstrumentState _headersFetchSuccess(
    SalesInsightInstrumentState state,
    InstrumentHeadersFetchSuccessAction action) {
  return state.copyWith(
      headers: action.headers,
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "");
}

SalesInsightInstrumentState _instrumentsFetchSuccess(
    SalesInsightInstrumentState state,
    InstrumentAnalysisFetchSuccessAction action) {
  return state.copyWith(
      coordinatesDtl: action.instrumentList?.coordinatesDtl,
      instrumentDtl: action.instrumentList?.instrumentDtl,
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "");
}
