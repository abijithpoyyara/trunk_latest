import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/sales_insight/sales_insight_action.dart';
import 'package:redstars/src/services/model/response/sales_insight/customer_analysis.dart';
import 'package:redstars/src/services/repository/sales_insight/customer_analysis_repository.dart';

class CustomerBranchFetchSuccessAction {
  List<CustomerBranchList> branches;

  CustomerBranchFetchSuccessAction(this.branches);
}

class CustomerEngagementFetchSuccessAction {
  CustomerEngagementModel customerEngagement;

  CustomerEngagementFetchSuccessAction(this.customerEngagement);
}

class MarginAnalysisFetchSuccessAction {
  List<CustomerMarginList> marginList;

  MarginAnalysisFetchSuccessAction(this.marginList);
}

ThunkAction fetchCustomerData(DateTime fromDate, DateTime toDate) {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
          status: LoadingStatus.loading, message: "Getting Transations"));

      CustomerAnalysisRepository().getCustomerBranchAnalysisList(
          fromDate: fromDate,
          toDate: toDate,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error, message: exception.toString())),
          onRequestSuccess: (response) =>
              store.dispatch(CustomerBranchFetchSuccessAction(response)));

      CustomerAnalysisRepository().getCustomerEngagement(
          fromDate: fromDate,
          toDate: toDate,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error, message: exception.toString())),
          onRequestSuccess: (response) =>
              store.dispatch(CustomerEngagementFetchSuccessAction(response)));
    });
  };
}

ThunkAction fetchMarginData(DateTime fromDate, DateTime toDate) {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
          status: LoadingStatus.loading, message: "Getting Transations"));
      store.dispatch(ChangeFilterAction(toDate: toDate, fromDate: fromDate));
      CustomerAnalysisRepository().getMarginAnalysisList(
          fromDate: fromDate,
          toDate: toDate,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error, message: exception.toString())),
          onRequestSuccess: (response) =>
              store.dispatch(MarginAnalysisFetchSuccessAction(response)));
    });
  };
}
