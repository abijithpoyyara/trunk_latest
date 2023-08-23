import 'package:base/redux.dart';
import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/sales_insight/sales_insight_action.dart';
import 'package:redstars/src/services/model/response/sales_insight/brand_connect_analysis.dart';
import 'package:redstars/src/services/repository/sales_insight/brand_connect_analysis_repository.dart';
import 'package:base/redux.dart';
import 'package:base/redux.dart';

class ListFetchSuccessAction {
  final BrandConnectAnalysisModel response;

  ListFetchSuccessAction(this.response);
}

ThunkAction fetchBrandConnectList(DateTime fromDate, DateTime toDate,
    {bool margin, bool major}) {
  return (Store store) async {
    new Future(() async {
      store.dispatch(new LoadingAction(
        status: LoadingStatus.loading,
        message: "Getting BrandConnect List",
      ));
      ChangeFilterAction(
        margin: margin,
        major: major,
        toDate: toDate,
        fromDate: fromDate,
      );
      BrandConnectAnalysisRepository().getBrandConnectList(
          fromDate: fromDate,
          toDate: toDate,
          margin: margin ?? false,
          showMajorBrand: major ?? false,
          onRequestFailure: (exception) => store.dispatch(new LoadingAction(
              status: LoadingStatus.error, message: exception.toString())),
          onRequestSuccess: (response) =>
              store.dispatch(new ListFetchSuccessAction(response)));
    });
  };
}
