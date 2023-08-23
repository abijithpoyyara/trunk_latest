import 'package:base/redux.dart';
import 'package:flutter/widgets.dart';
import 'package:redstars/src/redux/states/sale_insight/sales_insight_base.dart';
import 'package:redstars/src/services/model/response/sales_insight/instrument_analysis_model.dart';

@immutable
class SalesInsightInstrumentState extends SalesInsightBaseState {
  final List<InstrumentHeader> headers;
  final List<Map<String, dynamic>> instrumentDtl;
  final List<CoordinatesDtl> coordinatesDtl;

  SalesInsightInstrumentState({
    this.headers,
    this.instrumentDtl,
    this.coordinatesDtl,
    LoadingStatus loadingStatus,
    String loadingError,
    String loadingMessage,
    bool margin,
    DateTime fromDate,
    DateTime toDate,
    bool major,
  }) : super(
            loadingStatus: loadingStatus,
            loadingError: loadingError,
            loadingMessage: loadingMessage,
            margin: margin,
            major: major,
            fromDate: fromDate,
            toDate: toDate);

  @override
  SalesInsightInstrumentState copyWith(
      {LoadingStatus loadingStatus,
      String loadingMessage,
      DateTime fromDate,
      DateTime toDate,
      bool margin,
      bool major,
      String loadingError,
      List<InstrumentHeader> headers,
      List<Map<String, dynamic>> instrumentDtl,
      List<CoordinatesDtl> coordinatesDtl}) {
    return SalesInsightInstrumentState(
      loadingStatus: loadingStatus ?? this.loadingStatus,
      loadingMessage: loadingMessage ?? this.loadingMessage,
      loadingError: loadingError ?? this.loadingError,
      margin: margin ?? this.margin,
      major: major ?? this.major,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
      headers: headers ?? this.headers,
      instrumentDtl: instrumentDtl ?? this.instrumentDtl,
      coordinatesDtl: coordinatesDtl ?? this.coordinatesDtl,
    );
  }

  factory SalesInsightInstrumentState.initial() {
    return SalesInsightInstrumentState(
      headers: null,
      instrumentDtl: null,
      coordinatesDtl: null,
      loadingStatus: LoadingStatus.success,
      loadingMessage: "",
      loadingError: "",
      fromDate: DateTime(DateTime.now().year, 1),
      toDate: DateTime.now(),
    );
  }
}
