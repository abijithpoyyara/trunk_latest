import 'package:base/redux.dart';
import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/sales_insight/sales_insight_action.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_analysis_model.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_branch_model.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_item_model.dart';
import 'package:redstars/src/services/model/response/sales_insight/revenue_salesman_model.dart';
import 'package:redstars/src/services/repository/sales_insight/sales_insight_repository.dart';
import 'package:base/redux.dart';
import 'package:base/redux.dart';

class ListFetchSuccessAction {
  final RevenueAnalysisModel response;

  ListFetchSuccessAction(this.response);
}

class RevenueAnalysisFetchSuccessAction {
  final List<RevenueBranchItem> branchList;
  final List<RevenueSalesmanItem> salesmanList;
  final List<RevenueItemList> itemList;

  RevenueAnalysisFetchSuccessAction(
      {this.branchList, this.salesmanList, this.itemList});
}

ThunkAction fetchSummaryList(DateTime fromDate, DateTime toDate,
    {bool margin, bool major}) {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
          status: LoadingStatus.loading,
          message: "Getting Transations",
          type: "Sales Summary"));
      store.dispatch(ChangeFilterAction(
          margin: margin,
          major: major,
          toDate: toDate,
          fromDate: fromDate,
          type: "Sales Summary"));
      SalesInsightRepository().getBranchSummaryReport(
          fromDate: fromDate,
          toDate: toDate,
          margin: margin ?? false,
          showMajorCategory: major ?? false,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error,
              message: exception.toString(),
              type: "Sales Summary")),
          onRequestSuccess: (response) =>
              store.dispatch(ListFetchSuccessAction(response)));
      SalesInsightRepository().getBrandSummaryReport(
          fromDate: fromDate,
          toDate: toDate,
          margin: margin ?? false,
          showMajorCategory: major ?? false,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error,
              message: exception.toString(),
              type: "Sales Summary")),
          onRequestSuccess: (response) =>
              store.dispatch(ListFetchSuccessAction(response)));
      SalesInsightRepository().getCategorySummaryReport(
          fromDate: fromDate,
          toDate: toDate,
          margin: margin ?? false,
          showMajorCategory: major ?? false,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error,
              message: exception.toString(),
              type: "Sales Summary")),
          onRequestSuccess: (response) =>
              store.dispatch(ListFetchSuccessAction(response)));
    });
  };
}

ThunkAction fetchRevenueAnalysisLists(DateTime fromDate, DateTime toDate,
    {bool margin, bool major}) {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
          status: LoadingStatus.loading,
          message: "Getting Transations",
          type: "Revenue Analysys"));
      ChangeFilterAction(
          margin: margin,
          major: major,
          toDate: toDate,
          fromDate: fromDate,
          type: "Revenue Analysys");
      SalesInsightRepository().getRevenueAnalysisBranchList(
          fromDate: fromDate,
          toDate: toDate,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error,
              message: exception.toString(),
              type: "Revenue Analysys")),
          onRequestSuccess: (response) => store.dispatch(
              RevenueAnalysisFetchSuccessAction(branchList: response)));

      SalesInsightRepository().getRevenueAnalysisSalesmanList(
          fromDate: fromDate,
          toDate: toDate,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error,
              message: exception.toString(),
              type: "Revenue Analysys")),
          onRequestSuccess: (response) => store.dispatch(
              RevenueAnalysisFetchSuccessAction(salesmanList: response)));

      SalesInsightRepository().getRevenueAnalysisItemList(
          fromDate: fromDate,
          toDate: toDate,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error,
              message: exception.toString(),
              type: "Revenue Analysys")),
          onRequestSuccess: (response) => store
              .dispatch(RevenueAnalysisFetchSuccessAction(itemList: response)));
    });
  };
}
