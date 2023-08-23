import 'package:base/redux.dart';
import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/sales_insight/sales_insight_action.dart';
import 'package:redstars/src/services/model/response/sales_insight/instrument_analysis_model.dart';
import 'package:redstars/src/services/repository/sales_insight/instrument_analysis_repository.dart';
import 'package:base/redux.dart';
import 'package:base/redux.dart';

class InstrumentHeadersFetchSuccessAction {
  List<InstrumentHeader> headers;

  InstrumentHeadersFetchSuccessAction(this.headers);
}

class InstrumentAnalysisFetchSuccessAction {
  InstrumentAnalysisModel instrumentList;

  InstrumentAnalysisFetchSuccessAction(this.instrumentList);
}

ThunkAction fetchHeaderData(DateTime fromDate, DateTime toDate) {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
          status: LoadingStatus.loading, message: "Getting Transations"));

      InstrumentAnalysisRepository().getInstrumentHeaders(
          fromDate: fromDate,
          toDate: toDate,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error, message: exception.toString())),
          onRequestSuccess: (response) =>
              store.dispatch(InstrumentHeadersFetchSuccessAction(response)));
    });
  };
}

ThunkAction fetchAnalysisData(DateTime fromDate, DateTime toDate) {
  return (Store store) async {
    Future(() async {
      store.dispatch(LoadingAction(
          status: LoadingStatus.loading, message: "Getting Transations"));
      store.dispatch(ChangeFilterAction(toDate: toDate, fromDate: fromDate));
      InstrumentAnalysisRepository().getInstrumentAnalysisList(
          fromDate: fromDate,
          toDate: toDate,
          onRequestFailure: (exception) => store.dispatch(LoadingAction(
              status: LoadingStatus.error, message: exception.toString())),
          onRequestSuccess: (response) =>
              store.dispatch(InstrumentAnalysisFetchSuccessAction(response)));
    });
  };
}
