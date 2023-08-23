import 'package:base/redux.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/redux/states/sale_insight/sales_insight_base.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_analysis_model.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_branch_model.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_item_model.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_salesman_model.dart';

@immutable
class SalesInsightHomeState extends SalesInsightBaseState {
  final List<RevenueCategoryList> categoryList;
  final List<RevenueBranchList> branchList;
  final List<RevenueBrandList> brandList;
  final List<RevenueBranchItem> branchRevenue;
  final List<RevenueSalesmanItem> salesman;
  final List<RevenueItemList> itemsRevenue;

  final LoadingStatus categoryLoadingStatus,
      branchLoadingStatus,
      brandLoadingStatus,
      branchRevenueLoadingStatus,
      salesmanLoadingStatus,
      itemsLoadingStatus;

  SalesInsightHomeState({
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    DateTime fromDate,
    DateTime toDate,
    bool margin,
    bool major,
    this.categoryList,
    this.branchList,
    this.brandList,
    this.branchRevenue,
    this.salesman,
    this.itemsRevenue,
    this.categoryLoadingStatus,
    this.branchLoadingStatus,
    this.brandLoadingStatus,
    this.branchRevenueLoadingStatus,
    this.salesmanLoadingStatus,
    this.itemsLoadingStatus,
  }) : super(
            loadingStatus: loadingStatus,
            loadingError: loadingError,
            loadingMessage: loadingMessage,
            margin: margin,
            major: major,
            fromDate: fromDate,
            toDate: toDate);

  @override
  SalesInsightHomeState copyWith(
      {LoadingStatus loadingStatus,
      String loadingMessage,
      DateTime fromDate,
      DateTime toDate,
      bool margin,
      bool major,
      String loadingError,
      LoadingStatus categoryLoadingStatus,
      LoadingStatus branchLoadingStatus,
      LoadingStatus brandLoadingStatus,
      LoadingStatus branchRevenueLoadingStatus,
      LoadingStatus salesmanLoadingStatus,
      LoadingStatus itemsLoadingStatus,
      List<RevenueCategoryList> categoryList,
      List<RevenueBranchList> branchList,
      List<RevenueBrandList> brandList,
      List<RevenueBranchItem> branchRevenue,
      List<RevenueSalesmanItem> salesman,
      List<RevenueItemList> itemsRevenue}) {
    return SalesInsightHomeState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      loadingError: loadingError ?? this.loadingError,
      margin: margin ?? this.margin,
      major: major ?? this.major,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      categoryList: categoryList ?? this.categoryList,
      branchList: branchList ?? this.branchList,
      brandList: brandList ?? this.brandList,
      branchRevenue: branchRevenue ?? this.branchRevenue,
      salesman: salesman ?? this.salesman,
      itemsRevenue: itemsRevenue ?? this.itemsRevenue,
      categoryLoadingStatus:
          categoryLoadingStatus ?? this.categoryLoadingStatus,
      branchLoadingStatus: branchLoadingStatus ?? this.branchLoadingStatus,
      brandLoadingStatus: brandLoadingStatus ?? this.brandLoadingStatus,
      branchRevenueLoadingStatus:
          branchRevenueLoadingStatus ?? this.branchRevenueLoadingStatus,
      salesmanLoadingStatus:
          salesmanLoadingStatus ?? this.salesmanLoadingStatus,
      itemsLoadingStatus: itemsLoadingStatus ?? this.itemsLoadingStatus,
    );
  }

  factory SalesInsightHomeState.initial() {
    return SalesInsightHomeState(
        categoryLoadingStatus: LoadingStatus.loading,
        branchLoadingStatus: LoadingStatus.loading,
        brandLoadingStatus: LoadingStatus.loading,
        branchRevenueLoadingStatus: LoadingStatus.loading,
        salesmanLoadingStatus: LoadingStatus.loading,
        itemsLoadingStatus: LoadingStatus.loading,
        categoryList: null,
        branchList: null,
        brandList: null,
        branchRevenue: null,
        salesman: null,
        itemsRevenue: null,
        fromDate: DateTime(DateTime.now().year, 1),
        toDate: DateTime.now(),
        margin: false,
        major: true);
  }
}
