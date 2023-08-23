import 'package:base/redux.dart';
import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/sales_insight/sales_insight_action.dart';
import 'package:redstars/src/redux/actions/sales_insight/sales_insight_brand_action.dart';
import 'package:redstars/src/redux/states/sale_insight/sales_insight_brand.dart';
import 'package:base/redux.dart';

final salesInsightBrandReducer = combineReducers<SalesInsightBrandState>([
  TypedReducer<SalesInsightBrandState, LoadingAction>(_changeLoadingStatus),
  TypedReducer<SalesInsightBrandState, ChangeFilterAction>(_changeFilterAction),
  TypedReducer<SalesInsightBrandState, ListFetchSuccessAction>(
      _brandListFetchAction),
]);

SalesInsightBrandState _changeLoadingStatus(
        SalesInsightBrandState state, LoadingAction action) =>
    state.copyWith(
        loadingStatus: action.status,
        loadingMessage: action.message,
        loadingError: action.message);

SalesInsightBrandState _brandListFetchAction(
    SalesInsightBrandState state, ListFetchSuccessAction action) {
  return state.copyWith(
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      brandConnectList: action.response.brandConnectList);
}

SalesInsightBrandState _changeFilterAction(
    SalesInsightBrandState state, ChangeFilterAction action) {
  return state.copyWith(
    fromDate: action.fromDate,
    toDate: action.toDate,
    major: action.major,
    margin: action.margin,
  );
}
/*
SalesInsightBrandState _clearState(SalesInsightBrandState state, OnClearAction action) {
  print("clearing state");
  return SalesInsightBrandState.initial();
}*/
