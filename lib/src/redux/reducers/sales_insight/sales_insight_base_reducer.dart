import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/sales_insight/sales_insight_action.dart';
import 'package:redstars/src/redux/states/sale_insight/sales_insight_base.dart';
import 'package:base/redux.dart';

final salesInsightBaseReducer = combineReducers<SalesInsightBaseState>([
  TypedReducer<SalesInsightBaseState, ChangeFilterAction>(_changeFilterAction),
  TypedReducer<SalesInsightBaseState, LoadingAction>(_changeLoadingStatus),
]);

SalesInsightBaseState _changeLoadingStatus(
        SalesInsightBaseState state, LoadingAction action) =>
    state.copyWith(
        loadingStatus: action.status,
        loadingMessage: action.message,
        loadingError: action.message);

SalesInsightBaseState _changeFilterAction(
        SalesInsightBaseState state, ChangeFilterAction action) =>
    state.copyWith(
        fromDate: action.fromDate,
        toDate: action.toDate,
        major: action.major,
        margin: action.margin);
