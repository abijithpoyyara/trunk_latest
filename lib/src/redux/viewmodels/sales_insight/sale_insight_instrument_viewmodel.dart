import 'package:base/redux.dart';
import 'package:base/redux.dart';
import 'package:redstars/src/redux/actions/sales_insight/instrument_analysis_action.dart';
import 'package:redstars/src/redux/states/app_state.dart';
import 'package:redstars/src/services/model/response/sales_insight/instrument_analysis_model.dart';
import 'package:redstars/src/widgets/screens/sales_insight/_models/filter_model.dart';
import 'package:base/redux.dart';

class SalesInsightInstrumentViewModel extends BaseViewModel {


  final bool margin;
  final bool major;
  final DateTime fromDate;
  final DateTime toDate;

  final List<InstrumentHeader> headers;
  final List<Map<String, dynamic>> instrumentDtl;
  final List<CoordinatesDtl> coordinatesDtl;

  final Function(SaleInsightFilterModel model) onFilter;

  SalesInsightInstrumentViewModel(
      {
      LoadingStatus loadingStatus,
      String loadingMessage,
      String errorMessage,
      this.margin,
      this.major,
      this.fromDate,
      this.toDate,
      this.onFilter,
      this.headers,
      this.instrumentDtl,
      this.coordinatesDtl}): super(
    loadingStatus: loadingStatus,
    loadingMessage: loadingMessage,
    loadingError: errorMessage,
  );

  static SalesInsightInstrumentViewModel fromStore(Store<AppState> store) {
    final state = store.state.salesInsightState.salesInsightInstrumentState;
    return SalesInsightInstrumentViewModel(
      loadingStatus: state.loadingStatus,
      loadingMessage: state.loadingMessage,
      errorMessage: state.loadingError,
      fromDate: state.fromDate,
      margin: state.margin,
      major: state.major,
      toDate: state.toDate,
      headers: state.headers,
      instrumentDtl: state.instrumentDtl,
      coordinatesDtl: state.coordinatesDtl,
      onFilter: (model) =>
          store.dispatch(fetchAnalysisData(model.fromDate, model.toDate)),
    );
  }
}
