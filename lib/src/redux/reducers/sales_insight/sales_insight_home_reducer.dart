import 'package:base/redux.dart';
import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/sales_insight/sales_insight_action.dart';
import 'package:redstars/src/redux/actions/sales_insight/sales_insight_home_action.dart';
import 'package:redstars/src/redux/states/sale_insight/sales_insight_home.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_branch_model.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_item_model.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_salesman_model.dart';
import 'package:base/redux.dart';

final salesInsightHomeReducer = combineReducers<SalesInsightHomeState>([
  TypedReducer<SalesInsightHomeState, LoadingAction>(_changeLoadingStatus),
  TypedReducer<SalesInsightHomeState, ChangeFilterAction>(_changeFilterAction),
  TypedReducer<SalesInsightHomeState, RevenueAnalysisFetchSuccessAction>(
      _analysisFetchSuccessAction),
  TypedReducer<SalesInsightHomeState, ListFetchSuccessAction>(
      _revenueListFetchSuccessStatus),
]);

SalesInsightHomeState _changeLoadingStatus(
    SalesInsightHomeState state, LoadingAction action) {
  switch (action.type) {
    case "Sales Summary":
      return state.copyWith(
          loadingStatus: action.status,
          categoryLoadingStatus: action.status,
          branchLoadingStatus: action.status,
          brandLoadingStatus: action.status,
          loadingMessage: action.message,
          loadingError: action.message);
    case "Revenue Analysys":
      return state.copyWith(
          branchRevenueLoadingStatus: action.status,
          salesmanLoadingStatus: action.status,
          itemsLoadingStatus: action.status,
          loadingStatus: action.status,
          loadingMessage: action.message,
          loadingError: action.message);
  }
  return state.copyWith(
      loadingStatus: action.status,
      loadingMessage: action.message,
      loadingError: action.message);
}

SalesInsightHomeState _revenueListFetchSuccessStatus(
    SalesInsightHomeState state, ListFetchSuccessAction action) {
  final brandList = action.response.revenueBrandList ?? state.brandList;
  final branchList = action.response.revenueBranchList ?? state.branchList;
  final categoryList =
      action.response.revenueCategoryList ?? state.categoryList;

  return state.copyWith(
      brandList: brandList,
      branchList: branchList,
      categoryList: categoryList,
      categoryLoadingStatus:
          brandList != null ? LoadingStatus.success : LoadingStatus.loading,
      branchLoadingStatus:
          branchList != null ? LoadingStatus.success : LoadingStatus.loading,
      brandLoadingStatus:
          categoryList != null ? LoadingStatus.success : LoadingStatus.loading,
      loadingMessage: state.loadingMessage,
      loadingError: state.loadingError);
}

SalesInsightHomeState _analysisFetchSuccessAction(
    SalesInsightHomeState state, RevenueAnalysisFetchSuccessAction action) {
  List<RevenueBranchItem> branch = action.branchList ?? state.branchRevenue;
  List<RevenueSalesmanItem> salesman = action.salesmanList ?? state.salesman;
  List<RevenueItemList> itemList = action.itemList ?? state.itemsRevenue;

  return state.copyWith(
      branchRevenue: branch,
      salesman: salesman,
      itemsRevenue: itemList,
      branchRevenueLoadingStatus:
          branch != null ? LoadingStatus.success : LoadingStatus.loading,
      salesmanLoadingStatus:
          salesman != null ? LoadingStatus.success : LoadingStatus.loading,
      itemsLoadingStatus:
          itemList != null ? LoadingStatus.success : LoadingStatus.loading,
      loadingMessage: state.loadingMessage,
      loadingError: state.loadingError);
}

SalesInsightHomeState _changeFilterAction(
    SalesInsightHomeState state, ChangeFilterAction action) {
  switch (action.type) {
    case "Sales Summary":
      return state.copyWith(
          fromDate: action.fromDate,
          toDate: action.toDate,
          major: action.major,
          brandList: null,
          branchList: null,
          categoryList: null,
          margin: action.margin);
    case "Revenue Analysys":
      return state.copyWith(
          fromDate: action.fromDate,
          toDate: action.toDate,
          major: action.major,
          branchRevenue: null,
          salesman: null,
          itemsRevenue: null,
          margin: action.margin);
  }
  return state.copyWith(
      fromDate: action.fromDate,
      toDate: action.toDate,
      major: action.major,
      margin: action.margin);
}
